# Document Classification Metadata System

## Overview

The site now uses a metadata-based system to automatically classify and organize content into **Blog Posts** and **White Papers** using YAML front matter fields.

## Document Types

### Blog Posts (`document-type: "blog"`)
- **Purpose**: Tutorials, explorations, casual technical content
- **Examples**: Palmer Penguins series, Git setup guides, Vim configurations
- **Display**: Listed on `/blog/` with Quarto's built-in search and filtering

### White Papers (`document-type: "white-paper"`)
- **Purpose**: In-depth technical reports, methodological frameworks, architectural guides
- **Examples**: Research management workflows, EDC system specifications, Docker deployment guides
- **Display**: Listed on `/white-papers/` with professional categorization

## Implementation

### Adding Metadata to Posts

Add the `document-type` field to your YAML front matter:

```yaml
---
title: "Your Post Title"
date: "2025-01-01"
document-type: "blog"  # or "white-paper"
categories: [Category1, Category2]
description: "Brief description of the content"
---
```

### Automatic Filtering

Both pages use Quarto's listing feature with metadata filters:

**Blog Page (`/blog/index.qmd`)**:
```yaml
listing:
  contents: "../posts/*/index.qmd"
  include:
    document-type: "blog"
```

**White Papers Page (`/white-papers/index.qmd`)**:
```yaml
listing:
  contents: "../posts/*/index.qmd"
  include:
    document-type: "white-paper"
```

## Classification Guidelines

### Choose "blog" for:
- Step-by-step tutorials
- Exploratory data analysis
- Tool setup guides
- Code examples and snippets
- Personal insights and tips

### Choose "white-paper" for:
- Comprehensive technical specifications
- Methodological frameworks
- Software architecture documents
- Implementation guides with detailed workflows
- Research methodology reports

## Benefits

1. **Automatic Organization**: No more manual maintenance of post lists
2. **Consistent Classification**: Clear criteria for categorization
3. **Built-in Search**: Quarto's native filtering and search functionality
4. **Scalable**: Easy to add new posts without updating multiple files
5. **Flexible**: Can add more document types in the future

## Current Status

- **✅ Palmer Penguins Series**: All 5 parts classified as `blog`
- **✅ Selected Blog Posts**: Git setup, Vim configs, etc. classified as `blog`
- **✅ Technical Reports**: Research workflows, Docker guides, etc. classified as `white-paper`
- **⏳ Remaining Posts**: Many posts still need classification (will show up in neither section until classified)

## Adding New Posts

1. Create your post in `/posts/your-post-name/index.qmd`
2. Add appropriate `document-type` to the YAML front matter
3. Include relevant `categories` and `description` fields
4. The post will automatically appear on the appropriate listing page

## Migration Script

A helper script is available at `/add_metadata.sh` to batch-add metadata to existing posts.