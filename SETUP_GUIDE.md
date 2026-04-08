# 🚀 Complete Setup Guide - Qwen & AutoClaw Sauvegarde System

> This guide walks you through setting up the continuous backup system from scratch.

---

## 📋 Prerequisites

### Required
- ✅ Git installed (version 2.34+)
- ✅ GitHub account
- ✅ PowerShell 5.1+ (Windows) or PowerShell Core (cross-platform)
- ✅ Qwen Code installed and configured
- ✅ OpenClaw/AutoClaw installed

### Optional
- ⚙️ VS Code or other editor for reviewing backups
- ⚙️ Obsidian (for viewing knowledge bases)

---

## 🎯 Quick Start (5 Minutes)

### Option A: First-Time Setup

```powershell
# 1. Navigate to sauvegarde system
cd C:\Users\HPM\.qwen\sauvegarde-system

# 2. Run the setup script
.\scripts\setup-new-instance.ps1

# 3. Follow prompts to:
#    - Clone GitHub repository
#    - Restore Qwen configuration
#    - Restore AutoClaw configuration
#    - Install automated backup watcher
```

### Option B: Manual Setup

See detailed steps below.

---

## 📖 Detailed Setup Instructions

### Step 1: Create GitHub Repository

1. **Create New Repository**
   - Go to https://github.com/new
   - Repository name: `qwen-autoclaw-backup`
   - Description: "Backup repository for Qwen Code and AutoClaw/OpenClaw instances"
   - **Make it Private** (contains configuration files)
   - Initialize with README
   - Click "Create repository"

2. **Note Repository URL**
   - Copy the clone URL (HTTPS or SSH)
   - Example: `https://github.com/yourusername/qwen-autoclaw-backup.git`

---

### Step 2: Initialize Local Repository

```powershell
# Navigate to backup system
cd C:\Users\HPM\.qwen\sauvegarde-system

# Copy scripts to create initial structure
mkdir $env:USERPROFILE\qwen-autoclaw-backup
cd $env:USERPROFILE\qwen-autoclaw-backup

# Initialize git
git init

# Add remote
git remote add origin https://github.com/yourusername/qwen-autoclaw-backup.git

# Create .gitignore
@"
# Sensitive files
oauth_creds.json
*.key
*.pem
.env
secrets/

# Cache and temp files
*.cache
tmp/
*.log

# OS files
.DS_Store
Thumbs.db
desktop.ini

# Browser extension caches
autoclaw-chrome-*.crx
autoclaw-edge-*.crx

# Downloaded installers
*.exe
*.dmg
*.deb
"@ | Out-File -FilePath ".gitignore" -Encoding UTF8

# Initial commit
git add .gitignore
git commit -m "Initialize backup repository"

# Push to GitHub
git push -u origin main
```

---

### Step 3: Configure Git Authentication

You have two options:

#### Option A: Personal Access Token (Recommended)

```powershell
# 1. Create token at: https://github.com/settings/tokens
#    - Select: repo (full control of private repositories)
#    - Generate and copy token

# 2. Configure git to use token
git config --global credential.helper store

# 3. Next push will prompt for credentials
#    Username: your GitHub username
#    Password: paste your personal access token

# 4. Credentials saved for future pushes
```

#### Option B: SSH Keys

```powershell
# 1. Generate SSH key (if you don't have one)
ssh-keygen -t ed25519 -C "your_email@example.com"

# 2. Add to ssh-agent
Start-Service ssh-agent
ssh-add $env:USERPROFILE\.ssh\id_ed25519

# 3. Add public key to GitHub
#    Copy content of: $env:USERPROFILE\.ssh\id_ed25519.pub
#    Paste at: https://github.com/settings/keys

# 4. Update remote to SSH
git remote set-url origin git@github.com:yourusername/qwen-autoclaw-backup.git
```

---

### Step 4: Perform First Backup

```powershell
# Navigate to scripts
cd C:\Users\HPM\.qwen\sauvegarde-system\scripts

# Run backup
.\backup-all.ps1

# Review what was backed up
# Check git status in repo
cd $env:USERPROFILE\qwen-autoclaw-backup
git log --oneline -5
```

