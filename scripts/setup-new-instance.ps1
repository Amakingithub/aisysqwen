# Setup New Instance from Backup
# Usage: .\setup-new-instance.ps1 [-QwenPath "C:\Users\YourUser"] [-OpenClawPath "C:\Users\YourUser"] [-SkipGit]
# This sets up Qwen Code and AutoClaw from the GitHub backup repository

param(
    [string]$QwenPath,
    [string]$OpenClawPath,
    [switch]$SkipGit
)

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  NEW INSTANCE SETUP" -ForegroundColor Cyan
Write-Host "  Time: $timestamp" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Determine paths
if (-not $QwenPath) {
    $QwenPath = $env:USERPROFILE
    Write-Host "[INFO] Using default Qwen path: $QwenPath" -ForegroundColor DarkGray
}

if (-not $OpenClawPath) {
    $OpenClawPath = $env:USERPROFILE
    Write-Host "[INFO] Using default OpenClaw path: $OpenClawPath" -ForegroundColor DarkGray
}

$repoDir = Join-Path $QwenPath "qwen-autoclaw-backup"

# Step 1: Clone repository
if (-not $SkipGit) {
    Write-Host "`n--- STEP 1: CLONE BACKUP REPOSITORY ---" -ForegroundColor Cyan
    
    if (Test-Path $repoDir) {
        Write-Host "[FOUND] Repository already exists at: $repoDir" -ForegroundColor Yellow
        Write-Host "Pull latest changes?" -ForegroundColor Yellow
        $response = Read-Host "(y/n)"
        
        if ($response -eq "y" -or $response -eq "Y") {
            Push-Location $repoDir
            git pull origin main
            Pop-Location
        }
    } else {
        Write-Host "Enter your backup repository URL:" -ForegroundColor Yellow
        Write-Host "(e.g., https://github.com/yourusername/qwen-autoclaw-backup.git)" -ForegroundColor DarkGray
        $repoUrl = Read-Host "Repository URL"
        
        if ($repoUrl) {
            Write-Host "`n[CLONE] Cloning repository..." -ForegroundColor Green
            git clone $repoUrl $repoDir
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[OK] Repository cloned" -ForegroundColor Green
            } else {
                Write-Host "[ERROR] Clone failed" -ForegroundColor Red
                return
            }
        } else {
            Write-Host "[SKIP] No repository URL provided" -ForegroundColor Yellow
        }
    }
}

# Step 2: Setup Qwen Code
Write-Host "`n--- STEP 2: SETUP QWEN CODE ---" -ForegroundColor Cyan

$qwenDir = Join-Path $QwenPath ".qwen"
$qwenBackup = Join-Path $repoDir "qwen-code"

if (Test-Path $qwenBackup) {
    if (Test-Path $qwenDir) {
        Write-Host "[FOUND] Qwen directory exists" -ForegroundColor Yellow
        Write-Host "Overwrite with backup?" -ForegroundColor Yellow
        $response = Read-Host "(y/n)"
        
        if ($response -ne "y" -and $response -ne "Y") {
            Write-Host "[SKIP] Qwen setup skipped" -ForegroundColor DarkYellow
        }
    }
    
    if ($response -eq "y" -or $response -eq "Y" -or -not (Test-Path $qwenDir)) {
        Write-Host "[RESTORE] Setting up Qwen Code from backup..." -ForegroundColor Green
        
        # Create .qwen directory
        if (-not (Test-Path $qwenDir)) {
            New-Item -ItemType Directory -Force -Path $qwenDir | Out-Null
        }
        
        # Copy all backup files
        Copy-Item -Path "$qwenBackup\*" -Destination $qwenDir -Recurse -Force
        
        Write-Host "[OK] Qwen Code restored" -ForegroundColor Green
        Write-Host "  Location: $qwenDir" -ForegroundColor DarkGray
        Write-Host "  Files: $((Get-ChildItem $qwenDir -Recurse -File).Count)" -ForegroundColor DarkGray
    }
} else {
    Write-Host "[SKIP] No Qwen backup found in repository" -ForegroundColor DarkYellow
}

# Step 3: Setup AutoClaw/OpenClaw
Write-Host "`n--- STEP 3: SETUP AUTOCLAW/OPENCLAW ---" -ForegroundColor Cyan

$openClawDir = Join-Path $OpenClawPath ".openclaw-autoclaw"
$openClawBackup = Join-Path $repoDir "openclaw-autoclaw"

