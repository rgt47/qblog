# Template Conformance Plan

Every blog post should conform to one of two templates:

- **Template 39** (data analysis): analysis of public datasets with R/Python/Julia
- **Template 47** (setup/tooling): installation, configuration, or workflow enhancement

This plan classifies each post and lists the structural gaps to close.

---

## Classification summary

| Template | Count | Posts |
|----------|-------|-------|
| 39 (analysis) | 12 | 04, 08, 09, 10, 11, 12, 13, 14, 15, 16, 19, 43 |
| 47 (setup) | 30 | 01, 02, 03, 05, 06, 07, 17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 40, 41, 42, 48 |
| Templates | 2 | 39, 47 |
| Stubs | 3 | 05, 27, 44 |

---

## Template 39 required sections

1. YAML (title, subtitle, author, date, categories, description, image, document-type, draft)
2. Hero image (80% width)
3. Introduction ('I didn't know X until Y' hook, 2-3 paragraphs)
4. Motivations (4+ personal bullets)
5. Objectives (4 numbered, measurable)
6. Ambiance image 1
7. What is [Topic]? (definition + analogy + example)
8. Prerequisites and Setup (load libraries, load prepared data)
9. Analysis sections (CODE -> OUTPUT -> INTERPRETATION, ~40:60 ratio)
10. Pre-generated figures via knitr::include_graphics (fig-cap + fig-alt)
11. Ambiance image 2
12. Things to Watch Out For (gotchas)
13. Ambiance image 3
14. What Did We Learn? / Lessons Learnt (Conceptual + Technical + Gotchas)
15. Limitations (5 bullets)
16. Opportunities for Improvement (6 numbered)
17. Wrapping Up (3 paragraphs + Main takeaways)
18. See Also (3-5 links)
19. Reproducibility (pipeline commands + sessionInfo)
20. Let's Connect

## Template 47 required sections

1. YAML (same fields)
2. Hero image (80% width)
3. Introduction ('I didn't know how to configure X until Y')
4. Motivations (4-5 personal bullets)
5. Objectives (4 numbered, verifiable)
6. Ambiance image 1
7. What is [Tool]? (definition + analogy + example)
8. Prerequisites (OS, hardware, dependencies, time estimate)
9. Installation (copy-pasteable bash commands)
10. Configuration (COMPLETE files, not snippets)
11. Ambiance image 2
12. Verification (version check + config introspection + functional smoke test)
13. Daily Workflow (command/keybinding reference table)
14. Things to Watch Out For (5-7 gotchas, REQUIRED)
15. Uninstall / Rollback
16. Ambiance image 3
17. What Did We Learn? / Lessons Learnt (Conceptual + Technical + Gotchas)
18. Limitations (4-6 bullets)
19. Opportunities for Improvement (5-6 numbered)
20. Wrapping Up (2-3 paragraphs + Main takeaways)
21. See Also (3-5 links)
22. Reproducibility (version matrix table, NOT sessionInfo)
23. Let's Connect

---

## Per-post gap analysis

### Template 39 posts (data analysis)

#### Post 04 -- Set Names to Lowercase for Multiple Dataframes [draft:false]

- [x] YAML complete
- [x] Hero image (new: index cards)
- [x] Introduction with hook
- [x] Motivations
- [x] Objectives
- [ ] Ambiance images (use placeholder-coffee-01/02/03)
- [ ] What is [Topic]? section
- [ ] Lessons Learnt (3 buckets)
- [ ] Limitations
- [ ] Opportunities for Improvement
- [ ] See Also
- [ ] Reproducibility (sessionInfo)
- [ ] Let's Connect

**Effort: medium** -- body content exists, needs structural sections added

#### Post 08 -- Palmer Penguins Part 1: EDA [draft:true]

- [x] YAML complete
- [x] Hero image (penguin, needs resize)
- [x] Introduction with hook
- [x] Motivations, Objectives
- [x] Analysis sections with figures
- [ ] Ambiance images
- [ ] Lessons Learnt (3 buckets)
- [ ] Limitations
- [ ] Opportunities for Improvement
- [ ] See Also
- [ ] Reproducibility
- [ ] Let's Connect

**Effort: medium** -- analysis is complete, needs tail sections

#### Posts 09-12 -- Palmer Penguins Parts 2-5 [draft:true]

Same gaps as post 08. These five form a series; refactor as a batch.

- [ ] All missing: Lessons Learnt, Limitations, Opportunities, See Also,
      Reproducibility, Let's Connect, ambiance images

**Effort: medium each, batch efficiently**

#### Post 13 -- Predictive Modeling of Penguin Body Mass [draft:false]

- [x] YAML complete
- [x] Hero image (penguin, needs resize)
- [x] Full template 39 structure present
- [ ] Ambiance images
- [ ] Verify Lessons Learnt has 3 buckets (Conceptual/Technical/Gotchas)

**Effort: low** -- mostly complete, add ambiance images

#### Post 14 -- Palmer Penguins Part 1 (zzcollab) [draft:false]

- [x] Full template 39 structure present
- [x] Hero image
- [ ] Ambiance images
- [ ] Verify 3-bucket Lessons Learnt

**Effort: low**

#### Post 15 -- The Pipe Equivalence Myth [draft:false]

- [x] YAML complete
- [x] Hero image (new: copper pipes)
- [x] Introduction, Motivations, Objectives
- [x] Deep technical analysis
- [ ] Ambiance images
- [ ] What is [Topic]? section
- [ ] Lessons Learnt (3 buckets)
- [ ] Limitations
- [ ] Opportunities
- [ ] See Also
- [ ] Reproducibility

**Effort: medium**

#### Post 16 -- Functional Plot Generation with purrr [draft:false]

- [x] YAML complete
- [x] Hero image (new: cat on charts)
- [x] Introduction, Motivations, Objectives
- [x] Analysis with code blocks
- [ ] Ambiance images
- [ ] Lessons Learnt (3 buckets)
- [ ] Limitations
- [ ] Opportunities
- [ ] See Also
- [ ] Reproducibility

**Effort: medium**

#### Post 19 -- Clinical Trial Data Validation [draft:false]

- [x] YAML complete
- [x] Hero image (new: lab notebook)
- [x] Introduction, Motivations, Objectives
- [x] Multi-language analysis
- [ ] Ambiance images
- [ ] Lessons Learnt (3 buckets)
- [ ] Limitations
- [ ] Opportunities
- [ ] See Also
- [ ] Reproducibility

**Effort: medium**

#### Post 43 -- Dynamic Column Names in R [draft:false]

- [x] YAML complete
- [x] Hero image (new: Rubik's cube)
- [x] Seven approaches compared with code
- [ ] Introduction hook ('I didn't know...')
- [ ] Motivations
- [ ] Objectives
- [ ] Ambiance images
- [ ] What is [Topic]?
- [ ] Lessons Learnt (3 buckets)
- [ ] Limitations
- [ ] Opportunities
- [ ] See Also
- [ ] Reproducibility

**Effort: high** -- has the analysis content but almost no template scaffolding

---

### Template 47 posts (setup/tooling)

#### Post 01 -- Configure the Command Line [draft:false]

- [x] YAML complete
- [x] Hero image (new: terminal on desk)
- [x] Introduction, Motivations, Objectives
- [x] Configuration sections
- [ ] Ambiance images
- [ ] What is [Tool]?
- [ ] Verification section
- [ ] Daily Workflow table
- [ ] Things to Watch Out For (5-7, REQUIRED)
- [ ] Uninstall / Rollback
- [ ] Lessons Learnt (3 buckets)
- [ ] Limitations
- [ ] Opportunities
- [ ] Reproducibility (version matrix)

**Effort: medium**

#### Post 02 -- Archiving 400 GitHub Repos Locally [draft:false]

- [x] YAML complete
- [ ] Hero image (still git logo, needs replacement)
- [x] Introduction, Motivations, Objectives
- [x] Bash scripting content
- [ ] Ambiance images
- [ ] Verification section
- [ ] Daily Workflow table
- [ ] Things to Watch Out For
- [ ] Uninstall / Rollback
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility (version matrix)

**Effort: medium**

#### Post 03 -- Install Linux Mint on a MacBook Air [draft:false]

- [x] YAML complete
- [ ] Hero image (still Linux Mint logo, needs replacement)
- [x] Introduction, Motivations, Objectives
- [x] Installation steps
- [ ] Ambiance images
- [ ] Configuration (complete files)
- [ ] Verification
- [ ] Things to Watch Out For
- [ ] Uninstall / Rollback
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility (version matrix)

**Effort: medium**

#### Post 05 -- The ls --since Utility [STUB, draft:true]

- [ ] Everything -- 11-line placeholder

**Effort: full write from scratch**

#### Post 06 -- From Markdown to Blog Post [draft:true]

- [ ] Hero image (missing)
- [x] Basic structure started
- [ ] Most template sections missing

**Effort: high**

#### Post 07 -- Multi-Language Quarto Documents [draft:false]

- [x] YAML complete
- [ ] Hero image (still Quarto logo, needs replacement)
- [x] Introduction, Motivations, Objectives
- [x] Configuration content
- [ ] Ambiance images
- [ ] Verification
- [ ] Daily Workflow table
- [ ] Things to Watch Out For
- [ ] Uninstall / Rollback
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility (version matrix)

**Effort: medium**

#### Post 17 -- Rapid Conversion R to Rmd [draft:false]

- [x] YAML complete
- [x] Hero image (new: two overlapping sheets)
- [x] Introduction, Motivations, Objectives
- [x] Workflow content
- [ ] Ambiance images
- [ ] Verification
- [ ] Things to Watch Out For
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility (version matrix)

**Effort: medium**

#### Post 18 -- Updating an R Package [draft:false]

- [x] YAML complete
- [x] Hero image (new: toolbox)
- [x] Introduction, Motivations, Objectives
- [x] Workflow content
- [ ] Ambiance images
- [ ] Verification
- [ ] Daily Workflow table
- [ ] Things to Watch Out For
- [ ] Uninstall / Rollback
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility (version matrix)

**Effort: medium**

#### Post 20 -- Research Backup System [draft:false]

- [x] YAML complete
- [x] Hero image (KEEP: isometric cloud illustration)
- [x] Introduction, Motivations, Objectives
- [x] Configuration sections
- [ ] Ambiance images
- [ ] Things to Watch Out For
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility (version matrix)

**Effort: low-medium**

#### Post 21 -- Research Management Workflow [draft:false]

- [x] YAML complete
- [x] Hero image (KEEP: home office photo)
- [x] Introduction, Motivations, Objectives
- [x] Workflow content
- [ ] Ambiance images
- [ ] Things to Watch Out For
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility (version matrix)

**Effort: low-medium**

#### Post 22 -- AWS CLI Setup [draft:false] [REFACTORED]

- [x] Fully conforms to template 47
- [x] Hero image (Imagen 3)
- [x] All required sections present

**Effort: done**

#### Post 23 -- AWS EC2 Console Setup [draft:false]

- [x] YAML complete
- [ ] Hero image (still AWS logo, needs replacement)
- [x] Introduction, Motivations, Objectives
- [x] Step-by-step console walkthrough
- [ ] Ambiance images
- [ ] What is [Tool]?
- [ ] Verification
- [ ] Daily Workflow table
- [ ] Things to Watch Out For
- [ ] Uninstall / Rollback
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility (version matrix)

**Effort: medium**

#### Post 24 -- GitHub Dotfiles Repository [draft:false]

- [x] YAML complete
- [x] Hero image (KEEP: developer at monitors)
- [x] Introduction, Motivations, Objectives
- [x] Configuration content
- [ ] Ambiance images
- [ ] Things to Watch Out For
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility (version matrix)

**Effort: low-medium**

#### Post 25 -- Setting Up Git [draft:false]

- [x] YAML complete
- [ ] Hero image (still git logo, needs replacement)
- [x] Introduction, Motivations, Objectives
- [x] Git configuration content
- [ ] Ambiance images
- [ ] Verification
- [ ] Daily Workflow table
- [ ] Things to Watch Out For
- [ ] Uninstall / Rollback
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility (version matrix)

**Effort: medium**

#### Post 26 -- Setting Up Neovim [draft:false]

- [x] YAML complete
- [ ] Hero image (still Vim logo, needs replacement)
- [x] Introduction, Motivations, Objectives
- [x] Full Lua configuration
- [ ] Ambiance images
- [ ] Verification
- [ ] Things to Watch Out For
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility (version matrix)

**Effort: medium**

#### Post 27 -- Setting Up OBS [STUB, draft:true]

- [ ] Everything -- minimal placeholder

**Effort: full write from scratch**

#### Post 28 -- Setting Up rrtools [draft:true]

- [x] Basic structure started
- [ ] Hero image (missing)
- [ ] Most template sections incomplete

**Effort: high**

#### Post 29 -- Reproducible Blog Posts with ZZCOLLAB [draft:false]

- [x] YAML complete
- [ ] Hero image (Quarto logo, needs replacement)
- [x] Introduction, Motivations, Objectives
- [x] Configuration content
- [ ] Ambiance images
- [ ] Things to Watch Out For
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility (version matrix)

**Effort: medium**

#### Post 30 -- R, Vimtex, UltiSnips in Vim [draft:true]

- [x] Structure started
- [ ] Hero image (missing)
- [ ] Things to Watch Out For
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility (version matrix)

**Effort: medium**

#### Post 31 -- Yabai Tiling Window Manager [draft:true]

- [x] Structure started with keybinding tables
- [ ] Hero image (missing)
- [ ] Things to Watch Out For
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility (version matrix)

**Effort: medium**

#### Post 32 -- Sharing R Markdown with Docker [draft:true]

- [x] Basic structure
- [ ] Hero image (missing)
- [ ] Complete configuration files
- [ ] Things to Watch Out For
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility

**Effort: medium-high**

#### Post 33 -- Sharing Shiny Apps with Docker [draft:true]

- [x] YAML complete
- [x] Hero image (KEEP: container ship)
- [x] Content present
- [ ] Ambiance images
- [ ] Things to Watch Out For
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility

**Effort: medium**

#### Post 34 -- Observable JS and Shiny [draft:true]

- [x] Basic structure
- [ ] Hero image (missing)
- [ ] Things to Watch Out For
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility

**Effort: medium**

#### Post 35 -- S3 Methods R Package [draft:true]

- [x] YAML complete
- [x] Hero image (new: matryoshka dolls)
- [x] Template structure with placeholders
- [ ] Fill in all placeholder content
- [ ] Things to Watch Out For
- [ ] Reproducibility

**Effort: medium** -- scaffolding exists, needs content

#### Post 36 -- Shiny App with ChatGPT [draft:true]

- [x] Basic structure
- [ ] Hero image (missing)
- [ ] Most sections incomplete

**Effort: high**

#### Post 37 -- Vim Plugin for REPL [draft:true]

- [x] Basic structure
- [ ] Hero image (missing)
- [ ] Complete plugin code
- [ ] Things to Watch Out For
- [ ] Lessons Learnt

**Effort: high**

#### Post 38 -- Table Placement in R Markdown [draft:true]

- [x] YAML complete
- [x] Hero image (new: letterpress)
- [x] Template structure with placeholders
- [ ] Fill in placeholder content
- [ ] Things to Watch Out For
- [ ] Reproducibility

**Effort: medium**

#### Post 40 -- Testing Data Analysis Workflows [draft:true]

- [x] YAML complete
- [x] Hero image (new: test tubes)
- [x] Substantial content
- [ ] Ambiance images
- [ ] Things to Watch Out For
- [ ] Lessons Learnt (3 buckets)
- [ ] Reproducibility (version matrix)

**Effort: medium**

#### Post 41 -- Python in UltiSnips [draft:true]

- [x] YAML complete
- [ ] Hero image (still Python logo, needs replacement)
- [x] Template structure with placeholders
- [ ] Fill in placeholder content
- [ ] Things to Watch Out For
- [ ] Reproducibility

**Effort: medium**

#### Post 42 -- ZZedc Independent [draft:true]

- [x] Basic structure
- [ ] Hero image (missing)
- [ ] Most sections incomplete

**Effort: high**

#### Post 48 -- ttyd Pocket Terminal [draft:true]

- [x] Structure started
- [ ] Hero image (missing)
- [ ] Things to Watch Out For
- [ ] Lessons Learnt
- [ ] Reproducibility

**Effort: medium**

---

## Priority order

### Tier 1: Published posts missing structural sections (fix first)

These are draft:false but do not conform to their template. Readers see
them now. Ordered by gap size (smallest first):

1. **13** (39-analysis) -- low effort, nearly complete
2. **14** (39-analysis) -- low effort, nearly complete
3. **20** (47-setup) -- low-medium, add tail sections
4. **21** (47-setup) -- low-medium, add tail sections
5. **24** (47-setup) -- low-medium, add tail sections
6. **01** (47-setup) -- medium, add 5+ sections
7. **04** (39-analysis) -- medium, add 5+ sections
8. **15** (39-analysis) -- medium, add 5+ sections
9. **16** (39-analysis) -- medium, add 5+ sections
10. **19** (39-analysis) -- medium, add 5+ sections
11. **43** (39-analysis) -- high, needs full scaffolding
12. **02** (47-setup) -- medium, hero still logo
13. **03** (47-setup) -- medium, hero still logo
14. **07** (47-setup) -- medium, hero still logo
15. **17** (47-setup) -- medium
16. **18** (47-setup) -- medium
17. **23** (47-setup) -- medium, hero still logo
18. **25** (47-setup) -- medium, hero still logo
19. **26** (47-setup) -- medium, hero still logo
20. **29** (47-setup) -- medium, hero still logo

### Tier 2: Draft posts with substantial content (complete and publish)

These have real content but need template sections added before publishing:

21. **08-12** (39-analysis) -- penguin series, batch refactor
22. **33** (47-setup) -- Docker Shiny, mostly there
23. **35** (47-setup) -- S3 methods, scaffold exists
24. **38** (47-setup) -- table placement, scaffold exists
25. **40** (47-setup) -- testing workflows, substantial
26. **48** (47-setup) -- ttyd, structure started
27. **30** (47-setup) -- Vim/R/LaTeX
28. **31** (47-setup) -- Yabai
29. **34** (47-setup) -- Observable + Shiny
30. **41** (47-setup) -- UltiSnips Python

### Tier 3: Draft posts needing heavy writing

31. **28** (47-setup) -- rrtools, incomplete
32. **32** (47-setup) -- Docker R Markdown, incomplete
33. **36** (47-setup) -- Shiny + ChatGPT, incomplete
34. **37** (47-setup) -- Vim REPL plugin, incomplete
35. **42** (47-setup) -- ZZedc, incomplete
36. **06** (47-setup) -- Markdown to blog, incomplete

### Tier 4: Stubs (write from scratch or delete)

37. **05** (47-setup) -- ls --since, 11-line placeholder
38. **27** (47-setup) -- OBS, minimal placeholder

---

## Common missing sections across all posts

The most frequently missing sections (add these to every post):

| Section | Missing from | Template |
|---------|-------------|----------|
| Ambiance images (3x coffee placeholders) | ~40 posts | Both |
| Lessons Learnt (3 buckets) | ~35 posts | Both |
| Things to Watch Out For (5-7 gotchas) | ~30 posts | 47 |
| Reproducibility | ~30 posts | Both |
| Let's Connect | ~25 posts | Both |
| Limitations | ~25 posts | Both |
| Opportunities for Improvement | ~25 posts | Both |
| See Also | ~20 posts | Both |
| Daily Workflow table | ~20 posts | 47 |
| Verification section | ~18 posts | 47 |
| Uninstall / Rollback | ~18 posts | 47 |

---

## Hero images still needing generation

See HERO_IMAGE_PROMPTS.md for Gemini prompts. Remaining:

- Batch 3 (setup): 02, 03, 05, 07, 23, 25, 26, 27, 28, 29, 30, 31, 37, 41, 48
- Batch 4 (Docker/repro): 06, 32, 34, 36, 39, 42