**Expected Output:**
```
========================================
  QWEN & AUTOCLAW BACKUP SYSTEM
  2026-04-08 15:30:00
========================================

--- QWEN CODE BACKUP ---
[BACKUP] Qwen Code...
  ✓ Backed up 25 files

--- AUTOCLAW/OPENCLAW BACKUP ---
[BACKUP] AutoClaw/OpenClaw...
  ✓ Backed up 18 files

--- GEMINI CLI BACKUP ---
[BACKUP] Gemini CLI...
  ✓ Backed up 1 files

--- GIT BACKUP ---
[GIT] Committed: checkpoint: scheduled backup - 2026-04-08 15:30:00
[GIT] Pushed to remote

========================================
  BACKUP SUMMARY
========================================
Components: 3/3 backed up
Repository: C:\Users\HPM\qwen-autoclaw-backup
Timestamp: 2026-04-08 15:30:00

[SUCCESS] Backup completed
========================================
```

---

### Step 5: Install Automated Backup Watcher

This runs every 5 minutes and auto-commits changes:

```powershell
# Install as Windows Scheduled Task
cd C:\Users\HPM\.qwen\sauvegarde-system\scripts
.\watch-and-commit.ps1 -Install
```

**What this does:**
- Creates scheduled task: `QwenAutoClawBackup-Watcher`
- Runs every 5 minutes
- Monitors critical files for changes
- Auto-commits and pushes to GitHub
- Logs all activity to `logs/watcher.log`

**Verify Installation:**
```powershell
# Check scheduled task
Get-ScheduledTask -TaskName "QwenAutoClawBackup-Watcher"

# View recent watcher logs
Get-Content C:\Users\HPM\qwen-autoclaw-backup\logs\watcher.log -Tail 20
```

**Uninstall if Needed:**
```powershell
.\watch-and-commit.ps1 -Uninstall
```

---

### Step 6: Configure Pre-Task Backup

This ensures a checkpoint before every new task:

**Option A: Manual Trigger**
```powershell
# Before starting a new task, run:
.\backup-before-task.ps1 -TaskDescription "Build new feature X"
```

**Option B: Integrate with Qwen Code Workflow**
- Add to your workflow: always run backup before asking Qwen to do something
- The script creates a checkpoint you can restore if needed

---

### Step 7: Test Restore Procedure

**Critical:** Verify you can restore from backup!

```powershell
# Test restoring Qwen Code
.\restore-qwen.ps1 -Test

# Test restoring AutoClaw
.\restore-autoclaw.ps1 -Test

# Full restore on staging (optional but recommended)
# Use a test machine or VM
```

---

## 🔧 Advanced Configuration

### Custom Backup Schedule

If you want different than every 5 minutes:

```powershell
# Uninstall current watcher
.\watch-and-commit.ps1 -Uninstall

# Manually create task with custom interval
$taskName = "QwenAutoClawBackup-Watcher"
$scriptPath = "C:\Users\HPM\qwen-autoclaw-backup\scripts\watch-and-commit.ps1"

# Every 15 minutes instead
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -File `"$scriptPath`""
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 15)
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -User $env:USERNAME
```

### Selective Backup

```powershell
# Backup only specific components
# Edit backup-all.ps1 and comment out sections you don't need

# Or backup individual components:
.\backup-all.ps1  # Currently backs up everything
```

### Multiple Machine Sync

If you have multiple machines:

```powershell
# On Machine 1:
# 1. Push backup to GitHub
.\backup-all.ps1

# On Machine 2:
# 1. Pull latest
cd C:\Users\HPM\qwen-autoclaw-backup
git pull origin main

# 2. Restore
cd scripts
.\restore-qwen.ps1
.\restore-autoclaw.ps1
```

---

## 📊 Monitoring & Maintenance

### Check Backup Status

```powershell
# View recent backups
Get-Content C:\Users\HPM\qwen-autoclaw-backup\logs\backup-history.md -Tail 20

