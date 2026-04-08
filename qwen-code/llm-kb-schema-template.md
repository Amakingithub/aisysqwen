# Wiki Schema

> **Purpose:** This document configures the LLM as a disciplined wiki maintainer. 
> Read this fully before performing any operations (ingest, query, or lint).
> Co-evolve this document with the user as the wiki grows.

---

## Directory Structure

```
./
├── raw/                      # Source documents (IMMUTABLE - LLM reads only)
│   ├── articles/             # Web articles, blog posts
│   ├── papers/               # Academic papers, reports
│   ├── data/                 # Datasets, spreadsheets
│   └── assets/               # Downloaded images, media
├── wiki/                     # LLM-maintained knowledge base
│   ├── sources/              # One summary page per source
│   ├── entities/             # People, organizations, places
│   ├── concepts/             # Topics, ideas, frameworks
│   ├── queries/              # Q&A outputs filed for reuse
│   ├── index.md              # Content catalog of all pages
│   └── log.md                # Chronological operation log
├── SCHEMA.md                 # This file
└── README.md                 # Project overview
```

**Rules:**
- `raw/` is read-only for the LLM
- `wiki/` is fully owned by the LLM
- All files are markdown (.md)
- Use `raw/assets/` for images referenced in sources

---

## Page Formats

### Source Summary Page (`wiki/sources/[slug].md`)

```markdown
---
type: source
title: "Full Title Here"
date_ingested: YYYY-MM-DD
source_url: "original URL if applicable"
tags: [tag1, tag2]
---

# Source: Full Title Here

## Summary
2-3 paragraph overview of the source's main points.

## Key Takeaways
- **Point 1:** Description
- **Point 2:** Description
- **Point 3:** Description

## Entities Mentioned
- [[Entity Name]] - brief role description

## Concepts Covered
- [[Concept Name]] - brief description

## Notable Quotes/Data
> Key quote or statistic from the source

## Contradictions/Connections
- Connects to: [[Related Page]]
- Contradicts: [[Other Source]] on [specific point]

## Source File
- Original: `raw/[category]/filename.md`
```

### Entity Page (`wiki/entities/[name].md`)

```markdown
---
type: entity
name: "Full Name"
category: person|organization|place|product|other
tags: [relevant tags]
---

# Entity: Full Name

## Overview
Who/what this is and why they matter to this knowledge base.

## Key Facts
- Fact 1
- Fact 2
- Fact 3

## Role in This Domain
How this entity connects to the knowledge base topics.

## Connections
- Related to: [[Concept]], [[Other Entity]]
- Mentioned in: [[Source 1]], [[Source 2]]

## Timeline (if applicable)
- **Date:** Event or action
- **Date:** Event or action
```

### Concept Page (`wiki/concepts/[name].md`)

```markdown
---
type: concept
name: "Concept Name"
tags: [relevant tags]
---

# Concept: Concept Name

## Definition
Clear, concise definition of the concept.

## Key Insights
- **Insight 1:** Explanation
- **Insight 2:** Explanation

## Evidence & Sources
- From [[Source 1]]: Summary of what it says
- From [[Source 2]]: Summary of what it says

## Related Concepts
- [[Related Concept 1]] - how they connect
- [[Related Concept 2]] - how they differ

## Open Questions
- Question that remains unanswered
- Area needing more research
```

### Query Output Page (`wiki/queries/[topic].md`)

```markdown
---
type: query
question: "The original question"
date: YYYY-MM-DD
sources_consulted: 5
---

# Query: Topic Summary

## Question
[Original question restated]

## Answer
Comprehensive synthesized answer with inline citations.

## Evidence
### From [[Source 1]]
Relevant excerpt or summary

### From [[Source 2]]
Relevant excerpt or summary

## Implications
What this means for the broader knowledge base.

## Follow-up Questions
- Question 1
- Question 2
```

---

## Naming Conventions

### Files
- **Format:** `lowercase_with_underscores.md`
- **Examples:** `attention_mechanism.md`, `karpathy_2024.md`
- **Avoid:** Spaces, special characters, uppercase

### Wiki Links
- **Format:** `[[Page Title With Spaces]]`
- **Obsidian handles:** File name to display name mapping
- **Always use:** Double bracket wikilinks, not markdown links

