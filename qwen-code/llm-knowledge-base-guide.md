# LLM Knowledge Base System - Master Documentation

## Overview

This system enables you to build and maintain personal knowledge bases using LLMs. Instead of traditional RAG (Retrieval-Augmented Generation) where the LLM retrieves from raw documents on every query, the LLM **incrementally builds and maintains a persistent wiki** — a structured, interlinked collection of markdown files that compounds in value over time.

**Key Insight:** The wiki is a persistent, compounding artifact. Knowledge is compiled once and kept current, not re-derived on every query.

---

## Architecture

The system has three layers:

### 1. Raw Sources (`raw/` directory)
- **Purpose:** Your curated collection of source documents
- **Contents:** Articles, papers, images, datasets, reports
- **Rule:** These are **immutable** — the LLM reads but never modifies them
- **Organization:** Can be flat or categorized (e.g., `raw/papers/`, `raw/articles/`, `raw/data/`)

### 2. The Wiki (`wiki/` directory)
- **Purpose:** LLM-generated and maintained knowledge base
- **Contents:** 
  - Summary pages for each source
  - Entity pages (people, organizations, concepts)
  - Concept/topic pages with synthesis
  - Comparison and analysis pages
  - Index and log files
- **Ownership:** The LLM writes and maintains this; you rarely touch it manually

### 3. The Schema (`SCHEMA.md` or `AGENTS.md`)
- **Purpose:** Configuration document that tells the LLM how to structure and maintain the wiki
- **Contents:** 
  - Directory structure conventions
  - Page format templates
  - Workflow instructions
  - Naming conventions
- **Evolution:** Co-developed by you and the LLM over time

---

## Core Operations

### 1. INGEST - Adding New Sources

**Workflow:**
```
1. Drop source file into raw/ directory
2. Tell LLM: "Ingest this source: [filename]"
3. LLM processes it:
   - Reads and analyzes the source
   - Discusses key takeaways with you
   - Writes summary page in wiki/sources/
   - Updates wiki/index.md
   - Updates relevant entity/concept pages
   - Notes contradictions or connections
   - Appends entry to wiki/log.md
```

**Example LLM Prompt:**
```
Please ingest the new source: raw/article_title.md

Follow the ingestion workflow:
1. Read and summarize the key points
2. Create/update the source summary page
3. Update relevant entity and concept pages
4. Update the index
5. Log this ingestion
```

**Impact:** A single source might touch 10-15 wiki pages as it integrates knowledge.

---

### 2. QUERY - Asking Questions

**Workflow:**
```
1. Ask complex question requiring synthesis
2. LLM:
   - Reads index.md to find relevant pages
   - Drills into specific wiki pages
   - Synthesizes answer with citations
   - Can generate output in various formats
3. Answer can be filed back into wiki as new page
```

**Output Formats:**
- **Markdown pages** (filed into wiki for future reference)
- **Marp slide decks** (presentations)
- **Matplotlib charts** (visualizations)
- **Comparison tables**
- **Canvas/mind maps**

**Example LLM Prompt:**
```
Query: [Your complex question]

Please:
1. Research the relevant wiki pages
2. Synthesize a comprehensive answer
3. Include citations to source pages
4. Format as markdown and save to wiki/queries/[topic].md
5. Update the index
```

**Key Principle:** Your explorations compound. Good answers become permanent wiki pages.

---

### 3. LINT - Health Checks

**Workflow:**
```
1. Request wiki health check
2. LLM scans for:
   - Contradictions between pages
   - Stale claims superseded by newer sources
   - Orphan pages (no inbound links)
   - Concepts mentioned but lacking pages
   - Missing cross-references
   - Data gaps (can use web search)
3. LLM suggests fixes and new questions
4. You approve changes, LLM implements
```

**Example LLM Prompt:**
```
Please perform a health check on the wiki:

1. Find and report any contradictions
2. Identify orphan pages
3. Suggest new pages that should be created
4. Find missing cross-references
5. Check for stale or outdated claims
6. Suggest areas for further exploration
```

---

## Special Files

### `index.md` - Content Catalog

**Purpose:** Navigational map of the entire wiki

**Structure:**
```markdown
# Wiki Index

## Sources
- [[Source 1]] - Brief summary (date ingested)
- [[Source 2]] - Brief summary (date ingested)

## Entities
- [[Person/Org 1]] - Who they are and relevance
- [[Person/Org 2]] - Who they are and relevance

## Concepts
- [[Concept 1]] - What it is and key insights
- [[Concept 2]] - What it is and key insights

## Queries & Analyses
- [[Analysis 1]] - What was discovered
- [[Analysis 2]] - What was discovered
```

**Update Frequency:** Every ingest operation

**Why it works:** At ~100 sources and hundreds of pages, the LLM can read the index first to find relevant pages, avoiding need for embedding-based RAG.

---

### `log.md` - Chronological Record

**Purpose:** Timeline of all wiki operations

**Structure:**
```markdown
# Wiki Log

## [2026-04-08] ingest | Article Title Here
- Processed: raw/article_title.md
- Created: wiki/sources/article_title.md
- Updated: wiki/entities/person_x.md, wiki/concepts/topic_y.md
- Notes: Key finding about Z, contradicts earlier claim in source A

## [2026-04-08] query | Comparison of X and Y
- Question: How do X and Y compare?
- Output: wiki/queries/x_vs_y.md
- Sources consulted: 8 pages

## [2026-04-07] lint | Health check
- Found 3 orphan pages
- Created 2 new concept pages
- Updated 5 missing cross-references
```

**Tip:** Consistent prefixes enable unix tools:
```bash
grep "^## \[" wiki/log.md | tail -5  # Last 5 entries
```

---

## Directory Structure Template