if (Test-Path $openClawBackup) {
    if (Test-Path $openClawDir) {
        Write-Host "[FOUND] OpenClaw directory exists" -ForegroundColor Yellow
        Write-Host "Overwrite with backup?" -ForegroundColor Yellow
        $response = Read-Host "(y/n)"
        
        if ($response -ne "y" -and $response -ne "Y") {
            Write-Host "[SKIP] OpenClaw setup skipped" -ForegroundColor DarkYellow
        }
    }
    
    if ($response -eq "y" -or $response -eq "Y" -or -not (Test-Path $openClawDir)) {
        Write-Host "[RESTORE] Setting up AutoClaw from backup..." -ForegroundColor Green
        
        # Create directory
        if (-not (Test-Path $openClawDir)) {
            New-Item -ItemType Directory -Force -Path $openClawDir | Out-Null
        }
        
        # Copy all backup files
        Copy-Item -Path "$openClawBackup\*" -Destination $openClawDir -Recurse -Force
        
        Write-Host "[OK] AutoClaw restored" -ForegroundColor Green
        Write-Host "  Location: $openClawDir" -ForegroundColor DarkGray
        Write-Host "  Files: $((Get-ChildItem $openClawDir -Recurse -File).Count)" -ForegroundColor DarkGray
    }
} else {
    Write-Host "[SKIP] No AutoClaw backup found in repository" -ForegroundColor DarkYellow
}

# Step 4: Setup Gemini CLI
Write-Host "`n--- STEP 4: SETUP GEMINI CLI ---" -ForegroundColor Cyan

$geminiBackup = Join-Path $repoDir "gemini-cli\GEMINI.md"
$geminiDest = Join-Path $OpenClawPath "GEMINI.md"

if (Test-Path $geminiBackup) {
    Write-Host "[RESTORE] Copying Gemini mission mandate..." -ForegroundColor Green
    Copy-Item -Path $geminiBackup -Destination $geminiDest -Force
    Write-Host "[OK] Gemini CLI configured" -ForegroundColor Green
} else {
    Write-Host "[SKIP] No Gemini backup found" -ForegroundColor DarkYellow
}

# Step 5: Setup automated backup
Write-Host "`n--- STEP 5: SETUP AUTOMATED BACKUP ---" -ForegroundColor Cyan

$scriptsDir = Join-Path $repoDir "scripts"

if (Test-Path $scriptsDir) {
    Write-Host "Install automated backup watcher?" -ForegroundColor Yellow
    Write-Host "  This will backup every 5 minutes automatically" -ForegroundColor DarkGray
    $response = Read-Host "(y/n)"
    
    if ($response -eq "y" -or $response -eq "Y") {
        Push-Location $scriptsDir
        & ".\watch-and-commit.ps1" -Install
        Pop-Location
    }
} else {
    Write-Host "[SKIP] No backup scripts found" -ForegroundColor DarkYellow
}

# Step 6: Verify setup
Write-Host "`n--- VERIFICATION ---" -ForegroundColor Cyan

$checks = @(
    @{Name = "Qwen Code"; Path = $qwenDir; Required = $true},
    @{Name = "AutoClaw"; Path = $openClawDir; Required = $true},
    @{Name = "Gemini CLI"; Path = $geminiDest; Required = $false},
    @{Name = "Backup Repo"; Path = $repoDir; Required = $true}
)

$passedCount = 0

foreach ($check in $checks) {
    if (Test-Path $check.Path) {
        Write-Host "[✓] $($check.Name)" -ForegroundColor Green
        $passedCount++
    } elseif ($check.Required) {
        Write-Host "[✗] $($check.Name) - REQUIRED BUT MISSING" -ForegroundColor Red
    } else {
        Write-Host "[-] $($check.Name) - Optional" -ForegroundColor DarkYellow
    }
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  SETUP COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`nStatus: $passedCount/$($checks.Count) components verified" -ForegroundColor White

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Restart Qwen Code" -ForegroundColor White
Write-Host "2. Restart OpenClaw (if running)" -ForegroundColor White
Write-Host "3. Run test backup: .\scripts\backup-all.ps1 -Test" -ForegroundColor White
Write-Host "4. Configure git credentials for auto-push:" -ForegroundColor White
Write-Host "   git config --global credential.helper store" -ForegroundColor Gray
Write-Host "5. Test restoring from backup to verify system" -ForegroundColor White

Write-Host "`nImportant:" -ForegroundColor Yellow
Write-Host "- Update repository URL in scripts if different" -ForegroundColor Gray
Write-Host "- Set up GitHub authentication" -ForegroundColor Gray
Write-Host "- Test full restore on a clean machine" -ForegroundColor Gray
Write-Host "- Keep known-good config: copy openclaw.json to openclaw.json.known-good" -ForegroundColor Gray

Write-Host "`n========================================`n" -ForegroundColor Cyan
