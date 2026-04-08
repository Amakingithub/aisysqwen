# LLM Knowledge Base - Setup Checklist

Use this checklist when creating a new knowledge base instance.

## Prerequisites

- [ ] Obsidian installed and working
- [ ] LLM agent access (Qwen Code, Claude, GPT, etc.)
- [ ] Git installed (for version control)
- [ ] Obsidian Web Clipper extension installed (browser)

## Initial Setup

### 1. Create Project Structure

```bash
# Create directory structure
mkdir -p knowledge-base/raw/articles
mkdir -p knowledge-base/raw/papers
mkdir -p knowledge-base/raw/data
mkdir -p knowledge-base/raw/assets
mkdir -p knowledge-base/wiki/sources
mkdir -p knowledge-base/wiki/entities
mkdir -p knowledge-base/wiki/concepts
mkdir -p knowledge-base/wiki/queries

# Initialize git repo
cd knowledge-base
git init
git add .
git commit -m "Initialize LLM knowledge base"
```

### 2. Configure Obsidian

- [ ] Open Obsidian
- [ ] Create new vault pointing to `knowledge-base/` directory
- [ ] Settings → Files and links:
  - [ ] Set "Attachment folder path" to `raw/assets/`
  - [ ] Check "Always update internal links"
- [ ] Settings → Hotkeys:
  - [ ] Search "Download" → bind "Download attachments" to `Ctrl+Shift+D`
- [ ] Install recommended plugins:
  - [ ] Web Clipper (browser extension)
  - [ ] Marp (optional - for slide decks)
  - [ ] Dataview (optional - for queries)
  - [ ] Graph Analysis (for visualization)

### 3. Initialize Core Files

- [ ] Copy `SCHEMA.md` template to project root
- [ ] Create `wiki/index.md` with empty structure:

```markdown
# Wiki Index

> **Last updated:** [DATE]
> **Total sources:** 0 | **Total entities:** 0 | **Total concepts:** 0 | **Total queries:** 0

## Sources

## Entities

## Concepts

## Queries & Analyses

```

- [ ] Create `wiki/log.md` with header:

```markdown
# Wiki Log

> Append-only chronological record of all wiki operations.

```

- [ ] Commit initial files:

```bash
git add .
git commit -m "Add SCHEMA.md and initialize index/log"
```

### 4. Customize SCHEMA.md

Review and adjust the schema template for your specific needs:

- [ ] Adjust directory structure if needed
- [ ] Modify page formats for your domain
- [ ] Update naming conventions if different
- [ ] Add custom page types (experiments, hypotheses, etc.)
- [ ] Set up tags/categories relevant to your domain
- [ ] Commit customized schema

### 5. First Content

- [ ] Collect 3-5 initial source documents
- [ ] Place in appropriate `raw/` subdirectories
- [ ] Download associated images to `raw/assets/`
- [ ] First ingestion session with LLM (interactive recommended)

### 6. First Ingestion Session

Open your LLM agent and say:

```
I'm setting up a new LLM knowledge base. Please:

1. Read the SCHEMA.md file fully to understand the structure
2. Read wiki/index.md to see it's empty
3. Ingest this source: raw/[category]/[filename].md

Follow the full ingestion workflow:
- Summarize key points for discussion
- Create source summary page
- Create/update entity and concept pages
- Update index.md
- Append to log.md
```

- [ ] Review the LLM's output
- [ ] Check created pages in Obsidian
- [ ] Verify index.md and log.md are updated
- [ ] Adjust SCHEMA.md if needed based on experience
- [ ] Commit first ingestion:

```bash
git add .
git commit -m "First ingestion: [source title]"
```

## Ongoing Workflow

### Regular Sessions

1. **Add sources** - Clip articles, download papers to `raw/`
2. **Ingest** - Have LLM process new sources
3. **Query** - Ask questions, explore connections
4. **Lint** - Periodic health checks (every 5-10 sources)
5. **Commit** - Regular git commits for version history

### Session Startup Prompt

When launching a new session with the LLM:

```
I'm working with my LLM knowledge base. Please:

1. Read SCHEMA.md to refresh on structure
2. Read wiki/index.md to understand current state  
3. Read last 5 entries in wiki/log.md for recent context
4. Ready for instructions
```

## Maintenance

### Weekly/Monthly
- [ ] Run lint workflow
- [ ] Review graph view in Obsidian for orphans
- [ ] Commit all changes
- [ ] Consider archiving old queries

### As Needed
- [ ] Update SCHEMA.md as conventions evolve
- [ ] Add new tooling (qmd search, etc.)
- [ ] Adjust directory structure if outgrowing initial setup

## Scaling Milestones

### At ~25 sources
- [ ] Review if current structure works
- [ ] Consider adding subcategories
- [ ] Check if index.md is still navigable

### At ~50 sources  
- [ ] Evaluate need for search tool (qmd)
- [ ] Consider hierarchical indices
- [ ] Review and consolidate if needed

### At ~100+ sources
- [ ] Definitely implement search
- [ ] Consider batch processing workflows
- [ ] Evaluate fine-tuning possibilities
- [ ] May need performance optimizations

## Knowledge Base Instances

Track your active knowledge bases:

| Name | Domain | Created | Sources | Status |
|------|--------|---------|---------|--------|
| [Example: AI Research] | [Machine Learning] | [2026-04-08] | [0] | [Active] |
| | | | | |

Add each new KB instance to this table.

## Troubleshooting

### LLM not following schema
- Re-paste SCHEMA.md in conversation
- Be explicit about which workflow to follow
- Adjust schema to be clearer if needed

### Wiki getting messy
- Run lint workflow
- Focus on connections and cross-references
- Don't worry about perfection, aim for consistency

### Too slow on large wikis
- Implement search tool
- Use index.md more strategically
- Consider hierarchical organization

### Contradictions appearing
- This is normal and valuable
- Flag explicitly in both pages
- Don't resolve without user discussion
- Contradictions are research opportunities

## Success Metrics

- [ ] Sources ingested: _____
- [ ] Wiki pages created: _____
- [ ] Queries answered: _____
- [ ] Contradictions found and flagged: _____
- [ ] Cross-links between pages: _____
- [ ] Time to answer complex questions: _____
- [ ] Follow-up questions generated: _____

Track these monthly to see knowledge compounding.
