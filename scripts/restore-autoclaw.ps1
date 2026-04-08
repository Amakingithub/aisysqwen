# Restore AutoClaw/OpenClaw from Backup
# Usage: .\restore-autoclaw.ps1 [-Commit "commit_hash"] [-Force] [-SkipInstall]

param(
    [string]$Commit,
    [switch]$Force,
    [switch]$SkipInstall
)

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  AUTOCLAW/OPENCLAW RESTORE" -ForegroundColor Cyan
Write-Host "  Time: $timestamp" -ForegroundColor Cyan
if ($Commit) {
    Write-Host "  Commit: $Commit" -ForegroundColor Yellow
}
Write-Host "========================================`n" -ForegroundColor Cyan

$baseDir = "C:\Users\HPM"
$repoDir = Join-Path $baseDir "qwen-autoclaw-backup"
$openClawDir = Join-Path $baseDir ".openclaw-autoclaw"

# Verify backup repo exists
if (-not (Test-Path $repoDir)) {
    Write-Host "[ERROR] Backup repository not found: $repoDir" -ForegroundColor Red
    Write-Host "Please clone the backup repository first:" -ForegroundColor Yellow
    Write-Host "  git clone https://github.com/yourusername/qwen-autoclaw-backup.git" -ForegroundColor Gray
    return
}

# Check if OpenClaw is installed
if (-not $SkipInstall) {
    Write-Host "[CHECK] Verifying OpenClaw installation..." -ForegroundColor Cyan
    
    $openClawExists = Get-Command "openclaw" -ErrorAction SilentlyContinue
    
    if (-not $openClawExists) {
        Write-Host "[INSTALL] OpenClaw not detected" -ForegroundColor Yellow
        Write-Host "To install OpenClaw, run:" -ForegroundColor Yellow
        Write-Host "  npm install -g openclaw" -ForegroundColor Gray
        Write-Host "`nOr download from official source" -ForegroundColor Gray
        Write-Host "Continue with restore anyway? (y/n)" -ForegroundColor Yellow
        
        $response = Read-Host
        if ($response -ne "y" -and $response -ne "Y") {
            Write-Host "Restore cancelled" -ForegroundColor Yellow
            return
        }
    } else {
        Write-Host "[OK] OpenClaw is installed" -ForegroundColor Green
    }
}

# Navigate to repo and optionally checkout specific commit
Push-Location $repoDir

try {
    if ($Commit) {
        Write-Host "[CHECKOUT] Restoring from commit: $Commit" -ForegroundColor Yellow
        git checkout $Commit -- .
    }
    
    $backupDir = Join-Path $repoDir "openclaw-autoclaw"
    
    if (-not (Test-Path $backupDir)) {
        Write-Host "[ERROR] No AutoClaw backup found in repository" -ForegroundColor Red
        return
    }
    
    # Create directory if needed
    if (-not (Test-Path $openClawDir)) {
        Write-Host "[CREATE] Creating OpenClaw directory..." -ForegroundColor Yellow
        New-Item -ItemType Directory -Force -Path $openClawDir | Out-Null
    }
    
    # Restore all components
    $components = @(
        "openclaw.json",
        "openclaw.json.known-good",
        "agents",
        "skills",
        "workspace",
        "cron",
        "canvas",
        "devices"
    )
    
    $restoredCount = 0
    
    foreach ($component in $components) {
        $sourcePath = Join-Path $backupDir $component
        
        if (Test-Path $sourcePath) {
            Write-Host "[RESTORE] $component" -ForegroundColor Green
            
            try {
                $copyParams = @{
                    Path = $sourcePath
                    Destination = $openClawDir
                    Recurse = $true
                    Force = $Force.IsPresent
                }
                
                Copy-Item @copyParams
                $restoredCount++
                Write-Host "  ✓ Restored" -ForegroundColor Green
            }
            catch {
                Write-Host "  ✗ Failed: $_" -ForegroundColor Red
                if (-not $Force.IsPresent) {
                    Write-Host "  Use -Force to overwrite existing files" -ForegroundColor DarkYellow
                }
            }
        } else {
            Write-Host "  [-] Not in backup: $component" -ForegroundColor DarkYellow
        }
    }
}
finally {
    Pop-Location
}

# Verify restoration
Write-Host "`n[VERIFY] Checking restored files..." -ForegroundColor Cyan

$configFile = Join-Path $openClawDir "openclaw.json"
if (Test-Path $configFile) {
    try {
        $config = Get-Content $configFile | ConvertFrom-Json
        Write-Host "[OK] Configuration file valid" -ForegroundColor Green
        
        if ($config.agents.defaults.model.primary) {
            Write-Host "  Model: $($config.agents.defaults.model.primary)" -ForegroundColor DarkGray
        }
    }
    catch {
        Write-Host "[WARN] Configuration file may be invalid: $_" -ForegroundColor Yellow
    }
} else {
    Write-Host "[ERROR] Configuration file not found!" -ForegroundColor Red
}

$workspaceDir = Join-Path $openClawDir "workspace"
if (Test-Path $workspaceDir) {
    $fileCount = (Get-ChildItem $workspaceDir -Recurse -File).Count
    Write-Host "[OK] Workspace restored: $fileCount files" -ForegroundColor Green
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  RESTORE COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`nComponents restored: $restoredCount/$($components.Count)" -ForegroundColor White
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Restart OpenClaw if running" -ForegroundColor White
Write-Host "2. Verify configuration: openclaw status" -ForegroundColor White
Write-Host "3. Test workspace access" -ForegroundColor White
Write-Host "4. Check agents and skills loaded" -ForegroundColor White
Write-Host "`nIf issues occur:" -ForegroundColor Yellow
Write-Host "- Validate openclaw.json is proper JSON" -ForegroundColor Gray
Write-Host "- Check workspace permissions" -ForegroundColor Gray
Write-Host "- Reinstall OpenClaw if needed: npm install -g openclaw" -ForegroundColor Gray
Write-Host "- Compare with known-good config:" -ForegroundColor Gray
Write-Host "  .openclaw-autoclaw\openclaw.json.known-good" -ForegroundColor Gray
Write-Host "`n========================================`n" -ForegroundColor Cyan
