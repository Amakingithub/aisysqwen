# Restore Qwen Code from Backup
# Usage: .\restore-qwen.ps1 [-Commit "commit_hash"] [-Component "settings|skills|all"] [-Force]

param(
    [string]$Commit,
    [ValidateSet("settings", "skills", "projects", "knowledge-base", "all")]
    [string]$Component = "all",
    [switch]$Force
)

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  QWEN CODE RESTORE" -ForegroundColor Cyan
Write-Host "  Time: $timestamp" -ForegroundColor Cyan
if ($Commit) {
    Write-Host "  Commit: $Commit" -ForegroundColor Yellow
}
Write-Host "  Component: $Component" -ForegroundColor Yellow
Write-Host "========================================`n" -ForegroundColor Cyan

$baseDir = "C:\Users\HPM"
$repoDir = Join-Path $baseDir "qwen-autoclaw-backup"
$qwenDir = Join-Path $baseDir ".qwen"

# Verify backup repo exists
if (-not (Test-Path $repoDir)) {
    Write-Host "[ERROR] Backup repository not found: $repoDir" -ForegroundColor Red
    Write-Host "Please clone the backup repository first:" -ForegroundColor Yellow
    Write-Host "  git clone https://github.com/yourusername/qwen-autoclaw-backup.git" -ForegroundColor Gray
    return
}

# Navigate to repo and optionally checkout specific commit
Push-Location $repoDir

try {
    if ($Commit) {
        Write-Host "[CHECKOUT] Restoring from commit: $Commit" -ForegroundColor Yellow
        git checkout $Commit -- .
    }
    
    # Restore based on component
    $restoreMap = @{
        "settings" = @("settings.json", "output-language.md")
        "skills" = @("skills")
        "projects" = @("projects")
        "knowledge-base" = @("*.md", "setup-kb.ps1")
        "all" = @("*")
    }
    
    $filesToRestore = $restoreMap[$Component]
    
    foreach ($pattern in $filesToRestore) {
        $sourcePath = Join-Path (Join-Path $repoDir "qwen-code") $pattern
        
        if (Test-Path $sourcePath) {
            Write-Host "[RESTORE] $pattern" -ForegroundColor Green
            
            try {
                $copyParams = @{
                    Path = $sourcePath
                    Destination = $qwenDir
                    Recurse = $true
                    Force = $Force.IsPresent
                }
                
                Copy-Item @copyParams
                Write-Host "  ✓ Restored" -ForegroundColor Green
            }
            catch {
                Write-Host "  ✗ Failed: $_" -ForegroundColor Red
                if (-not $Force.IsPresent) {
                    Write-Host "  Use -Force to overwrite existing files" -ForegroundColor DarkYellow
                }
            }
        } else {
            Write-Host "  [-] Not found in backup: $pattern" -ForegroundColor DarkYellow
        }
    }
}
finally {
    Pop-Location
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Restore Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Restart Qwen Code if running" -ForegroundColor White
Write-Host "2. Verify settings are correct" -ForegroundColor White
Write-Host "3. Test a simple task to confirm" -ForegroundColor White
Write-Host "`nIf issues occur:" -ForegroundColor Yellow
Write-Host "- Check .qwen\settings.json is valid JSON" -ForegroundColor Gray
Write-Host "- Re-run setup if skills are missing" -ForegroundColor Gray
Write-Host "- Review restored files match expectations" -ForegroundColor Gray
Write-Host "`n========================================`n" -ForegroundColor Cyan
