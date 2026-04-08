# Pre-Task Backup Script
# Runs before each new task to checkpoint current state
# Usage: .\backup-before-task.ps1 -TaskDescription "Description of upcoming task"

param(
    [Parameter(Mandatory=$true)]
    [string]$TaskDescription
)

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$dateStamp = Get-Date -Format "yyyy-MM-dd"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  PRE-TASK BACKUP" -ForegroundColor Cyan
Write-Host "  Task: $TaskDescription" -ForegroundColor Yellow
Write-Host "  Time: $timestamp" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$baseDir = "C:\Users\HPM"
$repoDir = Join-Path $baseDir "qwen-autoclaw-backup"

# Quick backup of critical files
$filesToBackup = @(
    @{Source = ".qwen\settings.json"; Dest = "qwen-code\"; Desc = "Qwen Settings"},
    @{Source = ".openclaw-autoclaw\openclaw.json"; Dest = "openclaw-autoclaw\"; Desc = "AutoClaw Config"},
    @{Source = ".openclaw-autoclaw\workspace\"; Dest = "openclaw-autoclaw\workspace\"; Desc = "AutoClaw Workspace"},
    @{Source = "GEMINI.md"; Dest = "gemini-cli\"; Desc = "Gemini Mission"}
)

$successCount = 0

foreach ($file in $filesToBackup) {
    $sourcePath = Join-Path $baseDir $file.Source
    $destPath = Join-Path $repoDir $file.Dest
    
    if (Test-Path $sourcePath) {
        if (-not (Test-Path $destPath)) {
            New-Item -ItemType Directory -Force -Path $destPath | Out-Null
        }
        
        try {
            if ((Get-Item $sourcePath) -is [System.IO.DirectoryInfo]) {
                Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Force
            } else {
                Copy-Item -Path $sourcePath -Destination $destPath -Force
            }
            Write-Host "[✓] $($file.Desc)" -ForegroundColor Green
            $successCount++
        }
        catch {
            Write-Host "[✗] $($file.Desc): $_" -ForegroundColor Red
        }
    } else {
        Write-Host "[-] $($file.Desc) - Not found" -ForegroundColor DarkYellow
    }
}

# Commit with task-aware message
Push-Location $repoDir

try {
    git add .
    $status = git status --porcelain
    
    if ($status) {
        $commitMsg = "checkpoint: before task - $TaskDescription - $timestamp"
        git commit -m $commitMsg
        Write-Host "`n[GIT] Committed: $commitMsg" -ForegroundColor Green
        
        # Quick push attempt
        git push origin main 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[GIT] Pushed to remote" -ForegroundColor Green
        } else {
            Write-Host "[GIT] Push deferred - run manually if needed" -ForegroundColor DarkYellow
        }
    } else {
        Write-Host "`n[GIT] No changes detected" -ForegroundColor DarkYellow
    }
}
finally {
    Pop-Location
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Pre-task backup complete" -ForegroundColor Green
Write-Host "  Files: $successCount/$($filesToBackup.Count)" -ForegroundColor White
Write-Host "  Ready for task: $TaskDescription" -ForegroundColor Yellow
Write-Host "========================================`n" -ForegroundColor Cyan
