# Anatomy of an Engaging Technical Blog Post

**Based on the 39-templatepost exemplar**

This document is a standalone reference for authors creating new blog
posts within the qblog project. It distils the structural conventions,
visual rhythm strategy, and analysis pipeline architecture embedded in
the template at
`posts/39-templatepost/templatepost/analysis/report/index.qmd` into a
single, scannable guide.

For implementation details on ZZCOLLAB project setup, Docker
configuration, and CI/CD workflows, see
`posts/39-templatepost/templatepost/docs/ZZCOLLAB_BLOG_SETUP.md`. For
architectural design rationale, see
`posts/39-templatepost/templatepost/docs/ARCHITECTURE_REVIEW.md`.

---

## 1. Overview

Two guiding principles govern every blog post in this system:

**Separation of concerns.** Analysis code lives in numbered R scripts
under `analysis/scripts/`. The narrative document (`index.qmd`) loads
pre-computed results from CSV files and pre-generated figures from
`analysis/figures/`. The narrative file never fits models, transforms
data, or generates plots inline.

**Visual rhythm.** A well-paced technical post interleaves dense
analytical content with atmospheric images that provide cognitive rest
points. The target is 7-8 images total: 3-4 engagement images
(atmospheric, reader-retention) and 3-4 technical figures (R-generated
analysis plots).

---

## 2. Visual Inventory

### 2.1 The 7-8 Image Strategy

Each blog post should contain approximately:

- **1 hero image** (80% width) -- first visual impression, appears in
  blog listings
- **2-3 ambiance images** (100% width) -- atmospheric photographs or
  illustrations placed at natural transition points to break dense
  technical prose
- **3-4 technical figures** (100% width, 600-800px height) --
  R-generated analysis plots loaded via `knitr::include_graphics()`

### 2.2 Sizing Conventions

| Image Type       | Width | Height     | Placement              |
|------------------|-------|------------|------------------------|
| Hero             | 80%   | auto       | Below title, above Introduction |
| Ambiance         | 100%  | auto/500px | Between major sections |
| Technical figure | 100%  | 600-800px  | Inline with analysis   |

### 2.3 Placement Rhythm (ASCII Diagram)

```
  HERO IMAGE (80%)
  ─────────────────
  Introduction
  Motivations
  Objectives
  ─────────────────
  AMBIANCE IMAGE 1 (100%)
  ─────────────────
  Prerequisites
  Conceptual Foundation
  Initial Exploration
  TECHNICAL FIGURE 1
  ─────────────────
  AMBIANCE IMAGE 2 (100%)
  ─────────────────
  Deeper Analysis
  TECHNICAL FIGURE 2
  Model Building
  TECHNICAL FIGURE 3
  Diagnostics
  TECHNICAL FIGURE 4
  Gotchas
  ─────────────────
  AMBIANCE IMAGE 3 (100%)
  ─────────────────
  Lessons Learnt
  Limitations
  Opportunities
  Wrapping Up
  See Also
  Reproducibility
  Let's Connect
```

### 2.4 Caption and Alt Text Requirements

Every image must include:

- **Alt text** (`fig-alt`): Descriptive text for screen readers.
  Describe the visual content, not the interpretation.
- **Caption** (`fig-cap` or italic text below): Interpretive text that
  helps the reader understand what the image contributes to the
  narrative.
- **Attribution**: For external images, document source and licence in
  `analysis/media/images/README.md`.

Markdown syntax for engagement images:

```markdown
![Alt text description](media/images/filename.jpg){.img-fluid
width=80%}

*Caption with attribution if needed.*
```

R chunk syntax for technical figures:

````markdown
```{r}
#| label: figure-name
#| fig-cap: "Interpretive caption."
#| fig-alt: "Descriptive alt text."
knitr::include_graphics("figures/figure-name.png")
```
````

---

## 3. Section-by-Section Reference

### 3a. YAML Front Matter

**Heading level:** None (document metadata)
**Purpose:** Define post metadata for Quarto rendering and blog
listing display.

**Required fields:**