# View watcher logs
Get-Content C:\Users\HPM\qwen-autoclaw-backup\logs\watcher.log -Tail 50

# Check git log
cd C:\Users\HPM\qwen-autoclaw-backup
git log --oneline --since="24 hours ago"
```

### Weekly Maintenance Tasks

```powershell
# 1. Verify backup is running
Get-ScheduledTask -TaskName "QwenAutoClawBackup-Watcher" | Select-Object State

# 2. Check for any push failures
cd C:\Users\HPM\qwen-autoclaw-backup
git status

# 3. Review backup size
Get-ChildItem -Recurse | Measure-Object -Property Length -Sum

# 4. Test restore (optional)
cd scripts
.\restore-qwen.ps1 -Test
```

### Monthly Maintenance

1. **Rotate credentials** if any were accidentally committed
2. **Review .gitignore** to ensure no sensitive files tracked
3. **Test full restore** on a clean machine
4. **Update scripts** if new components added
5. **Check repository size** and clean old logs if needed

---

## 🚨 Troubleshooting

### Backup Fails - Git Authentication

**Problem:** Push fails with authentication error

**Solution:**
```powershell
# Clear stored credentials
Remove-Item $env:USERPROFILE\.git-credentials -ErrorAction SilentlyContinue

# Re-configure
git config --global credential.helper store

# Try push again - will prompt for credentials
cd C:\Users\HPM\qwen-autoclaw-backup
git push
```

### Watcher Not Running

**Problem:** No automatic backups happening

**Solution:**
```powershell
# Check if scheduled task exists
Get-ScheduledTask -TaskName "QwenAutoClawBackup-Watcher" -ErrorAction SilentlyContinue

# If missing, reinstall
cd C:\Users\HPM\.qwen\sauvegarde-system\scripts
.\watch-and-commit.ps1 -Install

# Check task status
Get-ScheduledTask -TaskName "QwenAutoClawBackup-Watcher" | Select-Object State
```

### Restore Fails - Files in Use

**Problem:** Can't restore because files are locked

**Solution:**
```powershell
# Stop Qwen Code and OpenClaw first
# Then restore with -Force flag
.\restore-qwen.ps1 -Force
.\restore-autoclaw.ps1 -Force
```

### Repository Too Large

**Problem:** Git repository growing too big

**Solution:**
```powershell
# Clean old logs
cd C:\Users\HPM\qwen-autoclaw-backup
Remove-Item logs\*.log -Force

# Compress git objects
git gc --aggressive

# If needed, reset history and start fresh
git checkout --orphan fresh-start
git add .
git commit -m "Fresh start - $(Get-Date)"
git push -f origin main
```

---

## 🤝 Integration with Other Tools

### Gemini CLI

Gemini CLI has its own backup mechanism. This system:

- ✅ **Compatible:** Both can push to same repository
- ✅ **Redundant:** Multiple backup sources = more safety
- ✅ **No conflicts:** Git handles concurrent pushes gracefully

**No special configuration needed** - just ensure both systems push to the same repo.

### CI/CD Integration (Future)

You could add GitHub Actions to:
- Validate backups succeed
- Send notifications on backup failures
- Automatically test restore procedures

---

## 📚 Additional Resources

- **Quick Reference:** See `README.md` in sauvegarde-system
- **Script Documentation:** Each script has `-Verbose` flag for detailed logging
- **Git Help:** `git help` for general git commands
- **PowerShell Help:** `Get-Help .\script-name.ps1 -Full` for any script

---

## ✅ Setup Checklist

Use this to verify complete setup:

- [ ] GitHub repository created (private)
- [ ] Local repository cloned
- [ ] Git authentication configured and tested
- [ ] First backup completed successfully
- [ ] Backup pushed to GitHub
- [ ] Watcher installed and running
- [ ] Restore procedure tested
- [ ] Backup logs reviewed
- [ ] .gitignore properly configured
- [ ] No sensitive files tracked

---

**Setup Complete!** 🎉

Your Qwen Code and AutoClaw instances are now continuously backed up to GitHub.

**Next:** Start using the system and it will work automatically!