### Slugs
- Extract meaningful part: `attention_is_all_you_need.md` not `full_paper_title.md`
- Keep under 5 words when possible

---

## Workflows

### INGESTION Workflow

When user says "Ingest: [filename]":

1. **Read** the source file from `raw/`
2. **Summarize** key points back to user for discussion
3. **Create** source summary in `wiki/sources/[slug].md`
4. **Update/Create** entity pages for people, orgs, places mentioned
5. **Update/Create** concept pages for ideas and frameworks
6. **Note contradictions** or connections to existing wiki pages
7. **Update** `wiki/index.md` with new pages
8. **Append** entry to `wiki/log.md` with format:
   ```
   ## [YYYY-MM-DD] ingest | Source Title
   - Processed: raw/[path]/filename.md
   - Created: wiki/sources/slug.md
   - Updated: [list of updated pages]
   - Notes: [key findings, contradictions, connections]
   ```
9. **Suggest** follow-up questions or related sources

**Expected impact:** A single source may touch 10-15 wiki pages.

---

### QUERY Workflow

When user asks a question:

1. **Read** `wiki/index.md` to find relevant pages
2. **Search** and read the most relevant wiki pages
3. **Synthesize** a comprehensive answer with citations
4. **Format** output based on request:
   - Default: Markdown page in `wiki/queries/[topic].md`
   - Marp slides: If requested
   - Table/Chart: If data-heavy
5. **Update** `wiki/index.md` if creating new query page
6. **Append** to `wiki/log.md`:
   ```
   ## [YYYY-MM-DD] query | Question Topic
   - Question: [restated question]
   - Output: wiki/queries/topic.md
   - Sources consulted: [count] pages
   ```
7. **Suggest** filing the answer into wiki for future reference

---

### LINT Workflow

When user says "Lint the wiki" or "Health check":

1. **Scan for contradictions:**
   - Read concept and entity pages
   - Find conflicting claims about the same topic
   - Flag with source references

2. **Find orphan pages:**
   - Check each page for inbound wikilinks
   - List pages with no connections

3. **Identify missing pages:**
   - Find wikilinks that don't have corresponding files
   - Find concepts mentioned but not elaborated

4. **Check for stale claims:**
   - Find older pages that may need updating
   - Cross-reference with newer sources

5. **Suggest cross-references:**
   - Find related pages that should link to each other
   - Identify hub pages that could benefit from more connections

6. **Report findings** to user in structured format:
   ```
   ## Health Check Results
   
   ### Contradictions Found (X)
   - [ ] Page A vs Page B on [topic]
   
   ### Orphan Pages (X)
   - [[Page Name]] - no inbound links
   
   ### Missing Pages Suggested (X)
   - [Concept mentioned in multiple sources]
   
   ### Stale Claims (X)
   - [Page from date] may need update from [newer source]
   
   ### Cross-Reference Opportunities (X)
   - [[Page A]] could link to [[Page B]] on [topic]
   ```

7. **With user approval**, implement fixes
8. **Append** to `wiki/log.md`:
   ```
   ## [YYYY-MM-DD] lint | Health check
   - Found X contradictions, resolved Y
   - Created Z new pages
   - Added N cross-references
   - Suggestions for further exploration: [list]
   ```

---

## Index Format (`wiki/index.md`)

```markdown
# Wiki Index

> **Last updated:** YYYY-MM-DD
> **Total sources:** X | **Total entities:** X | **Total concepts:** X | **Total queries:** X

## Sources
- [[Source Title]] - One-line summary (ingested YYYY-MM-DD)
- [[Source Title]] - One-line summary (ingested YYYY-MM-DD)

## Entities
- [[Entity Name]] - Who/what and relevance (category: person/org/place)
- [[Entity Name]] - Who/what and relevance (category: person/org/place)

## Concepts
- [[Concept Name]] - What it is and key insight
- [[Concept Name]] - What it is and key insight

## Queries & Analyses
- [[Query Topic]] - What was discovered (YYYY-MM-DD)
- [[Query Topic]] - What was discovered (YYYY-MM-DD)
```

**Update rules:**
- Add entry on every page creation
- Update count line when structure changes
- Keep one-line summaries focused on uniqueness

---

## Log Format (`wiki/log.md`)

