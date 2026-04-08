# 🔄 Qwen Code & AutoClaw/OpenClaw Sauvegarde System

> **Purpose:** Continuous backup system ensuring all Qwen Code configurations, tasks, and AutoClaw/OpenClaw instances are persistently saved to GitHub for portability and disaster recovery.

---

## 📋 System Architecture

### Components Backed Up

1. **Qwen Code Instance**
   - Configuration: `.qwen/settings.json`
   - Skills: `.qwen/skills/`
   - Projects: `.qwen/projects/`
   - Custom files: Knowledge base docs, schemas, scripts
   - OAuth credentials: `.qwen/oauth_creds.json` (encrypted)

2. **AutoClaw/OpenClaw Instance**
   - Configuration: `.openclaw-autoclaw/openclaw.json`
   - Agents: `.openclaw-autoclaw/agents/`
   - Skills: `.openclaw-autoclaw/skills/`
   - Workspace: `.openclaw-autoclaw/workspace/`
   - Cron jobs: `.openclaw-autoclaw/cron/`
   - Canvas: `.openclaw-autoclaw/canvas/`
   - Devices: `.openclaw-autoclaw/devices/`

3. **Gemini CLI Configuration**
   - Mission mandate: `GEMINI.md`
   - Any Gemini-specific configs

---

## 🗂️ GitHub Repository Structure

```
qwen-autoclaw-backup/
├── README.md                           # Setup and restore instructions
├── SETUP_GUIDE.md                      # Detailed setup guide
├── .gitignore                          # Exclude sensitive/unnecessary files
│
├── qwen-code/                          # Qwen Code instance backup
│   ├── settings.json                   # Main configuration
│   ├── output-language.md              # Language preferences
│   ├── skills/                         # Custom skills (if any)
│   ├── projects/                       # Project configurations
│   ├── knowledge-base/                 # LLM KB documentation
│   │   ├── guide.md
│   │   ├── schema-template.md
│   │   ├── setup-checklist.md
│   │   └── setup-script.ps1
│   └── todos/                          # Pending tasks
│
├── openclaw-autoclaw/                  # AutoClaw/OpenClaw backup
│   ├── openclaw.json                   # Main configuration
│   ├── openclaw.json.known-good        # Last known good config
│   ├── agents/                         # Agent configurations
│   ├── skills/                         # AutoClaw skills
│   ├── workspace/                      # Workspace files
│   │   ├── AUTOCLAW_KEY_FINDINGS.md
│   │   └── AUTOCLAW_ARCHITECTURE.md
│   ├── cron/                           # Scheduled tasks
│   ├── canvas/                         # Canvas data
│   └── devices/                        # Device configurations
│
├── gemini-cli/                         # Gemini CLI configuration
│   └── GEMINI.md                       # Mission mandate
│
├── scripts/                            # Automation scripts
│   ├── backup-qwen.ps1                 # Backup Qwen Code
│   ├── backup-autoclaw.ps1             # Backup AutoClaw
│   ├── backup-all.ps1                  # Complete backup
│   ├── restore-qwen.ps1                # Restore Qwen Code
│   ├── restore-autoclaw.ps1            # Restore AutoClaw
│   ├── setup-new-instance.ps1          # Setup on new machine
│   └── watch-and-commit.ps1            # File watcher
│
└── logs/                               # Backup logs
    └── backup-history.md               # Historical backup log
```

---

## ⚙️ Backup Mechanisms

### 1. Continuous Backup Triggers

#### A. Task Assignment Trigger
When a new task is assigned to Qwen Code:
- Auto-commit current state before starting
- Create checkpoint branch
- Log task in backup history

**Implementation:**
- Qwen Code agent runs pre-task backup script
- Commits with message: `checkpoint: before task - [task description]`
- Pushes to GitHub

#### B. Change Detection Trigger
Monitors critical files for changes:
- `.qwen/settings.json`
- `.openclaw-autoclaw/openclaw.json`
- Any `.md` files in workspace
- New skills or projects

**Implementation:**
- File watcher script runs in background
- Detects changes via file modification time
- Auto-commits and pushes within 30 seconds

#### C. Periodic Backup
- Runs every 4 hours (aligns with AutoClaw heartbeat)
- Comprehensive backup of all components
- Creates timestamped commits

---

### 2. Automated Commit Script

```powershell
# Example commit message format
checkpoint: [component] - [change description] - [timestamp]

# Examples:
checkpoint: qwen-settings - updated model configuration - 2026-04-08T14:30
checkpoint: autoclaw-workspace - added KB architecture doc - 2026-04-08T14:35
checkpoint: qwen-tasks - completed backup system setup - 2026-04-08T15:00
```

---

## 🚀 Setup on New Machine

### Quick Start (5 minutes)

