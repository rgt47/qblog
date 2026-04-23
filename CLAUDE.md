# qblog - Quarto Website (focusonr.org)

## Project Overview

Quarto-based personal website and blog hosted on Netlify. Contains 48 blog posts, a research page (321 publications), and white papers. Two template posts (39 for data analysis, 47 for setup/tooling) define the structural standard all posts should follow.

## Key Commands

```bash
# Render single post
cd ~/Dropbox/prj/qblog && quarto render "posts/<post-dir>/index.qmd" --to html

# Render entire site
cd ~/Dropbox/prj/qblog && quarto render

# Preview site locally
quarto preview

# Process a hero image from Gemini download
magick ~/Downloads/Gemini_Generated_Image_XXXX.png -resize 1600x -strip -quality 85 hero.jpg
```

## Site Structure

```
qblog/
  _quarto.yml          # Site configuration
  _includes/after-body.html  # Custom JS (category filtering)
  netlify.toml         # Deployment config (serves pre-built _site/)
  blog/index.qmd       # Blog listing (filters document-type: "blog")
  white-papers/index.qmd  # White paper listing (filters document-type: "white-paper")
  research/index.qmd   # 321 publications with JS filtering
  about/index.qmd      # Bio page
  teaching/index.qmd   # Placeholder
  posts/               # All content (48 posts)
  _archive/            # Archived backup/temp files
```

## Post Layout (zzcollab convention)

```
posts/NN-name/name/
  index.qmd            # Symlink to analysis/report/index.qmd
  analysis/
    report/index.qmd   # The actual post content
    scripts/           # 01_prepare_data.R, 02_fit_models.R, etc.
    data/              # raw_data/, derived_data/
    figures/           # Pre-generated PNG figures
    media/images/      # Hero + ambiance images + README.md
    configs/           # Config files (setup posts only)
  R/                   # Reusable functions
  tests/               # testthat + integration tests
  Dockerfile, Makefile, renv.lock, DESCRIPTION
  media/ -> analysis/media/  # Symlink
```

## Two Templates

Every post conforms to one of two templates:

- **Post 39 (data analysis)**: R/Python/Julia analysis of public datasets.
  Sections: Intro, Motivations, Objectives, What is [Topic]?, Prerequisites,
  analysis CODE->OUTPUT->INTERPRETATION, Lessons Learnt (3 buckets),
  Limitations, Opportunities, Wrapping Up, See Also, Reproducibility
  (sessionInfo), Let's Connect.

- **Post 47 (setup/tooling)**: Installation, configuration, workflow tools.
  Sections: Intro, Motivations, Objectives, What is [Tool]?, Prerequisites,
  Installation, Configuration, Verification, Daily Workflow (command table),
  Things to Watch Out For (5-7 gotchas, required), Uninstall/Rollback,
  Lessons Learnt, Limitations, Opportunities, Wrapping Up, See Also,
  Reproducibility (version matrix), Let's Connect.

Classification: 12 posts are template-39, 30 posts are template-47.
See `TEMPLATE_CONFORMANCE_PLAN.md` for per-post gap analysis.

## Image Convention

Each post has 4 images in `media/images/`:

- `hero.jpg` (80% width) -- AI-generated via Imagen 3 / Gemini
- 3 ambiance images (100% width) -- currently `placeholder-coffee-01.jpg`
  through `05.jpg` (temporary; replace with post-specific screenshots)
- `README.md` with attributions for every image

See `IMAGE_GENERATION_PLAN.md` for sourcing strategy and AI prompt templates.
See `HERO_IMAGE_PROMPTS.md` for per-post Gemini prompts and progress tracker.

## Hero Image Status

Generated via Google Imagen 3 (Gemini). Process: paste prompt from
`HERO_IMAGE_PROMPTS.md`, download PNG, run `magick -resize 1600x -strip
-quality 85 hero.jpg`.

| Status | Posts |
|--------|-------|
| DONE | 01, 03, 04, 07, 09, 10, 11, 12, 15, 16, 17, 18, 19, 22, 23, 25, 35, 38, 40, 43 |
| KEEP (existing is appropriate) | 08, 13, 14, 20, 21, 24, 33 |
| RESIZE ONLY (done) | 08, 13 |
| TODO (prompts in HERO_IMAGE_PROMPTS.md) | 02, 05, 06, 26, 27, 28, 29, 30, 31, 32, 34, 36, 37, 39, 41, 42, 48 |

## Template Conformance Status

Tier 1 (published, structural fixes applied):
01, 02, 03, 04, 07, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
26, 29, 43 -- all have: What Did We Learn? wrapper, Lessons Learnt
(3 buckets), Let's Connect, Verification, Daily Workflow, Uninstall/Rollback.

Tier 2-4 (drafts needing content + template sections): see
`TEMPLATE_CONFORMANCE_PLAN.md`.

## Content Classification

Posts use YAML front matter `document-type` to appear on the correct listing page:

```yaml
document-type: "blog"        # appears on /blog/
document-type: "white-paper"  # appears on /white-papers/
```

## Draft System

- `draft: true` in YAML hides from listings and site
- `draft: false` (or omitted) publishes the post
- To publish: set `draft: false` and re-render

## ZZCOLLAB Integration

Blog posts use the `ubuntu_x11_analysis` profile. Each post has:

- `Dockerfile` (shared, standardized)
- `.github/workflows/r-package.yml` (shared, 12-step CI/CD)
- `renv.lock` (unique per post)

Docker CI/CD runs as root to fix GitHub Actions permissions, then `su` to analyst user.

## Netlify Deployment

- Branch: `main`
- Publish directory: `_site` (pre-built, no build command)
- `netlify.toml` prevents Netlify from running its own build

## Category Filtering

- Blog page: Quarto native listings with base64-encoded category filtering (fix in `_includes/after-body.html`)
- Research page: Custom JS for tag, year, and topic filtering
- White papers page: Custom JS search and category dropdown

## Known Quirks

- Avoid emojis in `.qmd` files (causes PDF rendering issues)
- `message: false` in YAML suppresses `cat()` output; use `message: true` if cat output is needed
- Mixing markdown and HTML blocks causes inconsistent rendering; use unified HTML blocks for research page
- No em dashes; use parens or commas instead
- Single quotes preferred over double quotes in prose
- 78-character line wrap for prose in `.qmd` files
