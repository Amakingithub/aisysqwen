# Complete Backup Script for Qwen Code & AutoClaw/OpenClaw
# Usage: .\backup-all.ps1 [-Test] [-Verbose]

param(
    [switch]$Test,
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$dateStamp = Get-Date -Format "yyyy-MM-dd"

if ($Verbose) {
    $VerbosePreference = "Continue"
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  QWEN & AUTOCLAW BACKUP SYSTEM" -ForegroundColor Cyan
Write-Host "  $timestamp" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Configuration
$baseDir = "C:\Users\HPM"
$qwenDir = Join-Path $baseDir ".qwen"
$openClawDir = Join-Path $baseDir ".openclaw-autoclaw"
$geminiFile = Join-Path $baseDir "GEMINI.md"

# Backup repository paths (update with your repo location)
$repoDir = Join-Path $baseDir "qwen-autoclaw-backup"

# Function to check if running in test mode
function Test-ModeCheck {
    if ($Test) {
        Write-Host "[TEST MODE] Would backup: $args" -ForegroundColor Yellow
        return $true
    }
    return $false
}

# Function to backup a component
function Backup-Component {
    param(
        [string]$Source,
        [string]$Dest,
        [string]$ComponentName,
        [array]$Include = @("*"),
        [array]$Exclude = @()
    )
    
    if (-not (Test-Path $Source)) {
        Write-Host "[SKIP] $ComponentName - Source not found: $Source" -ForegroundColor DarkYellow
        return $false
    }
    
    if (Test-ModeCheck $ComponentName) { return $true }
    
    Write-Host "[BACKUP] $ComponentName..." -ForegroundColor Green
    
    # Create destination if needed
    if (-not (Test-Path $Dest)) {
        New-Item -ItemType Directory -Force -Path $Dest | Out-Null
    }
    
    # Copy files
    $copyParams = @{
        Path = $Source
        Destination = $Dest
        Recurse = $true
        Force = $true
    }
    
    try {
        Copy-Item @copyParams
        $fileCount = (Get-ChildItem $Dest -Recurse -File).Count
        Write-Host "  ✓ Backed up $fileCount files" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  ✗ Failed: $_" -ForegroundColor Red
        return $false
    }
}

# Function to update git
function Update-GitBackup {
    param(
        [string]$CommitMessage
    )
    
    if ($Test) {
        Write-Host "[TEST MODE] Would commit: $CommitMessage" -ForegroundColor Yellow
        return
    }
    
    if (-not (Test-Path (Join-Path $repoDir ".git"))) {
        Write-Host "[INIT] Initializing git repository..." -ForegroundColor Yellow
        Push-Location $repoDir
        git init
        git remote add origin https://github.com/yourusername/qwen-autoclaw-backup.git 2>$null
        Pop-Location
    }
    
    Push-Location $repoDir
    
    try {
        git add .
        $status = git status --porcelain
        
        if ($status) {
            git commit -m $CommitMessage
            Write-Host "[GIT] Committed: $CommitMessage" -ForegroundColor Green
            
            # Try to push (may require authentication)
            $pushResult = git push origin main 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[GIT] Pushed to remote" -ForegroundColor Green
            } else {
                Write-Host "[WARN] Push failed - may need authentication" -ForegroundColor Yellow
                Write-Host "  Run 'git push' manually if needed" -ForegroundColor DarkYellow
            }
        } else {
            Write-Host "[GIT] No changes to commit" -ForegroundColor DarkYellow
        }
    }
    catch {
        Write-Host "[ERROR] Git operation failed: $_" -ForegroundColor Red
    }
    finally {
        Pop-Location
    }
}

# Main backup logic
$successCount = 0
$totalCount = 0

# 1. Backup Qwen Code
Write-Host "`n--- QWEN CODE BACKUP ---" -ForegroundColor Cyan
$totalCount++

if (Test-Path $qwenDir) {
    $qwenDest = Join-Path $repoDir "qwen-code"
    $result = Backup-Component -Source $qwenDir -Dest $qwenDest -ComponentName "Qwen Code"
    if ($result) { $successCount++ }
}

# 2. Backup OpenClaw/AutoClaw
Write-Host "`n--- AUTOCLAW/OPENCLAW BACKUP ---" -ForegroundColor Cyan
$totalCount++

if (Test-Path $openClawDir) {
    $openClawDest = Join-Path $repoDir "openclaw-autoclaw"
    $result = Backup-Component -Source $openClawDir -Dest $openClawDest -ComponentName "AutoClaw/OpenClaw"
    if ($result) { $successCount++ }
}

# 3. Backup Gemini CLI config
Write-Host "`n--- GEMINI CLI BACKUP ---" -ForegroundColor Cyan
$totalCount++

if (Test-Path $geminiFile) {
    $geminiDest = Join-Path $repoDir "gemini-cli"
    $result = Backup-Component -Source $geminiFile -Dest $geminiDest -ComponentName "Gemini CLI"
    if ($result) { $successCount++ }
}

# 4. Commit and push
Write-Host "`n--- GIT BACKUP ---" -ForegroundColor Cyan

$commitMsg = "checkpoint: scheduled backup - $timestamp"
Update-GitBackup -CommitMessage $commitMsg

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  BACKUP SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Components: $successCount/$totalCount backed up" -ForegroundColor $(if ($successCount -eq $totalCount) { "Green" } else { "Yellow" })
Write-Host "Repository: $repoDir" -ForegroundColor White
Write-Host "Timestamp: $timestamp" -ForegroundColor White

if ($Test) {
    Write-Host "`n[TEST MODE] No actual backup performed" -ForegroundColor Yellow
} else {
    Write-Host "`n[SUCCESS] Backup completed" -ForegroundColor Green
}

Write-Host "========================================`n" -ForegroundColor Cyan

# Log to history
$logDir = Join-Path $repoDir "logs"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Force -Path $logDir | Out-Null
}

$logEntry = @"

## $timestamp
- **Status:** $(if ($successCount -eq $totalCount) { "SUCCESS" } else { "PARTIAL" })
- **Components:** $successCount/$totalCount
- **Type:** $(if ($Test) { "TEST" } else { "LIVE" })
- **Commit:** $commitMsg
"@

$logFile = Join-Path $logDir "backup-history.md"
if (-not (Test-Path $logFile)) {
    "# Backup History`n" | Out-File -FilePath $logFile -Encoding UTF8
}

$logEntry | Out-File -FilePath $logFile -Append -Encoding UTF8