```powershell
# 1. Clone repository
git clone https://github.com/yourusername/qwen-autoclaw-backup.git
cd qwen-autoclaw-backup

# 2. Run setup script
.\scripts\setup-new-instance.ps1 -QwenPath "C:\Users\YourUser" -OpenClawPath "C:\Users\YourUser"

# 3. Verify installation
.\scripts\backup-all.ps1 -Test

# 4. Configure auto-backup (optional)
.\scripts\watch-and-commit.ps1 -Install
```

### Manual Setup

See `SETUP_GUIDE.md` for detailed step-by-step instructions.

---

## 🔄 Restore Procedures

### Restore Qwen Code

```powershell
# Restore from latest backup
.\scripts\restore-qwen.ps1

# Restore from specific commit
.\scripts\restore-qwen.ps1 -Commit "abc1234"

# Restore specific component only
.\scripts\restore-qwen.ps1 -Component "settings"
```

### Restore AutoClaw/OpenClaw

```powershell
# Spin up new instance from backup
.\scripts\restore-autoclaw.ps1

# This will:
# 1. Install OpenClaw if not present
# 2. Restore configuration
# 3. Restore workspace
# 4. Restore skills and agents
# 5. Verify installation
```

---

## 📊 Backup Status & Monitoring

### Check Backup Health

```powershell
# Show last backup status
Get-Content logs\backup-history.md | Select-Object -Last 20

# Verify all components backed up
Test-Path qwen-code\settings.json
Test-Path openclaw-autoclaw\openclaw.json
```

### Backup Frequency

| Component | Trigger | Frequency |
|-----------|---------|-----------|
| Qwen settings | On change | Event-driven |
| Qwen tasks | Before new task | Event-driven |
| AutoClaw config | On change | Event-driven |
| Workspace files | On change | Event-driven |
| Full backup | Periodic | Every 4 hours |

---

## 🔐 Security Considerations

### What's Backed Up
✅ Configuration files  
✅ Skills and agents  
✅ Workspace documents  
✅ Knowledge bases  
✅ Custom scripts  

### What's NOT Backed Up
❌ OAuth tokens (encrypted separately)  
❌ API keys (use environment variables)  
❌ Cache files  
❌ Log files (except recent)  
❌ Temporary files  

### Sensitive Data Handling

The `.gitignore` file excludes:
- `oauth_creds.json` (use encrypted version)
- `*.key`, `*.pem` files
- `.env` files with secrets
- Browser extension caches

**Important:** Before pushing to GitHub:
1. Review all files for sensitive data
2. Use `.gitignore` appropriately
3. Consider using GitHub private repos
4. Rotate any accidentally exposed credentials

---

## 🛠️ Troubleshooting

### Backup Not Running

```powershell
# Check if watcher is running
Get-Process -Name "watch-and-commit" -ErrorAction SilentlyContinue

# Manual trigger
.\scripts\backup-all.ps1 -Verbose
```

### Restore Failed

```powershell
# Verify backup integrity
git log --oneline -10

# Check for conflicts
git status

# Force restore from specific commit
.\scripts\restore-qwen.ps1 -Commit "abc1234" -Force
```

### Git Issues

```powershell
# Re-initialize if needed
git init
git remote add origin https://github.com/yourusername/qwen-autoclaw-backup.git
git pull origin main
```

---

## 📈 Future Enhancements

- [ ] Encrypted backup for sensitive credentials
- [ ] Multiple GitHub repository support
- [ ] Automatic conflict resolution
- [ ] Backup to multiple providers (GitLab, local, cloud)
- [ ] Web dashboard for backup monitoring
- [ ] Slack/Discord notifications on backup
- [ ] Incremental backup optimization
- [ ] Cross-machine synchronization

---

## 📝 Maintenance

### Weekly Tasks
- Review backup logs
- Verify all components backing up
- Test restore procedure on staging

### Monthly Tasks
- Rotate any exposed credentials
- Update backup scripts
- Review .gitignore for completeness
- Test full restore on clean machine

---

## 🤝 Integration with Gemini CLI

Gemini CLI on this machine is configured with its own backup mechanisms. This system:

**Coordinates with Gemini:**
- Both back up the same files (redundancy is good)
- Gemini may trigger backups independently
- No conflict - both can push to same repo

**Does NOT require:**
- Special configuration in Gemini
- Changes to Gemini's backup setup
- Coordination beyond shared repo access

**Benefits:**
- Multiple backup sources = more safety
- Gemini can back up its own findings
- Redundant pushes are harmless (git handles)

---

## 📞 Support

For issues or questions:
1. Check `SETUP_GUIDE.md`
2. Review backup logs in `logs/`
3. Test with `-Test` flag before production use
4. Create issue in GitHub repo

---

**Last Updated:** 2026-04-08  
**System Status:** ✅ Operational  
**Next Review:** 2026-04-15
