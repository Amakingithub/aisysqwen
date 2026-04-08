# 🎯 Sauvegarde System - Quick Start Guide

> Get your continuous backup system running in under 5 minutes!

---

## ✅ What's Already Done

Your backup system is **fully set up and initialized**! Here's what's ready:

- ✅ Local git repository created: `C:\Users\HPM\qwen-autoclaw-backup`
- ✅ Initial commit with all your files (32 files backed up!)
- ✅ Backup scripts created and tested
- ✅ Documentation complete
- ✅ Qwen Code configuration backed up
- ✅ AutoClaw/OpenClaw configuration backed up
- ✅ Gemini CLI mission mandate backed up

---

## 🚀 Next Steps (Connect to GitHub)

### Step 1: Create GitHub Repository (1 minute)

1. Go to https://github.com/new
2. Repository name: `qwen-autoclaw-backup`
3. **Make it Private** ⚠️ (contains configuration)
4. DON'T initialize with README (we already have one)
5. Click "Create repository"
6. Copy the repository URL (looks like: `https://github.com/yourusername/qwen-autoclaw-backup.git`)

### Step 2: Connect Local Repo to GitHub (1 minute)

Open PowerShell and run:

```powershell
cd C:\Users\HPM\qwen-autoclaw-backup

# Add GitHub remote (replace with YOUR URL)
git remote add origin https://github.com/YOUR_USERNAME/qwen-autoclaw-backup.git

# Configure your git identity (one-time)
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

### Step 3: Configure Authentication (1 minute)

**Option A: Personal Access Token (Easiest)**

```powershell
# 1. Create token: https://github.com/settings/tokens/new
#    - Select: "repo" (full control of private repositories)
#    - Click "Generate token"
#    - COPY THE TOKEN (you won't see it again!)

# 2. Configure git to remember credentials
git config --global credential.helper store

# 3. Push (will ask for credentials once)
git push -u origin main
# Username: your GitHub username
# Password: paste your personal access token
```

**Option B: GitHub CLI (Alternative)**

```powershell
# Install GitHub CLI: https://cli.github.com/
gh auth login
# Follow prompts to authenticate
# Then push
git push -u origin main
```

### Step 4: Install Auto-Backup (1 minute)

```powershell
# Navigate to scripts
cd C:\Users\HPM\.qwen\sauvegarde-system\scripts

# Install automated watcher (runs every 5 minutes)
.\watch-and-commit.ps1 -Install

# Verify it's running
Get-ScheduledTask -TaskName "QwenAutoClawBackup-Watcher"
```

---

## 🎉 Done! Your System is Now Active

### What Happens Now

✅ **Every 5 minutes:** System checks for file changes and auto-commits  
✅ **Before tasks:** You can run checkpoint backup manually  
✅ **On changes:** Settings, configs, workspace files all tracked  
✅ **Pushed to GitHub:** Everything safe in cloud  

### Manual Backup Commands

```powershell
# Full backup anytime
cd C:\Users\HPM\.qwen\sauvegarde-system\scripts
.\backup-all.ps1

# Pre-task checkpoint
.\backup-before-task.ps1 -TaskDescription "What you're about to do"

# Check backup status
cd C:\Users\HPM\qwen-autoclaw-backup
git log --oneline -10
```

### Restore Commands (If Needed)

```powershell
# Restore Qwen Code
.\restore-qwen.ps1

# Restore AutoClaw
.\restore-autoclaw.ps1

# Restore from specific commit
.\restore-qwen.ps1 -Commit "abc1234"
```

---

## 📊 What's Being Backed Up

### Qwen Code
- ✅ Settings and configuration
- ✅ Knowledge base documentation
- ✅ Skills and projects
- ✅ Custom scripts

### AutoClaw/OpenClaw
- ✅ Main configuration (openclaw.json)
- ✅ Known-good configuration backup
- ✅ Workspace files (AGENTS.md, SOUL.md, etc.)
- ✅ Agents and skills
- ✅ Architecture and findings docs

### Gemini CLI
- ✅ Mission mandate (GEMINI.md)

---

## 🔧 Useful Commands

### Check Backup Status
```powershell
# View recent commits
cd C:\Users\HPM\qwen-autoclaw-backup
git log --oneline --since="24 hours ago"

# View backup history
Get-Content logs\backup-history.md -Tail 10

# Check watcher logs
Get-Content logs\watcher.log -Tail 20
```

### Manage Auto-Backup
```powershell
# Check if running
Get-ScheduledTask -TaskName "QwenAutoClawBackup-Watcher" | Select-Object State

# Temporarily disable
Disable-ScheduledTask -TaskName "QwenAutoClawBackup-Watcher"

# Re-enable
Enable-ScheduledTask -TaskName "QwenAutoClawBackup-Watcher"

# Uninstall completely
cd C:\Users\HPM\.qwen\sauvegarde-system\scripts
.\watch-and-commit.ps1 -Uninstall
```

---

## 🆘 Troubleshooting

### Push Fails
```powershell
# Check authentication
git push

# If it asks for credentials again:
# 1. Create new token: https://github.com/settings/tokens/new
# 2. Use it as password
# 3. It will be saved by credential helper
```

### Watcher Not Running
```powershell
# Reinstall
cd C:\Users\HPM\.qwen\sauvegarde-system\scripts
.\watch-and-commit.ps1 -Uninstall
.\watch-and-commit.ps1 -Install
```

### Need to Restore
```powershell
# See what commits are available
cd C:\Users\HPM\qwen-autoclaw-backup
git log --oneline -20

# Restore from specific point
cd scripts
.\restore-qwen.ps1 -Commit "commit_hash_here"
```

---

## 📁 Important Locations

| What | Where |
|------|-------|
| **Backup Repository** | `C:\Users\HPM\qwen-autoclaw-backup` |
| **Backup Scripts** | `C:\Users\HPM\.qwen\sauvegarde-system\scripts\` |
| **Documentation** | `C:\Users\HPM\.qwen\sauvegarde-system\` |
| **Qwen Config** | `C:\Users\HPM\.qwen\` |
| **AutoClaw Config** | `C:\Users\HPM\.openclaw-autoclaw\` |
| **Gemini Config** | `C:\Users\HPM\GEMINI.md` |

---

## 🎯 Your Workflow Going Forward

### Daily Use
1. **Just work normally** - backup is automatic!
2. **Before big tasks:** Run `.\backup-before-task.ps1 -TaskDescription "..."`
3. **Check occasionally:** View backup logs to ensure it's working

### Weekly Check
```powershell
# Quick status check
cd C:\Users\HPM\qwen-autoclaw-backup
git log --oneline -5
```

### Monthly Maintenance
- Review backup size
- Test restore procedure
- Rotate credentials if needed
- Check for any push failures

---

## 🌟 Setting Up on New Machine

When you need to spin up on a new machine:

```powershell
# 1. Clone repository
git clone https://github.com/yourusername/qwen-autoclaw-backup.git
cd qwen-autoclaw-backup

# 2. Run setup
cd scripts
.\setup-new-instance.ps1

# 3. Follow prompts
# That's it!
```

---

## 📚 Full Documentation

For complete details, see:
- **README.md** - System overview
- **SETUP_GUIDE.md** - Detailed setup instructions
- **Scripts** - Each has `-Verbose` flag for debugging

---

**You're all set! 🚀**

The backup system is running and will continuously save your work to GitHub.
