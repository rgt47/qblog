# Draft System for qblog

This document explains how to manage draft posts in your Quarto blog.

## Quick Start

### Mark a post as draft
```bash
./manage_drafts.sh draft posts/my-post-name/
```

### Publish a draft
```bash
./manage_drafts.sh publish posts/my-post-name/
```

## Manual Method

Add `draft: true` to the YAML frontmatter of any post:

```yaml
---
title: 'My Post Title'
date: last-modified
draft: true
---
```

## How It Works

### Draft Posts Are:
- ✅ **Rendered** but not listed publicly
- ✅ **Accessible** via direct URL for review
- ❌ **Excluded** from main blog listing
- ❌ **Excluded** from RSS feeds
- ❌ **Excluded** from search engines (via robots.txt)

### Published Posts Are:
- ✅ **Listed** on main blog page (`/posts/`)
- ✅ **Included** in RSS feeds
- ✅ **Searchable** and indexed
- ✅ **Linked** from other pages

## Viewing Drafts

### All Draft Posts
Visit `/posts/drafts.html` to see all posts marked as drafts.

### Individual Draft Posts
Draft posts are still rendered and accessible at their normal URLs:
- `/posts/my-draft-post/` (still works for review)

## Advanced Usage

### Batch Operations
```bash
# Mark multiple posts as drafts
for post in posts/draft-post-*; do
    ./manage_drafts.sh draft "$post"
done

# Publish multiple posts
for post in posts/ready-*; do
    ./manage_drafts.sh publish "$post"
done
```

### Check Draft Status
```bash
# List all draft posts
grep -l "^draft: true" posts/*/index.qmd

# List all published posts (no draft: true)
grep -L "^draft: true" posts/*/index.qmd
```

## Development Workflow

1. **Create new post**: Start with `draft: true`
2. **Develop content**: Edit and preview via direct URL
3. **Review**: Share direct URL with collaborators
4. **Publish**: Remove `draft: true` or use script
5. **Re-render**: Blog automatically updates listings

## Configuration Files

- `posts/index.qmd` - Main blog listing (excludes drafts)
- `posts/drafts.qmd` - Draft posts listing
- `manage_drafts.sh` - Automation script
- `_quarto.yml` - Project-level configuration

## Tips

- **Preview drafts**: Use `quarto preview` to see drafts locally
- **Share for review**: Draft URLs work for sharing with collaborators
- **Organize**: Keep draft posts in a consistent naming scheme
- **Version control**: Git tracks draft status changes

## Troubleshooting

### Draft still appears in listing
- Check YAML formatting: ensure `draft: true` (not `Draft: true`)
- Re-render the blog: `quarto render posts/index.qmd`

### Can't access draft post
- Ensure the post is still being rendered
- Check the direct URL: `/posts/post-name/`

### Script not working
- Ensure script is executable: `chmod +x manage_drafts.sh`
- Check file paths are correct
- Verify YAML frontmatter format