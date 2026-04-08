# LLM Knowledge Base - Quick Reference Card

## System State

**Ready Status:** ✅ Prepared and documented  
**Location:** `C:\Users\HPM\.qwen\`  
**Components:** Guide, Schema Template, Checklist, Setup Script

---

## Files Created

| File | Purpose |
|------|---------|
| `llm-knowledge-base-guide.md` | Complete master guide with architecture, workflows, and examples |
| `llm-kb-schema-template.md` | Ready-to-use SCHEMA.md template for LLM configuration |
| `llm-kb-setup-checklist.md` | Step-by-step checklist for creating new KB instances |
| `setup-kb.ps1` | PowerShell script to scaffold new KB instances |

---

## Quick Start - Create New KB

### Option 1: Automated (Recommended)

```powershell
# Run setup script
.\.qwen\setup-kb.ps1 -Name "my-research-topic"

# Follow the output instructions
```

### Option 2: Manual

```powershell
# Create structure
mkdir -p raw/{articles,papers,data,assets}
mkdir -p wiki/{sources,entities,concepts,queries}

# Copy schema template
copy .qwen\llm-kb-schema-template.md SCHEMA.md

# Initialize files
# ... (see checklist)
```

---

## Common LLM Prompts

### Session Startup
```
I'm working with my LLM knowledge base. Please:
1. Read SCHEMA.md fully
2. Read wiki/index.md for current state
3. Read last 5 entries in wiki/log.md
4. Ready for instructions
```

### Ingest Source
```
Please ingest this source: raw/[category]/[filename].md

Follow the full ingestion workflow:
- Summarize and discuss
- Create source summary page
- Update entity and concept pages  
- Update index.md and log.md
```

### Query Wiki
```
Query: [Your complex question]

Please:
1. Research relevant wiki pages
2. Synthesize comprehensive answer
3. Include citations
4. Save to wiki/queries/[topic].md
5. Update index and log
```

### Lint Wiki
```
Please perform a health check on the wiki:
1. Find contradictions between pages
2. Identify orphan pages
3. Suggest new pages to create
4. Find missing cross-references
5. Check for stale claims
6. Suggest areas for exploration
```

---

## Workflow Summary

### INGEST
```
Add source to raw/ → LLM reads → Creates summaries → Updates entities/concepts → 
Updates index → Logs operation → Suggests follow-ups
```

### QUERY  
```
Ask question → LLM reads index → Finds relevant pages → Synthesizes answer → 
Files output in wiki/queries/ → Updates index/log
```

### LINT
```
Request health check → LLM scans wiki → Reports issues → User approves fixes → 
LLM implements → Updates log
```

---

## Key Principles

1. **Wiki compounds** - Every operation adds permanent value
2. **You curate, LLM maintains** - Division of labor
3. **Obsidian is IDE** - View, explore, visualize
4. **Git for history** - Version control everything
5. **Start simple** - Add complexity as needed
6. **Iterate schema** - Co-evolve conventions

---

## Directory Structure

```
knowledge-base/
├── raw/              # Sources (IMMUTABLE to LLM)
│   ├── articles/
│   ├── papers/
│   ├── data/
│   └── assets/       # Images
├── wiki/             # LLM-owned layer
│   ├── sources/
│   ├── entities/
│   ├── concepts/
│   ├── queries/
│   ├── index.md
│   └── log.md
└── SCHEMA.md         # LLM configuration
```

---

## Scaling Guide

| Scale | Sources | Strategy |
|-------|---------|----------|
| Small | 10-50 | Index file sufficient |
| Medium | 50-200 | Consider search tool |
| Large | 200+ | Need search, batch processing |

---

## Obsidian Setup

1. **Create vault** at KB directory
2. **Settings → Files and links:**
   - Attachment folder: `raw/assets/`
3. **Settings → Hotkeys:**
   - Download attachments: `Ctrl+Shift+D`
4. **Plugins (recommended):**
   - Web Clipper (browser extension)
   - Marp (slides)
   - Dataview (queries)

---

## Next Actions

When you're ready to create your first KB:

1. ✅ Review all documentation created
2. ⏳ Choose your first KB domain/topic
3. ⏳ Run `setup-kb.ps1` to scaffold
4. ⏳ Customize SCHEMA.md
5. ⏳ Collect 3-5 initial sources
6. ⏳ First ingestion session
7. ⏳ Iterate and grow

---

## Active Knowledge Bases

Track instances here:

| Name | Domain | Created | Sources | Status |
|------|--------|---------|---------|--------|
| | | | | |

---

## Tips

- **First sessions:** Be interactive, guide the LLM
- **Schema evolution:** Expect to revise SCHEMA.md
- **Contradictions:** Normal and valuable - flag them
- **Images:** Download locally for LLM access
- **Commits:** After every meaningful operation
- **Graph view:** Best way to see wiki shape

---

**Remember:** The wiki is a persistent, compounding artifact. 
Knowledge compounds over time. The LLM handles maintenance. 
You focus on curation and questions.
