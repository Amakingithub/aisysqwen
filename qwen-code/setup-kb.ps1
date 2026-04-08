# LLM Knowledge Base - Quick Setup Script for Windows
# Run this in PowerShell to create a new knowledge base instance

param(
    [Parameter(Mandatory=$true)]
    [string]$Name,
    
    [string]$Path = "."
)

Write-Host "=== LLM Knowledge Base Setup ===" -ForegroundColor Cyan
Write-Host "Creating knowledge base: $Name" -ForegroundColor Yellow
Write-Host ""

# Create full path
$fullPath = Join-Path $Path $Name

# Create directory structure
Write-Host "Creating directory structure..." -ForegroundColor Green
New-Item -ItemType Directory -Force -Path "$fullPath\raw\articles" | Out-Null
New-Item -ItemType Directory -Force -Path "$fullPath\raw\papers" | Out-Null
New-Item -ItemType Directory -Force -Path "$fullPath\raw\data" | Out-Null
New-Item -ItemType Directory -Force -Path "$fullPath\raw\assets" | Out-Null
New-Item -ItemType Directory -Force -Path "$fullPath\wiki\sources" | Out-Null
New-Item -ItemType Directory -Force -Path "$fullPath\wiki\entities" | Out-Null
New-Item -ItemType Directory -Force -Path "$fullPath\wiki\concepts" | Out-Null
New-Item -ItemType Directory -Force -Path "$fullPath\wiki\queries" | Out-Null

Write-Host "  ✓ raw/ (sources)" -ForegroundColor Green
Write-Host "  ✓ wiki/ (LLM-maintained)" -ForegroundColor Green
Write-Host ""

# Create README.md
Write-Host "Creating README.md..." -ForegroundColor Green
$readme = @"
# $Name

LLM-powered knowledge base for [describe your domain/topic].

## Quick Start

1. Add source documents to `raw/` subdirectories
2. Open in Obsidian (point vault to this directory)
3. Use LLM agent to ingest, query, and maintain
4. See SCHEMA.md for full structure and workflows

## Status

- **Created:** $(Get-Date -Format "yyyy-MM-dd")
- **Sources:** 0
- **Wiki pages:** 0
- **Last updated:** $(Get-Date -Format "yyyy-MM-dd")

## Focus Area

[Describe what this knowledge base covers]

## Active Questions

- [What are your main research questions?]

"@
$readme | Out-File -FilePath "$fullPath\README.md" -Encoding UTF8

# Create initial index.md
Write-Host "Creating wiki/index.md..." -ForegroundColor Green
$index = @"
# Wiki Index

> **Last updated:** $(Get-Date -Format "yyyy-MM-dd")
> **Total sources:** 0 | **Total entities:** 0 | **Total concepts:** 0 | **Total queries:** 0

## Sources

## Entities

## Concepts

## Queries & Analyses

"@
$index | Out-File -FilePath "$fullPath\wiki\index.md" -Encoding UTF8

# Create initial log.md
Write-Host "Creating wiki/log.md..." -ForegroundColor Green
$log = @"
# Wiki Log

> Append-only chronological record of all wiki operations.
> Format: ## [YYYY-MM-DD] operation_type | Title/Topic

"@
$log | Out-File -FilePath "$fullPath\wiki\log.md" -Encoding UTF8

# Create placeholder for SCHEMA.md
Write-Host "Creating SCHEMA.md placeholder..." -ForegroundColor Green
$schema_note = @"
# Wiki Schema

> **IMPORTANT:** Copy the SCHEMA template from `.qwen/llm-kb-schema-template.md` 
> to this location and customize it for your domain before using this knowledge base.
>
> This file configures the LLM as a disciplined wiki maintainer.
> The LLM MUST read this file fully before performing any operations.

## Next Steps

1. Copy schema template: `.qwen/llm-kb-schema-template.md` → `SCHEMA.md`
2. Customize for your domain:
   - Adjust directory structure if needed
   - Modify page formats
   - Set up relevant tags/categories
   - Add custom page types
3. Commit the customized schema
4. Start ingesting sources

## Current Status

- [ ] Schema template copied
- [ ] Schema customized for domain
- [ ] First sources added
- [ ] First ingestion completed

"@
$schema_note | Out-File -FilePath "$fullPath\SCHEMA.md" -Encoding UTF8

# Create .gitignore
Write-Host "Creating .gitignore..." -ForegroundColor Green
$gitignore = @"
# OS files
.DS_Store
Thumbs.db
desktop.ini

# Editor files
*.swp
*.swo
*~

# Optional npm cache and logs
npm-debug.log*

# Optional Obsidian workspace
.workspace

# Sensitive data (if any)
*.key
*.pem
.env
"@
$gitignore | Out-File -FilePath "$fullPath\.gitignore" -Encoding UTF8

Write-Host ""
Write-Host "=== Setup Complete! ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Navigate to: $fullPath" -ForegroundColor White
Write-Host "2. Copy schema template:" -ForegroundColor White
Write-Host "   Copy: .qwen\llm-kb-schema-template.md" -ForegroundColor Gray
Write-Host "   To:   SCHEMA.md (replace placeholder)" -ForegroundColor Gray
Write-Host "3. Customize SCHEMA.md for your domain" -ForegroundColor White
Write-Host "4. Add 3-5 source documents to raw/" -ForegroundColor White
Write-Host "5. Initialize git repo:" -ForegroundColor White
Write-Host "   git init && git add . && git commit -m 'Initialize KB'" -ForegroundColor Gray
Write-Host "6. Open in Obsidian (create vault at this path)" -ForegroundColor White
Write-Host "7. Start first ingestion with LLM agent" -ForegroundColor White
Write-Host ""
Write-Host "See .qwen\llm-kb-setup-checklist.md for full checklist" -ForegroundColor Gray