```
knowledge-base/
├── raw/                      # Source documents (immutable)
│   ├── articles/
│   ├── papers/
│   ├── data/
│   └── assets/               # Downloaded images
├── wiki/                     # LLM-maintained wiki
│   ├── sources/              # Source summaries
│   ├── entities/             # People, orgs, things
│   ├── concepts/             # Topics and ideas
│   ├── queries/              # Q&A outputs filed back
│   ├── index.md              # Content catalog
│   └── log.md                # Chronological log
├── SCHEMA.md                 # Wiki structure & conventions
└── README.md                 # This file
```

---

## Tooling Recommendations

### Essential Tools

1. **Obsidian** (Frontend IDE)
   - View raw sources, wiki, and visualizations
   - Graph view to see connections
   - Real-time preview of LLM edits
   - Plugins: Marp, Dataview, Web Clipper

2. **Obsidian Web Clipper** (Browser Extension)
   - Convert web articles to markdown
   - Download to `raw/` directory
   - Set attachment folder path in settings

3. **Local Image Download**
   - Settings → Files and links → Set "Attachment folder path" to `raw/assets/`
   - Settings → Hotkeys → Bind "Download attachments" to `Ctrl+Shift+D`
   - Ensures LLM can view images directly

### Optional Tools

1. **qmd** - Local search engine for markdown
   - Hybrid BM25/vector search
   - LLM re-ranking
   - CLI and MCP server modes
   - Use when wiki grows beyond index file navigation

2. **Marp** - Markdown presentation format
   - Generate slide decks from wiki content
   - Obsidian plugin available

3. **Dataview** - Query page frontmatter
   - Dynamic tables and lists
   - Requires YAML frontmatter on pages

4. **Git** - Version control
   - Wiki is just a git repo of markdown
   - Free version history, branching, collaboration

---

## SCHEMA.md Template

Create this file to train your LLM on the wiki conventions:

```markdown
# Wiki Schema

## Directory Structure
[Describe your structure]

## Page Formats
[Describe templates for each page type]

## Naming Conventions
[How to name files and links]

## Workflows
### Ingestion
[Step-by-step process]

### Query
[How to answer and file outputs]

### Linting
[Health check procedures]

## Index Format
[How to maintain index.md]

## Log Format
[How to maintain log.md]

## Cross-Referencing
[How to link pages, use backlinks]

## Frontmatter (if using Dataview)
[YAML structure for metadata]
```

---

## Workflow Patterns

### Pattern 1: Single Source Deep Dive
```
1. Add source to raw/
2. Ingest with LLM (interactive discussion)
3. LLM builds initial wiki structure
4. Query the wiki to explore connections
5. Lint to ensure consistency
6. Repeat with next source
```

### Pattern 2: Batch Ingestion
```
1. Add multiple sources to raw/
2. Ingest all at once (less supervision)
3. Review summaries in log.md
4. Lint to resolve contradictions
5. Query to synthesize across sources
```

### Pattern 3: Research Iteration
```
1. Start with small wiki (5-10 sources)
2. Query to identify knowledge gaps
3. Find and ingest new sources to fill gaps
4. Lint to integrate new knowledge
5. Query again with more sophisticated questions
6. Repeat - knowledge compounds
```

---

## Why This Works

**The Problem:** Humans abandon wikis because maintenance burden grows faster than value.

**The Solution:** LLMs don't get bored. They can:
- Update cross-references across 15 files in one pass
- Keep summaries current without forgetting
- Note contradictions automatically
- Maintain consistency at scale
- Suggest new questions and sources

**Division of Labor:**
- **You:** Curate sources, direct analysis, ask good questions, synthesize meaning
- **LLM:** Summarizing, cross-referencing, filing, bookkeeping, maintenance

---

## Use Cases

1. **Personal Research** - Going deep on a topic over weeks/months
2. **Reading Projects** - Building wiki as you read books/papers
3. **Business/Team** - Internal wiki from Slack, meetings, docs
4. **Competitive Analysis** - Tracking competitors over time
5. **Due Diligence** - Organizing investigation findings
6. **Course Notes** - Comprehensive lecture notes with synthesis
7. **Health/Self-Improvement** - Tracking goals, habits, insights
8. **Hobby Deep-Dives** - Any accumulating knowledge domain

---

## Scaling Considerations

### Small Scale (~10-50 sources)
- Index file is sufficient for navigation
- No search engine needed
- Fast LLM processing

### Medium Scale (~50-200 sources)  
- Index file still works
- Consider qmd or similar search tool
- Processing takes longer but manageable

### Large Scale (200+ sources)
- Definitely need search engine (qmd or custom)
- Consider batch processing strategies
- May need hierarchical indices
- Potential for synthetic data generation + fine-tuning

---

## Next Steps for Setup

1. **Choose your domain** - What will this knowledge base cover?
2. **Create directory structure** - Use template above
3. **Write initial SCHEMA.md** - Customize for your needs
4. **Collect first 3-5 sources** - Put in raw/
5. **First ingestion** - Work with LLM interactively
6. **Refine schema** - Adjust based on what works
7. **Build momentum** - Add sources regularly, query often

---

## Key Principles

1. **The wiki compounds** - Every source and query adds permanent value
2. **You rarely write** - The LLM maintains everything
3. **Obsidian is your IDE** - View, explore, visualize
4. **Git for version control** - Track wiki evolution
5. **Start simple** - Add complexity as needed
6. **Iterate the schema** - Co-evolve conventions with LLM

---

## References

- Original concept: Andrej Karpathy's LLM Wiki pattern
- Inspiration: Vannevar Bush's Memex (1945) - personal knowledge store with associative trails
- Modern tools: Obsidian, LLMs, markdown ecosystems