```markdown
# Wiki Log

> Append-only chronological record of all wiki operations.
> Format enables parsing with unix tools.

## [YYYY-MM-DD] operation_type | Title/Topic
- Details of what was done
- Files created/updated
- Key findings or notes
```

**Operation types:** `ingest`, `query`, `lint`

**Parsing examples:**
```bash
# Last 5 operations
grep "^## \[" wiki/log.md | tail -5

# All ingests
grep "^## .* ingest" wiki/log.md

# Operations on specific date
grep "^## \[2026-04-08\]" wiki/log.md
```

---

## Cross-Referencing Standards

### Wikilinks
- **Always use:** `[[Page Title]]` format
- **With display text:** `[[file-name|Display Text]]` if needed
- **Check:** Links actually resolve to existing files

### Backlinks
- Obsidian auto-generates backlinks (pages linking TO this page)
- Reference backlinks when updating pages
- Note "Mentioned in:" sections

### Connection Sections
Every page should have a connections section:
```markdown
## Connections
- Related to: [[Concept]], [[Entity]]
- From sources: [[Source 1]], [[Source 2]]
- See also: [[Related Page]]
```

---

## Frontmatter Standards

Use YAML frontmatter for Dataview plugin compatibility:

```yaml
---
type: source|entity|concept|query
title/name: "Display Name"
date_ingested/created: YYYY-MM-DD
tags: [tag1, tag2]
source_url: "https://..." (for sources)
category: subcategory (for entities)
sources_consulted: X (for queries)
---
```

---

## Quality Standards

### Writing
- **Concise:** Avoid verbosity; use bullet points
- **Attributed:** Always cite which source says what
- **Neutral:** Report findings, don't editorialize
- **Specific:** Use concrete facts, numbers, quotes

### Contradictions
- **Flag explicitly:** "Contradicts: [[Source]] on [point]"
- **Don't resolve unilaterally:** Present both sides, ask user
- **Track in both pages:** Each contradictory source mentions the conflict

### Uncertainty
- **Mark clearly:** "Uncertain:", "Needs verification:", "Open question:"
- **Suggest verification:** Web search, additional sources
- **Don't fabricate:** Better to note gap than fill with speculation

---

## Tool Integration

### When to Use Search (qmd or similar)
- Wiki exceeds ~100 sources
- Index file no longer sufficient for navigation
- User asks highly specific factual question
- Need full-text search beyond page titles

### Image Handling
- Sources may reference images in `raw/assets/`
- When ingesting, note which images are referenced
- Can view images separately to gain additional context
- Mention in source summary if images contain key information

### Output Generation
- **Marp slides:** When user requests presentation format
- **Matplotlib charts:** When data visualization needed
- **Tables:** For comparisons, structured data
- **Default:** Always start with markdown page

---

## Evolution & Adaptation

### Schema Updates
- This SCHEMA.md should evolve as the wiki grows
- Propose changes to user when:
  - New page types are needed
  - Workflows need adjustment
  - Conventions aren't working in practice
- Get user approval before major schema changes

### Scaling Adjustments
- **Small (<50 sources):** This schema works as-is
- **Medium (50-200):** May need hierarchical indices
- **Large (200+):** Need search tool, batch processing strategies

### Domain Adaptation
- Adjust categories, tags for specific domain
- Add custom page types if needed (e.g., `experiment`, `hypothesis`)
- Modify workflows based on user preferences
- This is a starting point, not a rigid template

---

## Quick Reference

### For New Sessions
1. Read this SCHEMA.md fully
2. Read `wiki/index.md` to understand current state
3. Read recent `wiki/log.md` entries for context
4. Await user instructions (ingest, query, or lint)

### Common Operations
- **Add source:** Follow INGESTION workflow
- **Answer question:** Follow QUERY workflow  
- **Maintain health:** Follow LINT workflow
- **Check status:** Read index.md and recent log.md

### File Locations
- Sources: `raw/[category]/filename.md`
- Wiki pages: `wiki/[type]/slug.md`
- Index: `wiki/index.md`
- Log: `wiki/log.md`
- Schema: `SCHEMA.md` (this file)

---

## Notes

- You (the LLM) own the wiki layer completely
- User rarely edits wiki files directly
- User's job: curate sources, ask questions, direct analysis
- Your job: everything else (summarizing, linking, maintaining)
- Prioritize knowledge compaction and consistency
- Always suggest follow-up questions and sources
