# File Watcher - Monitors changes and auto-commits to GitHub
# Usage: .\watch-and-commit.ps1 [-Install] [-Uninstall]
# This runs in background and detects file changes

param(
    [switch]$Install,
    [switch]$Uninstall
)

$baseDir = "C:\Users\HPM"
$repoDir = Join-Path $baseDir "qwen-autoclaw-backup"
$watcherLog = Join-Path $repoDir "logs\watcher.log"

# Files to monitor
$watchPaths = @(
    (Join-Path $baseDir ".qwen\settings.json"),
    (Join-Path $baseDir ".openclaw-autoclaw\openclaw.json"),
    (Join-Path $baseDir "GEMINI.md"),
    (Join-Path $baseDir ".qwen")
)

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $Message"
    Write-Host $logEntry
    
    $logDir = Join-Path $repoDir "logs"
    if (-not (Test-Path $logDir)) {
        New-Item -ItemType Directory -Force -Path $logDir | Out-Null
    }
    
    $logEntry | Out-File -FilePath $watcherLog -Append -Encoding UTF8
}

# Install as scheduled task
if ($Install) {
    Write-Host "`nInstalling file watcher as scheduled task..." -ForegroundColor Cyan
    
    $taskName = "QwenAutoClawBackup-Watcher"
    $scriptPath = Join-Path $repoDir "scripts\watch-and-commit.ps1"
    
    # Remove existing task if present
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
    
    # Create new scheduled task (runs every 5 minutes)
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -File `"$scriptPath`""
    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5)
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
    
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -User $env:USERNAME -RunLevel Limited | Out-Null
    
    Write-Host "✓ File watcher installed as scheduled task" -ForegroundColor Green
    Write-Host "  Runs every 5 minutes" -ForegroundColor DarkGray
    Write-Host "  Task Name: $taskName" -ForegroundColor DarkGray
    Write-Host "  To uninstall: .\watch-and-commit.ps1 -Uninstall" -ForegroundColor DarkGray
    return
}

# Uninstall scheduled task
if ($Uninstall) {
    Write-Host "`nUninstalling file watcher..." -ForegroundColor Cyan
    
    $taskName = "QwenAutoClawBackup-Watcher"
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
    
    Write-Host "✓ File watcher uninstalled" -ForegroundColor Green
    return
}

# Main watcher logic - runs once (called by scheduled task)
Write-Log "Watcher started"

# Check each watched path
$changesDetected = $false

foreach ($watchPath in $watchPaths) {
    if (-not (Test-Path $watchPath)) {
        continue
    }
    
    # Get the file/directory
    $item = Get-Item $watchPath
    
    # For directories, check recent changes (last 10 minutes)
    if ($item -is [System.IO.DirectoryInfo]) {
        $recentFiles = Get-ChildItem -Path $watchPath -Recurse -File | Where-Object {
            $_.LastWriteTime -gt (Get-Date).AddMinutes(-10)
        }
        
        if ($recentFiles) {
            Write-Log "Changes detected in directory: $watchPath"
            Write-Log "  Modified files: $($recentFiles.Count)"
            $changesDetected = $true
        }
    }
    # For files, check if modified in last 10 minutes
    else {
        if ($item.LastWriteTime -gt (Get-Date).AddMinutes(-10)) {
            Write-Log "File modified: $watchPath"
            Write-Log "  Last write: $($item.LastWriteTime)"
            $changesDetected = $true
        }
    }
}

# If changes detected, backup and commit
if ($changesDetected) {
    Write-Log "Running backup..."
    
    Push-Location $repoDir
    
    try {
        git add .
        $status = git status --porcelain
        
        if ($status) {
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $commitMsg = "auto: detected file changes - $timestamp"
            git commit -m $commitMsg
            Write-Log "Committed: $commitMsg"
            
            # Try push
            git push origin main 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Log "Pushed to remote"
            } else {
                Write-Log "Push deferred"
            }
        } else {
            Write-Log "No git changes detected"
        }
    }
    catch {
        Write-Log "ERROR: $_"
    }
    finally {
        Pop-Location
    }
} else {
    Write-Log "No changes detected"
}

Write-Log "Watcher cycle complete"