```yaml
---
title: "Engaging, specific title"
subtitle: "Clarifying subtitle"
author: "Ronald G. Thomas"
date: "YYYY-MM-DD"
categories: [Category1, Category2, Category3]
description: "One-sentence summary for blog listing."
image: "media/images/hero-image.jpg"
document-type: "blog"
draft: true
execute:
  echo: true
  warning: false
  message: false
format:
  html:
    code-fold: false
    code-tools: false
---
```

**Guidance:** Set `draft: true` during development. The `description`
field should use the personal hook style ("I didn't really know
about..."). Categories should be 2-3 terms from the existing taxonomy
(R Programming, Data Science, Statistical Computing, etc.). Set
`draft: false` only when ready to publish.

---

### 3b. Hero Image

**Heading level:** None (standalone element)
**Purpose:** Set the visual tone; appears in blog listing thumbnails.
**Length:** 2 lines (image + caption)

**Guidance:** Choose an image that is engaging, relevant to the topic,
and high quality (300+ DPI). Width should be 80% to leave breathing
room. Source from Unsplash, Wikimedia Commons, or original
photography. Document attribution in
`analysis/media/images/README.md`.

```markdown
![Engaging hero image](media/images/hero.jpg){.img-fluid width=80%}

*Photo caption with attribution.*
```

---

### 3c. Introduction

**Heading level:** `#`
**Purpose:** Hook the reader with a personal learning narrative.
**Length:** 2-3 paragraphs

**Guidance:** Open with an "I didn't really know... until..." hook.
Position the author as a learner, not an expert. First paragraph
states the discovery; second provides brief context (the problem
faced); third transitions to what the post will accomplish.

Avoid lengthy background or literature review here. Save detailed
explanations for the Conceptual Foundation section.

---

### 3d. Motivations

**Heading level:** `##`
**Purpose:** Explain why the topic matters to the author personally.
**Length:** 4-6 bullet points

**Guidance:** Make it personal and specific. Do not write "optimization
is important"; write "I was frustrated that my analysis took 3 hours
to run on a 2M row dataset." Each bullet should be a concrete reason:
a specific problem faced, a gap in the workflow, a skill to develop,
or a curiosity to satisfy.

---

### 3e. Objectives

**Heading level:** `##`
**Purpose:** Give the reader a mental roadmap of what they will learn.
**Length:** 4 numbered items + 1 disclaimer line

**Guidance:** Objectives must be specific and measurable. Bad: "Learn
about modeling." Good: "Fit a linear regression, compare R-squared
values, and identify which variables predict MPG." The objectives
should match what the post actually accomplishes. Include a disclaimer
acknowledging the learning process: "I'm documenting my learning
process here. If you spot errors or have better approaches, please
let me know."

---

### 3f. Ambiance Image 1

**Heading level:** None (standalone element)
**Purpose:** Break dense introductory text and maintain reader
engagement.
**Length:** 1 line

**Guidance:** Place after the Objectives section. Use 100% width. The
image should relate to the topic but can be atmospheric or creative
rather than technical. Examples: overhead desk setup, code editor
screenshot, topic-related artwork.

---

### 3g. Prerequisites and Setup

**Heading level:** `#`
**Purpose:** Show readers what they need to follow along.
**Length:** 1-2 code blocks + 1 paragraph

**Guidance:** Keep it minimal and conversational. Show library loading
and data loading from pre-prepared CSV files. Do not include inline
data cleaning -- that belongs in `01_prepare_data.R`. Include a brief
"Background" note on assumed knowledge. The data should already be
prepared by the analysis pipeline; this section loads it.

```r
library(tidyverse)
source("R/plotting_utils.R")
setup_plot_theme()
colors <- get_analysis_colors()
mtcars_clean <- read_csv(
  "data/derived_data/mtcars_clean.csv",
  show_col_types = FALSE
)
```

---

### 3h. Conceptual Foundation ("What is X?")

**Heading level:** `#`
**Purpose:** Explain the core concept in plain language before showing
code.
**Length:** 1-2 paragraphs (2-4 sentences each)

**Guidance:** Structure: (1) simple one-sentence definition, (2)
analogy or comparison, (3) concrete example, (4) transition to code.
Readers without domain expertise should understand the concept after
reading this section. Keep it brief -- the analysis sections provide
depth.

---

### 3i. Initial Exploration + Technical Figure 1

**Heading level:** `#` ("Getting Started: Initial Exploration")
**Purpose:** Begin the analysis with data overview and exploratory
visualisation.
**Length:** 2-3 code blocks + 2-3 interpretation paragraphs + 1 figure

**Guidance:** Follow the pattern: CODE -> OUTPUT -> INTERPRETATION
(2-4 sentences). Aim for ~40% code, 60% explanation. Do not explain
every line of R code; assume the reader can follow basic tidyverse
syntax. Focus on the "why" and "what does this mean." Include a
summary statistics table using `knitr::kable()`.

The technical figure should be loaded via
`knitr::include_graphics("figures/eda-overview.png")` with both
`fig-cap` and `fig-alt` attributes.

---

### 3j. Ambiance Image 2

**Heading level:** None (standalone element)
**Purpose:** Provide a mental break after the first major analytical
section.
**Length:** 1 line

**Guidance:** Place after the first technical figure section. This
creates the rhythm: text -> figure -> ambiance -> text -> figure.
Use 100% width.

---

### 3k. Deeper Analysis + Technical Figure 2

**Heading level:** `##` ("Looking for Relationships")
**Purpose:** Move beyond exploration to focused investigation.
**Length:** 2-3 code blocks + interpretation + 1 figure

**Guidance:** Build on initial exploration findings. Show correlation
analysis, cross-tabulations, or grouped summaries. Each code block
should be followed by brief interpretation. Load the pre-generated
correlation or relationship figure.

---

### 3l. Model Building + Technical Figure 3

**Heading level:** `#` ("Building a Model")
**Purpose:** Present the core statistical or machine learning model.
**Length:** 3-4 code blocks + results tables + 1 figure

**Guidance:** This is the heart of the post. Load pre-computed model
results from CSV files (coefficients, metrics, diagnostics). Display
in clean tables using `knitr::kable()`. Provide brief interpretation
of each table. Include confidence intervals alongside point estimates.
Show a practical application subsection ("Making Predictions") with
concrete examples using actual numbers.

Key principle: results were computed by `02_fit_models.R`. This
section presents and interprets them.

---

### 3m. Diagnostics + Technical Figure 4

**Heading level:** `#` ("Checking Our Work")
**Purpose:** Validate model assumptions and demonstrate rigour.
**Length:** 1-2 code blocks + interpretation + 1 figure

**Guidance:** Load pre-computed diagnostics from CSV. Report outlier
count and residual standard error. Display the diagnostic residual
plot. Be transparent about potential issues. This section demonstrates
scientific maturity -- do not hide problems.

---

### 3n. Gotchas

**Heading level:** `##` ("Things to Watch Out For")
**Purpose:** Share lessons learned the hard way.
**Length:** 4-5 numbered items

**Guidance:** Use first person: "I found that..." or "Watch out
for..." Be conversational and personal. Each gotcha should be
actionable. Bold the main point, then explain in one sentence.

---

### 3o. Ambiance Image 3

**Heading level:** None (standalone element)
**Purpose:** Final atmospheric image; visual bookend before the
concluding sections.
**Length:** 1 line

**Guidance:** Place before "Lessons Learnt." Ties back to the topic
theme. Creates visual closure around the main analysis.

---

### 3p. Lessons Learnt

**Heading level:** `## Lessons Learnt`
**Purpose:** Summarise key takeaways in three categories.
**Length:** 3 subsections, 4 bullets each

**Guidance:** This is a signature section. Organise into three
categories:

- **Conceptual Understanding**: What did you learn about the domain?
  Include specific quantitative results (R-squared values, effect
  sizes, confidence intervals).
- **Technical Skills**: What tools or techniques did you master?
  Reference specific packages and functions.
- **Gotchas and Pitfalls**: What could go wrong? Practical warnings
  for future practitioners.

---

### 3q. Limitations

**Heading level:** `##`
**Purpose:** Honest assessment of what the analysis cannot claim.
**Length:** 5-6 bullet points

**Guidance:** Acknowledge limitations upfront. Cover data limitations
(age, sample size, missing variables), model limitations (assumptions,
scope), and methodological limitations (confounding, generalisability).
Keep it concise -- bullet points work well.

---

### 3r. Opportunities for Improvement

**Heading level:** `##`
**Purpose:** Forward-looking section on what could be done next.
**Length:** 5-6 numbered items

**Guidance:** Describe extensions to try, better approaches to
consider, and future directions. Each item should be specific and
actionable. This helps readers see where research or learning could
go next.

---

### 3s. Wrapping Up

**Heading level:** `#`
**Purpose:** Conclude with a short, friendly summary.
**Length:** 2-3 paragraphs + 1 bulleted summary

**Guidance:** First paragraph: one-sentence recap of the main finding.
Second paragraph: what you learned personally. Third paragraph: advice
for readers trying this themselves. Include a bulleted "Main
takeaways" list with 3-4 quantitative results. End on a warm,
collaborative note.

---

### 3t. See Also

**Heading level:** `#`
**Purpose:** Point readers to related posts and key resources.
**Length:** 3-5 links for related posts + 4-5 links for key resources

**Guidance:** Keep this section simple. Link to related blog posts in
the series and a small number of high-quality external resources (free
textbooks, official documentation, community forums). This is not an
exhaustive bibliography.

---

### 3u. Reproducibility

**Heading level:** `#`
**Purpose:** Enable readers to reproduce the analysis end-to-end.
**Length:** 2 code blocks + file listing

**Guidance:** Document the data source, the analysis pipeline commands
(`make docker-build && make docker-post-render` or step-by-step
`Rscript` calls), and list all reproducible code files with brief
descriptions. Include `sessionInfo()` output. This section is the
contract with the reader: everything needed to reproduce the work is
documented here.

```bash
Rscript analysis/scripts/01_prepare_data.R
Rscript analysis/scripts/02_fit_models.R
Rscript analysis/scripts/03_generate_figures.R
quarto render index.qmd
```

---

### 3v. Let's Connect

**Heading level:** `#`
**Purpose:** Invite questions, corrections, and collaboration.
**Length:** Contact links + 5-bullet invitation list

**Guidance:** Include social media links (Twitter/X, Mastodon,
GitHub, email). List specific reasons to reach out: spot errors, have
suggestions, want to discuss, have questions, or just want to connect.
Tone should be welcoming and human.

---

## 4. Visual Rhythm Diagram

The full layout of a blog post, showing how prose, images, and
figures interleave:

```
+-------------------------------------------------------+
|  YAML FRONT MATTER                                    |
+-------------------------------------------------------+
|  HERO IMAGE (80% width)                               |
|  Caption + attribution                                |
+-------------------------------------------------------+
|  # Introduction (2-3 paragraphs, personal hook)       |
|  ## Motivations (4-6 bullets)                         |
|  ## Objectives (4 numbered items + disclaimer)        |
+-------------------------------------------------------+
|  AMBIANCE IMAGE 1 (100% width)                        |
+-------------------------------------------------------+
|  # Prerequisites and Setup (code + explanation)       |
|  # What is [Topic]? (plain language, 2-4 sentences)   |
|  # Getting Started: Initial Exploration               |
|     code -> output -> interpretation                  |
|     TECHNICAL FIGURE 1 (EDA overview)                 |
+-------------------------------------------------------+
|  AMBIANCE IMAGE 2 (100% width)                        |
+-------------------------------------------------------+
|  ## Looking for Relationships                         |
|     code -> output -> interpretation                  |
|     TECHNICAL FIGURE 2 (correlation/relationship)     |
|  # Building a Model                                   |
|     load pre-computed results -> tables -> interpret   |
|     TECHNICAL FIGURE 3 (model fit)                    |
|  ## Making Predictions (practical application)        |
|  # Checking Our Work                                  |
|     diagnostics -> residual plot -> interpret          |
|     TECHNICAL FIGURE 4 (diagnostics)                  |
|  ## Things to Watch Out For (4-5 gotchas)             |
+-------------------------------------------------------+
|  AMBIANCE IMAGE 3 (100% width)                        |
+-------------------------------------------------------+
|  ## Lessons Learnt (3 categories x 4 bullets)         |
|  ## Limitations (5-6 bullets)                         |
|  ## Opportunities for Improvement (5-6 items)         |
|  # Wrapping Up (2-3 paragraphs + summary)             |
|  # See Also (3-5 links)                               |
|  # Reproducibility (pipeline + session info)          |
|  # Let's Connect (contact links)                      |
+-------------------------------------------------------+
```

---

## 5. The Analysis Pipeline

The separation of concerns is enforced through a three-script
pipeline. Each script reads inputs and writes outputs to well-defined
locations. The narrative document (`index.qmd`) only reads final
outputs.

### 5.1 Pipeline Architecture

```
analysis/scripts/01_prepare_data.R
    reads:  built-in dataset or analysis/data/raw_data/
    writes: analysis/data/derived_data/dataset_clean.csv
            (+ logging to console)

analysis/scripts/02_fit_models.R
    reads:  analysis/data/derived_data/dataset_clean.csv
    writes: analysis/data/derived_data/model_coefficients.csv
            analysis/data/derived_data/model_metrics.csv
            analysis/data/derived_data/model_diagnostics.csv
            analysis/data/derived_data/simple_model.rds

analysis/scripts/03_generate_figures.R
    reads:  analysis/data/derived_data/*.csv
            R/plotting_utils.R (source'd for theme, colours, save)
    writes: analysis/figures/eda-overview.png
            analysis/figures/correlation-plot.png
            analysis/figures/model-plot.png
            analysis/figures/diagnostics-plot.png

analysis/report/index.qmd
    reads:  analysis/data/derived_data/*.csv
            analysis/figures/*.png
            (via symlinks: data/ -> analysis/data/,
             figures/ -> analysis/figures/)
    writes: nothing (pure narrative)
```

### 5.2 Reusable Utilities

The file `R/plotting_utils.R` provides five functions shared across
blog posts:

- `setup_plot_theme(base_size)` -- sets ggplot2 `theme_minimal()`
  globally
- `get_analysis_colors()` -- returns a named vector of four hex
  colours (primary, secondary, tertiary, quaternary)
- `save_plot(filename, plot, width, height, dpi)` -- consistent
  `ggsave()` wrapper with automatic directory creation
- `combine_plots(..., ncol, heights)` -- patchwork grid layout helper
- `extract_plot_data(plot, layer_index, aesthetic)` -- testing
  utility for extracting data from ggplot layers

### 5.3 Symlink System

Root-level symlinks enable Quarto to resolve paths while authors
work in the `analysis/report/` directory:

```
templatepost/
  index.qmd   -> analysis/report/index.qmd
  data/        -> analysis/data/
  figures/     -> analysis/figures/
  media/       -> analysis/media/
```

Within `analysis/report/`, corresponding symlinks point upward:

```
analysis/report/
  data/    -> ../data/
  figures/ -> ../figures/
  media/   -> ../media/
```

---

## 6. Image Sourcing and Attribution

### 6.1 Where to Find Images

- **Unsplash** (unsplash.com): Free high-quality photographs. No
  attribution required by licence, but encouraged.
- **Wikimedia Commons** (commons.wikimedia.org): Creative Commons
  images. Check individual licence terms.
- **Pixabay** (pixabay.com): Free images under Pixabay licence.
- **Original photography**: Preferred when available.

### 6.2 Licence Requirements

All images used in posts must be either:

- Public domain or CC0
- Creative Commons (CC BY, CC BY-SA) with proper attribution
- Original work by the author

Do not use images from Google Image Search without verifying the
licence.

### 6.3 Attribution Format

Document every external image in
`analysis/media/images/README.md`:

```markdown
## Image Attribution

### hero-image.jpg
- **Source**: Unsplash
- **Photographer**: Jane Doe
- **URL**: https://unsplash.com/photos/xxxxx
- **Licence**: Unsplash Licence
- **Downloaded**: 2026-01-15
```

In the post itself, provide a brief attribution in the image caption:

```markdown
*Photo by Jane Doe on Unsplash.*
```

---

## 7. Pre-Publication Checklist

### YAML Configuration

- [ ] Unique, engaging title
- [ ] Descriptive subtitle
- [ ] Correct author name and date
- [ ] 2-3 relevant categories from existing taxonomy
- [ ] Brief description for blog listing
- [ ] Hero image path (`media/images/...`)
- [ ] `document-type: "blog"`
- [ ] `draft: false` when ready to publish

### Structure

- [ ] Introduction with personal hook (2-3 paragraphs)
- [ ] Motivations section (personal reasons)
- [ ] Objectives section (numbered, measurable)
- [ ] Conceptual explanation ("What is X?")
- [ ] Analysis sections follow CODE -> OUTPUT -> INTERPRETATION
- [ ] Summary statistics table present
- [ ] Lessons Learnt section (3 categories)
- [ ] Limitations (honest assessment)
- [ ] Opportunities for Improvement
- [ ] Conclusion (short, friendly)
- [ ] See Also (3-5 key links)
- [ ] Reproducibility section with pipeline commands

### Visual Design

- [ ] Hero image at top (80% width)
- [ ] 2-3 ambiance images for visual rhythm (100% width)
- [ ] 3-4 technical figures with captions and alt text
- [ ] Consistent image sizing throughout
- [ ] Professional spacing between sections

### Analysis Integration

- [ ] All analysis code in `analysis/scripts/` (01_, 02_, 03_)
- [ ] No inline model fitting (load from CSV)
- [ ] No inline figure generation (load from `analysis/figures/`)
- [ ] Data loaded from derived CSVs, not raw sources
- [ ] Utilities loaded via `source("R/plotting_utils.R")`

### Content Quality

- [ ] Tone is personal and conversational
- [ ] Author positioned as learner, not expert
- [ ] No emoji in narrative text
- [ ] Explanations are 2-4 sentences between code blocks
- [ ] Results interpreted, not merely displayed
- [ ] No unexplained statistics
- [ ] Confidence intervals reported alongside point estimates

### Reproducibility

- [ ] Analysis pipeline commands documented
- [ ] Docker/renv setup described
- [ ] Reader can clone and reproduce end-to-end
- [ ] `sessionInfo()` included
- [ ] Links to all scripts and data files

### Metadata and Accessibility

- [ ] All images have descriptive captions
- [ ] All figures have alt text
- [ ] References properly cited where applicable
- [ ] Contact information provided

---

## 8. Quick Reference Card

### File Paths

```
analysis/report/index.qmd     Main narrative document
analysis/scripts/01_*.R        Data preparation
analysis/scripts/02_*.R        Model fitting
analysis/scripts/03_*.R        Figure generation
analysis/data/raw_data/        Original data
analysis/data/derived_data/    Computed outputs (CSV, RDS)
analysis/figures/              R-generated PNG plots
analysis/media/images/         Engagement images
R/plotting_utils.R             Shared plotting utilities
tests/testthat/                Unit tests
tests/integration/             Pipeline integration tests
```

### Commands

```bash
# Run analysis pipeline
Rscript analysis/scripts/01_prepare_data.R
Rscript analysis/scripts/02_fit_models.R
Rscript analysis/scripts/03_generate_figures.R

# Render blog post
quarto render index.qmd

# Docker workflow
make docker-build
make docker-post-render

# Run tests
Rscript -e 'testthat::test_local()'
Rscript tests/integration/test-analysis-pipeline.R
```

### Visual Rhythm Pattern

```
HERO (80%)  ->  text  ->  AMBIANCE 1  ->  text + FIGURE 1
  ->  AMBIANCE 2  ->  text + FIGURES 2-4  ->  AMBIANCE 3
  ->  text (lessons, limitations, conclusion)
```

### Image Sizing Quick Reference

```markdown
Hero:     {.img-fluid width=80%}
Ambiance: {.img-fluid}
Figure:   knitr::include_graphics("figures/name.png")
```

---

*This document describes the structure of an engaging technical blog
post as implemented in the 39-templatepost exemplar. For setup
instructions, consult `ZZCOLLAB_BLOG_SETUP.md`. For architectural
rationale, consult `ARCHITECTURE_REVIEW.md`. Both files reside in
`posts/39-templatepost/templatepost/docs/`.*
