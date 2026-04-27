---
title: 'qblog Workflow Refactor Plan'
subtitle: 'Aligning the workflow posts with the layered Reference Architecture introduced in post 52'
author: "Ronald 'Ryy' G. Thomas"
date: '2026-04-27'
geometry: margin=1in
mainfont: DejaVu Serif
monofont: DejaVu Sans Mono
fontsize: 11pt
toc: true
toc-depth: 2
numbersections: true
colorlinks: true
---

# qblog Workflow Refactor Plan
*2026-04-27 10:06 PDT*

This document is the consolidated refactoring plan for the
workflow-oriented posts in `~/Dropbox/prj/qblog/posts/`. It
reconciles two previous planning artefacts (the `Template
Conformance Plan` of 2026-04-19 and the framework plan produced
by the planning agent on 2026-04-27) and adds explicit
justifications for each major decision. The intended audience is
the qblog author working through the refactor, plus any future
collaborator who needs to understand why specific posts were
merged, archived, or newly authored.

# 1. Executive Summary

Post 52 (`A Workflow Construct for the Modern Data Scientist`)
introduced an explicit theoretical framing: the workflow construct
is a layered Reference Architecture for a single-user research
workstation, instantiated as ad hoc Infrastructure as Code, with
the project tier following the Reproducible Research Compendium
pattern. The 48 existing posts predate this framing and are
authored as standalone tutorials. The refactor's purpose is to
make the corpus read as a coherent curriculum that an applied
biostatistician can follow as the layered construction of a
working research environment.

The plan calls for re-framing 18 existing posts to declare the
construct layer they instantiate; merging 4 redundant pairs;
archiving 3 stubs or off-construct posts; authoring 8 new posts
to fill genuine coverage gaps surfaced by the framework lens;
and ordering the resulting 30-post workflow corpus into four
tiers (Workstation IaC, Project Compendium, Team / Cloud, and
Knowledge / LLM) plus a parallel applied-analysis track of 12
data-analytic posts. Post 52 sits as the spine that all four
tiers reference.

Of the six cases where the new framework plan and the existing
template conformance plan disagree, the framework plan should
win in every case, because the conformance plan predates post
52's framing and reflexively treats every post as worth
completing. The plan is sequenced in seven phases, beginning
with the cheapest editorial work (intro re-frames) and
concluding with the most expensive (image generation), so
visible coherence is achieved before structural completeness.

# 2. Theoretical Framework Recap

The plan presupposes the framing established in post 52. Briefly,
the workflow construct is a special case of five recognised
software-engineering frameworks:

1. **Reference Architecture (layered / n-tier)**: documented
   blueprint that prescribes the layers and permitted couplings
   of a system without prescribing the implementing tools (Bass,
   Clements, and Kazman 2021; Buschmann et al. 1996; ISO/IEC/IEEE
   42010).
2. **Infrastructure as Code (IaC)**, applied at the workstation
   level: dotfiles, Dockerfile, and `renv.lock` as versioned
   declarative artefacts (Morris 2020; emerging term
   'Development Environment as Code').
3. **Reproducible Research Compendium**, project tier: data,
   code, and dependency manifest bundled (Gentleman and Temple
   Lang 2007; Marwick, Boettiger, and Mullen 2018; zzcollab as
   the operational implementation).
4. **Internal Developer Platform / Golden Path**, team tier:
   opinionated, supported, paved-road conventions (Spotify
   Backstage; CNCF Platform Working Group 2022 onward).
5. **Dev Container specification + SBOM**: schema-validated,
   portable subsets (containers.dev; SPDX; CycloneDX).

The construct names thirteen layers (Hardware, Operating system,
File system, Shell, Editor, Vim plugins, zsh functions, Shell
scripts, zsh aliases, Applications, Cloud, Backup, R packages)
plus extension families documented in post 52's recommendations
section: modern CLI replacements, secret scanning and SBOM,
LLM-augmented editing, polyglot version management, Quarto as
document layer, devcontainer + Apptainer, secrets management,
remote access, knowledge management, and modern data tooling.

The refactor aims to ensure that every workflow post in the
corpus declares which layer or extension family it instantiates,
and that every layer of practical value to an applied
biostatistician has at least one post.

# 3. Inventory

The 48 posts split into 12 data-analytic (template-39 form) and
36 workflow-construct (template-47 form) posts, plus the two
templates themselves. The split is principled: data-analytic
posts illustrate HOW to do an analysis using the construct
(applied tutorials), whereas workflow-construct posts are the
construct itself (its layers, conventions, and tooling). Only
the workflow-construct posts need framework alignment; the
data-analytic posts remain template-39 conformant and form a
parallel track.

| #  | Title (short)                        | Type    | Layer / Tier                  | Action            |
|----|--------------------------------------|---------|-------------------------------|-------------------|
| 01 | Configure the Command Line (zsh)     | WC-47   | Shell                         | re-frame          |
| 02 | Archiving 400 GitHub Repos Locally   | WC-47   | Backup / FS                   | re-frame          |
| 03 | Install Linux Mint on a MacBook Air  | WC-47   | Hardware + OS                 | re-frame          |
| 04 | Lowercasing Dataframe Names          | DA-39   | (R idiom)                     | keep-as-is        |
| 05 | The `ls --since` Utility             | WC-47   | (would be Shell scripts)      | archive           |
| 06 | From Markdown to Blog Post           | WC-47   | Project compendium            | merge into 29     |
| 07 | Multi-Language Quarto Documents      | WC-47   | Document layer (Quarto)       | re-frame          |
| 08 | Palmer Penguins Part 1: EDA          | DA-39   | (analysis)                    | keep-as-is        |
| 09 | Palmer Penguins Part 2: Regression   | DA-39   | (analysis)                    | keep-as-is        |
| 10 | Palmer Penguins Part 3: Cross-Val    | DA-39   | (analysis)                    | keep-as-is        |
| 11 | Palmer Penguins Part 4: Diagnostics  | DA-39   | (analysis)                    | keep-as-is        |
| 12 | Palmer Penguins Part 5: Random Forest| DA-39   | (analysis)                    | keep-as-is        |
| 13 | Penguin Body Mass Regression         | DA-39   | (analysis)                    | keep-as-is        |
| 14 | Penguins via zzcollab                | DA-39   | (analysis + compendium bridge)| re-frame intro    |
| 15 | The Pipe Equivalence Myth            | DA-39   | (R idiom)                     | keep-as-is        |
| 16 | Functional Plot Generation (purrr)   | DA-39   | (R idiom)                     | keep-as-is        |
| 17 | Rapid R-to-Rmd Conversion            | WC-47   | Document layer                | re-frame          |
| 18 | Updating an R Package                | WC-47   | R packages layer              | re-frame          |
| 19 | Clinical Trial Data Validation       | DA-39   | (analysis: regulatory)        | keep-as-is        |
| 20 | Research Backup System               | WC-47   | Backup                        | re-frame          |
| 21 | Research Management Workflow         | WC-47   | File system                   | re-frame          |
| 22 | AWS CLI Setup                        | WC-47   | Cloud (CLI)                   | keep-as-is        |
| 23 | AWS EC2 Console Setup                | WC-47   | Cloud (GUI)                   | re-frame          |
| 24 | GitHub Dotfiles Repository           | WC-47   | IaC (workstation keystone)    | re-frame          |
| 25 | Setting Up Git                       | WC-47   | Version control (cross-cut)   | re-frame          |
| 26 | Setting Up Neovim                    | WC-47   | Editor                        | re-frame          |
| 27 | Setting Up OBS                       | WC-47   | (off-construct)               | archive           |
| 28 | Setting Up rrtools                   | WC-47   | Project compendium            | merge into 29     |
| 29 | Reproducible Blog Posts via zzcollab | WC-47   | Project compendium (keystone) | re-frame, expand  |
| 30 | R, Vimtex, UltiSnips in Vim          | WC-47   | Vim plugins                   | re-frame          |
| 31 | Yabai Tiling Window Manager          | WC-47   | Applications (optional)       | re-frame          |
| 32 | Sharing Rmd via Docker               | WC-47   | Container layer               | merge with 33     |
| 33 | Sharing Shiny via Docker             | WC-47   | Container layer               | merge with 32     |
| 34 | Observable JS vs Shiny               | HYBRID  | Document / Apps               | re-frame as essay |
| 35 | Simple S3 R Package                  | WC-47   | R packages                    | re-frame          |
| 36 | Shiny App with ChatGPT               | HYBRID  | LLM-aug (dated)               | archive           |
| 37 | Simple Vim Plugin                    | WC-47   | Vim plugins                   | re-frame          |
| 38 | Table Placement in R Markdown        | WC-47   | Document layer                | keep-as-is        |
| 39 | Template (data analysis)             | template| --                            | keep-as-is        |
| 40 | Testing Data Analysis Workflows      | WC-47   | Project compendium / testing  | re-frame          |
| 41 | UltiSnips Python                     | WC-47   | Vim plugins                   | re-frame          |
| 42 | ZZedc Independent                    | WC-47   | Cloud + Apps                  | re-frame          |
| 43 | Dynamic Column Names in R            | DA-39   | (R idiom)                     | keep-as-is        |
| 47 | Template (setup)                     | template| --                            | keep-as-is        |
| 48 | ttyd Pocket Terminal                 | WC-47   | Remote access                 | re-frame          |
| 49 | zzgit                                | WC-47   | Shell scripts + secret scan   | keep-as-is        |
| 50 | Textbook Development (AI)            | WC-47   | Knowledge mgmt + LLM-aug      | re-frame          |
| 51 | Scripts vs Shell Functions           | WC-47   | zsh functions / shell scripts | keep-as-is        |
| 52 | Workflow Construct                   | WC-47   | Spine (theoretical)           | keep-as-is        |

Action verb glossary: `keep-as-is` means no framework changes
needed; `re-frame` means insert a layer-declaration paragraph
into the introduction; `merge` means absorb into another post
with a See Also pointer; `archive` means move to `_archive/`
with content lifted into another post where applicable.

# 4. Coverage Analysis

The framework lens reveals which layers and extension families
are well-covered, over-covered (redundant), thin, or missing
entirely.

| Layer / Family                                     | Status          | Posts                            |
|----------------------------------------------------|-----------------|----------------------------------|
| Hardware                                           | THIN            | 03                               |
| Operating system                                   | WELL_COVERED    | 03                               |
| File system (`~/prj`, Dropbox, Git)                | WELL_COVERED    | 20, 21, 24                       |
| Shell (zsh)                                        | WELL_COVERED    | 01, 51                           |
| Editor (Vim / Neovim)                              | OVER_COVERED    | 26, 30, 37 (37 redundant w/ 30)  |
| Vim plugins                                        | WELL_COVERED    | 30, 37, 41                       |
| zsh functions                                      | WELL_COVERED    | 51                               |
| Shell scripts                                      | WELL_COVERED    | 02, 05, 49, 51 (05 redundant)    |
| zsh aliases                                        | THIN            | 01 (only)                        |
| Applications (gh, R, RStudio, Docker)              | OVER_COVERED    | 14, 28, 31, 32, 33               |
| Cloud                                              | WELL_COVERED    | 22, 23, 42                       |
| Backup                                             | WELL_COVERED    | 20                               |
| R packages (`zz*` family)                          | WELL_COVERED    | 18, 35                           |
| Modern CLI (rg/fd/bat/eza/zoxide/delta/lazygit)    | MISSING         | none                             |
| Secret scanning + SBOM                             | THIN            | 49 (scanning only; no SBOM)      |
| Polyglot version mgmt (mise / uv)                  | MISSING         | none                             |
| Knowledge management (Zotero / Obsidian / Pandoc)  | MISSING         | 50 (textbook angle only)         |
| LLM-augmented editing (Claude Code, in-buffer)     | THIN            | 36 (dated), 50 (peripheral)      |
| devcontainer.json + Apptainer                      | MISSING         | none                             |
| Secrets management (AWS SSO + 1Password CLI)       | MISSING         | none                             |
| Remote access (Tailscale + mosh)                   | THIN            | 48 (ttyd only)                   |
| Modern data tooling (DuckDB / Arrow / Polars)      | MISSING         | none                             |
| Project compendium (zzcollab)                      | OVER_COVERED    | 14, 17, 28, 29, 40 (overlap)     |
| Document layer (Quarto)                            | WELL_COVERED    | 07, 17, 29, 38                   |

The over-covered cells are the merge targets in section 5. The
missing cells are the new post candidates in section 6. The
thin cells indicate either a single existing post that should
remain (Hardware, zsh aliases) or a layer where new authoring
will substantively change coverage (LLM-augmented editing,
Remote access).

# 5. Per-Post Actions with Justifications

The 36 workflow posts plus the 12 data-analytic posts decompose
into four action classes. Each class is justified below.

## 5.1 Re-frame intro only (18 posts)

**Action.** Insert a two- to four-sentence paragraph into the
introduction declaring which construct layer or tier the post
instantiates, and cross-linking to post 52 as the spine.

**Posts.** 01, 02, 03, 07, 14 (intro only), 17, 18, 20, 21, 23,
24, 25, 26, 30, 31, 35, 37, 40, 41, 42, 48, 50.

**Justification.** Without explicit layer declarations, each
post in the corpus reads as a tutorial in isolation. With a
layer declaration, each post reads as the technical realization
of a specific layer of the construct, and the corpus reads as a
curriculum. The intro paragraph is cheap (minutes per post) and
fully reversible. It does not require structural rewriting.

**Implementation note.** This work can be combined in a single
editorial pass with the structural-conformance work catalogued
in `TEMPLATE_CONFORMANCE_PLAN.md` (adding the missing Lessons
Learnt, version matrix, etc., as that plan prescribes).
Combining the two avoids redundant editing passes.

## 5.2 Merge (4 cases)

### 5.2.1 Post 06 → Post 29

**Action.** Absorb the (incomplete) Markdown-to-blog post 06
into the (canonical) zzcollab compendium-tier post 29.

**Justification.** Both posts cover the project compendium tier
of the construct: 06 from the angle of Markdown-to-blog
conversion, 29 from the angle of zzcollab-driven blog post
authoring. Two near-identical posts on the same tier obscure
the layer rather than documenting it. Post 29 has the more
canonical framing and a more complete body; post 06 is a Tier-3
draft per `TEMPLATE_CONFORMANCE_PLAN.md`. Investing in
completing 06 produces no marginal information that a reader
of 29 would not already have. Absorbing 06 into 29 produces a
single keystone post for the tier.

### 5.2.2 Post 28 → Post 29 (with rrtools history as appendix)

**Action.** Discontinue the (incomplete) standalone rrtools
post 28 and incorporate the rrtools history as a 'predecessors'
appendix in post 29.

**Justification.** rrtools is the historical predecessor of
zzcollab. A standalone post on an incomplete predecessor is an
exercise in archaeology that adds historical context but does
not advance the curriculum. Preserving the rrtools history as
an appendix in 29 maintains historical fidelity (the reader
sees what zzcollab supersedes and why) without inflating the
corpus with a separately-maintained post.

### 5.2.3 Post 32 + Post 33 → Single Container-Layer Post

**Action.** Merge the Docker-Rmd post 32 and the Docker-Shiny
post 33 into a single canonical container-layer post.

**Justification.** Both posts describe the container layer of
the construct, with worked examples that differ only in payload
(Rmd document vs. Shiny app). Two near-identical templates
obscure the layer (which is what the construct is documenting)
in favour of the worked example (which is incidental). Merging
clarifies that the layer is the abstraction and the payloads
are case studies of it.

**Mitigation.** The agent's plan flags an inbound-link risk:
readers searching for 'Shiny via Docker' expect a distinct
landing page. Mitigate by either (a) preserving post 33 as a
Shiny-specific case study with a clear 'see post 32 for the
container-layer fundamentals' header, or (b) maintaining a
permanent redirect from post 33's URL to post 32. Option (b) is
cleaner; option (a) preserves the Shiny-specific content as
documentation.

### 5.2.4 Post 05 → Post 51's Daily Workflow Table

**Action.** Archive the standalone `ls --since` post 05 and add
a row for `lssince` to post 51's Daily Workflow command table.

**Justification.** Post 05 is an 11-line stub. The `lssince`
script is already documented operationally in posts 49 and 51
(both discuss the script alongside other shell-tooling).
Investing in writing 05 from scratch (the conformance plan's
recommendation) produces a standalone post that duplicates 49
and 51 without adding new content. The script is small; a
table row in 51 is the appropriate level of documentation.

## 5.3 Archive (3 cases)

### 5.3.1 Post 27 (Setting Up OBS)

**Justification.** OBS Studio is screen-recording software. The
construct as defined in post 52 has no layer for screen
recording: it is not a research-workflow primitive but rather a
content-creation tool that some authors use and others do not.
Investing in completing a Tier-4 stub (per the conformance
plan) for an off-construct topic is a misallocation; the post
reads as 'I happened to set up OBS once' rather than as a
construct-tier artefact.

### 5.3.2 Post 36 (Shiny App with ChatGPT)

**Justification.** The post is dated (2023-vintage ChatGPT API
era) and describes a worked example that is no longer
representative of the LLM-augmented workflow in 2026 (where
Claude Code at the shell, Cursor, and aider are the dominant
modes, and the OpenAI API is one of several alternatives). The
unique content worth preserving is the working chat-completion
code; that code can be lifted into the new post 60
(LLM-augmented editing) as an appendix illustrating one historical
integration pattern. The standalone post would otherwise become
a date-stamped curiosity.

### 5.3.3 Post 05 (`ls --since`)

See section 5.2.4 above. Archive after content is absorbed into
post 51.

## 5.4 Keep-as-is (data-analytic + finished workflow posts)

**Posts.** All 12 data-analytic posts (04, 08-13, 14 body, 15,
16, 19, 43); workflow posts 22 (already template-conformant),
49 (already framework-aligned), 51 (already framework-aligned),
38 (idiom post), 39 and 47 (templates), and 52 (the spine).

**Justification.** The data-analytic posts illustrate how to do
an analysis in R (regression, EDA, validation, idioms). They
are not construct-tier posts; they are tutorials. Forcing
framework alignment on them would distort their pedagogical
purpose. The construct-tier posts already framework-aligned
(22, 49, 51, 52) need no further work.

# 6. Proposed New Posts (8)

Each new post fills a coverage gap identified in section 4. The
proposals are listed in the order they should be authored, with
precursor relationships noted. The bar for proposing a new post
is high: each must address a layer or extension family that
post 52 explicitly recognises and that has no current coverage.

## 6.1 Post 53: Modern CLI Replacements

**Layer.** Shell-layer extension.

**Scope.** A single post covering `ripgrep`, `fd`, `bat`, `eza`,
`zoxide`, `delta`, and `lazygit` as drop-in replacements for
`grep`, `find`, `cat`, `ls`, `cd`, `git diff`, and the `git`
porcelain respectively. Includes the autojump-to-zoxide
migration note (the `j` muscle-memory preserved with
`zoxide init zsh --cmd j`).

**Justification.** Post 52's recommendation section grades these
as 'strong'. They are mature, well-adopted, and substantially
better than the historical Unix tools on the metrics that matter
to a working biostatistician (speed on large directory trees,
respect for `.gitignore`). The corpus has no current post on
them; without one, post 52's recommendation has no companion
walkthrough.

**Precursor relationship.** Pairs with post 01 (the zsh setup
post). Post 01's re-frame should reference 53 once it exists.

## 6.2 Post 54: Polyglot Language Management with mise and uv

**Layer.** New layer between Shell and Applications.

**Scope.** `mise` for cross-language version management (R,
Python, Node) plus `uv` as the Rust-implemented Python toolchain
that subsumes `pip`, `virtualenv`, `pyenv`, and `pip-tools`.

**Justification.** Post 52 lists this as a 'conditional'
recommendation, which becomes 'strong' as soon as Python enters
the workflow (which it does for any biostatistician working with
machine-learning collaborators or modern data tooling).
Per-project version pinning is the layer that closes the 'works
on my machine' gap that `renv.lock` alone cannot.

## 6.3 Post 55: Secrets Management (AWS IAM Identity Center + 1Password CLI)

**Layer.** Cloud-adjacent.

**Scope.** AWS IAM Identity Center (formerly SSO) for short-lived
AWS credentials replacing plaintext `~/.aws/credentials`. The
`1Password CLI` (`op`) for non-AWS API keys (Anthropic, OpenAI,
Zotero) injected at process-start time.

**Justification.** Post 52 grades this 'strong if cloud is used'.
The current cloud posts 22 and 23 predate IAM Identity Center
and document the legacy IAM-user credentials path. Re-framing
22 and 23 cannot honestly recommend the contemporary credentials
path until post 55 exists. **Post 55 is therefore a precursor
to substantial revisions of 22 and 23, and should be authored
before those revisions are scheduled.**

## 6.4 Post 56: Remote Access (Tailscale + mosh)

**Layer.** Cross-machine extension.

**Scope.** Tailscale (WireGuard mesh VPN) for stable hostnames
across machines regardless of network topology. `mosh` for
SSH over high-latency or intermittent links.

**Justification.** Post 52 grades this 'conditional'. The current
remote-access coverage is post 48 (ttyd), which is one specific
solution to the browser-shell case. A post on Tailscale + mosh
addresses the broader cross-machine-access case and pairs with
48 to form a complete remote-access subsection.

## 6.5 Post 57: Knowledge Management (Zotero + Obsidian + Pandoc)

**Layer.** Optional Tier D (knowledge / research-side companion).

**Scope.** Zotero for reference management plus the Zotero MCP
server for programmatic access from an LLM context; Obsidian or
Logseq for plain-text notes with bidirectional links; Pandoc as
the universal document converter.

**Justification.** Post 52 grades this 'optional', but the
applied-biostatistician persona spends substantial time reading
papers, taking notes, and citing references. The MCP angle
(post 57 is the only place the construct meets the LLM context
on the research-input side) makes this load-bearing for any
biostatistician using LLMs in their research workflow.

## 6.6 Post 58: devcontainer.json + Apptainer

**Layer.** Container-layer extension.

**Scope.** `devcontainer.json` for portable container definitions
across IDEs, GitHub Codespaces, and CI runners. Apptainer
(formerly Singularity) for HPC clusters that disallow Docker.

**Justification.** Post 52 grades this 'conditional', but for
a biostatistician collaborating with an HPC-using lab or with a
VS Code-using collaborator, the alternative is producing a
non-portable Dockerfile. The post documents the formal
counterpart to the construct's ad hoc container layer.

## 6.7 Post 59: Modern Data Tooling (DuckDB + Arrow + Polars)

**Layer.** Data-handling extension.

**Scope.** DuckDB as the embedded analytical database; Apache
Arrow / Parquet as the columnar interchange format; Polars as
the Rust-implemented DataFrame library.

**Justification.** Post 52 grades this 'conditional' for clinical
trial-scale data and 'matters' for cohort or registry data. The
applied biostatistician working with electronic-health-record
extracts, claims data, or registry data routinely encounters
data sizes where in-memory R approaches struggle. This post
addresses that scaling problem at the data-tooling layer
without requiring a move to cluster computing.

## 6.8 Post 60: LLM-Augmented Editing (Claude Code at the Shell)

**Layer.** LLM-augmented-editing extension.

**Scope.** Claude Code at the shell (`claude` invoked from
`~/prj` with project-specific `CLAUDE.md`); brief comparison
with Cursor, Zed, and `aider`; in-Neovim plugins
(`codecompanion.nvim`, `avante.nvim`) for inline diffs. Includes
the working ChatGPT chat-completion code lifted from post 36 as
a historical-pattern appendix.

**Justification.** Post 52 grades the in-editor LLM assistant
'conditional' but the out-of-editor research assistant
'unambiguously useful'. Post 36 is dated; the corpus has no
current post on the contemporary integration patterns. Post 60
replaces 36, preserves its unique content, and aligns with the
framework's recommendation.

# 7. Reconciliation with TEMPLATE_CONFORMANCE_PLAN.md

The previous template conformance plan (`TCP`, dated
2026-04-19) and the framework plan in this document (`NRP`) are
largely complementary. TCP addresses structural template
conformance (does each post have a Lessons Learnt, a version
matrix, a Daily Workflow table). NRP addresses framework
alignment (does each post declare which construct layer it
instantiates). For 39 of the 45 reviewable posts, the
recommendations are orthogonal and can be executed in a single
editorial pass.

## 7.1 The Six Conflict Cases

For six posts, TCP and NRP recommend incompatible actions. In
every case, NRP's recommendation should win, because TCP
predates the post-52 framing and reflexively treats every post
as worth completing. The framework lens reveals which posts are
worth completing and which are subsumed by the framework's
restructuring.

| #     | TCP recommendation                | NRP recommendation                       | Resolution      |
|-------|-----------------------------------|------------------------------------------|-----------------|
| 05    | Tier 4: write from scratch        | Archive; absorb into post 51             | NRP             |
| 06    | Tier 3: high-effort completion    | Merge into 29                            | NRP             |
| 27    | Tier 4: write from scratch        | Archive (off-construct)                  | NRP             |
| 28    | Tier 3: high-effort completion    | Merge into 29 (rrtools as appendix)      | NRP             |
| 36    | Tier 3: high-effort completion    | Archive after lifting code into 60       | NRP             |
| 32+33 | Tier 2/3: complete each separately| Merge into single container-layer post   | NRP w/ mitigation|

The mitigation for the 32+33 case is documented in section
5.2.3.

## 7.2 What NRP Adds That TCP Does Not Contemplate

The eight new posts (53-60) listed in section 6. TCP cannot
contemplate these because it predates post 52's framing.

NRP also adds posts 49, 50, 51, 52 to its inventory; TCP predates
all four.

## 7.3 What TCP Catches That NRP Under-Weights

**Hero-image generation pipeline.** TCP cross-references
`HERO_IMAGE_PROMPTS.md` and tracks per-post status (DONE / KEEP
/ RESIZE / TODO). NRP does not address ongoing image generation.
The two are orthogonal: framework alignment can proceed on
placeholder heroes, and image generation can proceed
independently. Recommendation: keep TCP's image-tracking
discipline; do not let framework work delay or replace it.

**Common-missing-sections inventory.** TCP's table at the bottom
(40 posts missing ambiance images, 35 missing Lessons Learnt)
is a useful global view that NRP does not produce. For batch
work, this is the better lens: a single sweep that adds
Lessons Learnt to 35 posts is more efficient than 35 individual
editorial passes.

**Effort estimates.** TCP gives per-post effort ratings (low /
medium / high). NRP gives action verbs but no effort ratings.
For sequencing, TCP's ratings should drive the within-tier
order; NRP's tier classification (workstation IaC / project
compendium / team) should drive the across-tier order.

# 8. Proposed Reading Order (Curriculum)

The 30-post workflow corpus, after merges and archivals, plus
the eight new posts, organises into four tiers. Post 52 sits as
the spine that all four tiers reference. The 12 data-analytic
posts form a parallel applied-analysis track.

## 8.1 Tier A: Workstation IaC (single-laptop layers)

| Order | Post(s)             | Layer                                  |
|-------|---------------------|----------------------------------------|
| A1    | 03                  | Hardware + OS                          |
| A2    | 21                  | File system convention (`~/prj`)       |
| A3    | 20                  | Backup                                 |
| A4    | 24                  | Dotfiles (the IaC keystone)            |
| A5    | 25                  | Git (cross-cutting prerequisite)       |
| A6    | 01                  | Shell (zsh)                            |
| A7    | 53 (new)            | Modern CLI replacements                |
| A8    | 51                  | Scripts vs. functions                  |
| A9    | 49                  | zzgit (secret scanning at staging)     |
| A10   | 26                  | Editor (Neovim)                        |
| A11   | 30                  | Vim + R + vimtex                       |
| A12   | 37                  | Vim plugin authoring                   |
| A13   | 41                  | UltiSnips                              |
| A14   | 54 (new)            | Polyglot version managers              |
| A15   | 18                  | R package maintenance                  |
| A16   | 35                  | S3 R package authoring                 |
| A17   | 31                  | Yabai (optional)                       |

## 8.2 Tier B: Project Compendium

| Order | Post(s)             | Layer                                  |
|-------|---------------------|----------------------------------------|
| B1    | 29 (absorbing 06+28)| zzcollab compendium (keystone)         |
| B2    | 17                  | R-script-to-Rmd promotion              |
| B3    | 07                  | Multi-language Quarto                  |
| B4    | 38                  | Table placement in Rmd                 |
| B5    | 40                  | Testing data analysis workflows        |
| B6    | 58 (new)            | devcontainer.json + Apptainer          |

## 8.3 Tier C: Team / Cloud / Multi-machine

| Order | Post(s)             | Layer                                  |
|-------|---------------------|----------------------------------------|
| C1    | 22                  | AWS CLI                                |
| C2    | 23                  | AWS console                            |
| C3    | 55 (new)            | AWS SSO + 1Password                    |
| C4    | 32 (merged with 33) | Sharing analyses via Docker            |
| C5    | 42                  | ZZedc on EC2                           |
| C6    | 48                  | ttyd                                   |
| C7    | 56 (new)            | Tailscale + mosh                       |
| C8    | 02                  | GitHub mirror (backup tier)            |

## 8.4 Tier D: Knowledge / LLM (cross-cutting, optional)

| Order | Post(s)             | Layer                                  |
|-------|---------------------|----------------------------------------|
| D1    | 57 (new)            | Zotero + Obsidian + Pandoc             |
| D2    | 60 (new)            | LLM-augmented editing                  |
| D3    | 50                  | Textbook development in age of AI      |

## 8.5 Parallel Track: Applied Analysis

| Order | Post(s)             | Notes                                  |
|-------|---------------------|----------------------------------------|
| P1    | 14                  | Bridge: penguins via zzcollab          |
| P2    | 08-12               | Penguin EDA + modelling series         |
| P3    | 13                  | Penguin regression                     |
| P4    | 04                  | Lowercasing names (idiom)              |
| P5    | 15                  | Pipe equivalence (idiom)               |
| P6    | 16                  | purrr plotting (idiom)                 |
| P7    | 43                  | Dynamic column names (idiom)           |
| P8    | 19                  | Clinical trial validation (regulatory) |
| P9    | 59 (new)            | Modern data tooling (registry-scale)   |
| P10   | 34                  | Observable vs. Shiny (decision aid)    |

**Justification for tier order.** Tier A is the foundation: the
laptop is built layer by layer from hardware up to language
toolchain. Tier B builds the project-level compendium on top of
the laptop. Tier C extends to cross-machine settings. Tier D is
cross-cutting and optional. The parallel applied-analysis track
illustrates how to use the construct without being part of its
construction.

# 9. Recommended Execution Sequence (Seven Phases)

The phases are ordered to minimise rework and to respect
precursor relationships. The cheapest, most impact-per-hour
work comes first; the most expensive (image generation) comes
last.

## 9.1 Phase 1: Cheap Re-frames (days of work)

Re-frame the 18 Tier-1 posts NRP flags. For each: insert the
layer-declaration paragraph after the introduction; add any
TCP-required tail sections that are easy (See Also, Let's
Connect / Feedback, Limitations). Do not yet generate version
matrices, hero images, or ambiance images.

**Goal.** The corpus is readable as a coherent series even with
structural gaps. A reader landing on any post can see which
layer it instantiates and how it relates to the spine (post 52).

## 9.2 Phase 2: Merges and Archivals

Execute the six conflict resolutions per section 7.1. Specifically:

- Archive post 05 after lifting `lssince` into post 51's table
- Archive post 27 (no content lift)
- Archive post 36 after lifting working ChatGPT-Shiny code into
  post 60 (which does not yet exist; defer until phase 3, then
  archive 36 after 60 is authored)
- Merge post 06 into post 29
- Merge post 28 into post 29 (rrtools as appendix)
- Consolidate posts 32 and 33 (post 32 primary; post 33 either
  Shiny-specific case study or URL redirect)

**Goal.** The corpus shape (number of posts, redundancy
elimination) matches the framework before structural completion
work begins.

## 9.3 Phase 3: New Precursors (53, 55, 60)

Author posts 53 (Modern CLI), 55 (AWS SSO), and 60 (LLM-augmented
editing). These are precursors to substantial revisions of post
01, posts 22 / 23, and the residual content of post 36
respectively.

**Goal.** The precursor posts exist before they are referenced
by re-frames in phase 4.

## 9.4 Phase 4: TCP Structural Completion (Global Sweep)

Sweep the structural gaps TCP enumerates: ambiance images,
Lessons Learnt 3-bucket sections, version matrices, Daily
Workflow tables, Verification, Uninstall / Rollback. Execute as
a global pass per section type ('add Lessons Learnt to 35
posts in one sitting'), not per-post.

**Goal.** Structural conformance, exploiting batch efficiency.

## 9.5 Phase 5: Remaining New Posts (54, 56, 57, 58, 59)

Author the five remaining new posts. These are extensions, not
precursors; their absence does not block other work but their
presence completes coverage.

**Goal.** Coverage gaps closed.

## 9.6 Phase 6: Tier-2/3 Draft Completion

Complete posts 28 (now an appendix in 29), 30, 31, 34, 35, 37,
38, 40, 41, 42, 48. By this phase the framework is in place
and the new precursor posts exist, so each draft completion is
straightforward (the earlier phases have removed the ambiguity
about how each post fits the construct).

**Goal.** All posts in the corpus are publishable.

## 9.7 Phase 7: Image Generation

Replace remaining logo heroes per `HERO_IMAGE_PROMPTS.md`.
Replace ambiance coffee placeholders with post-specific imagery.
This is the most time-consuming phase per post (image generation
plus processing) and is deliberately last so that no
framework or structural work waits on image production.

**Goal.** Visual polish.

# 10. Risks and Open Questions

**Tooling drift in cloud posts (22, 23).** These predate AWS IAM
Identity Center. New post 55 is a precursor before substantial
revisions of 22 and 23 can be scheduled. Until 55 exists, 22
and 23 should not be re-framed beyond the layer-declaration
intro, lest the re-frame recommend the wrong credentials path.

**Unique content in archival candidates.** Post 36's working
ChatGPT API code should be lifted into post 60 before
archival. Post 28's rrtools history should land as an appendix
in post 29 before archival. Failing either lift would lose
content that is otherwise unrecoverable.

**Over-merge of Docker posts.** Combining 32 and 33 may break
inbound search landings; the mitigation in section 5.2.3 should
be implemented before archival. Failing the mitigation would
produce a small but real link-rot incident.

**Tier D placement.** Knowledge management is currently an
extension family in post 52, not a layer. The curriculum
elevates it to Tier D; an alternative is to fold post 57 into
Tier A as the file-system layer's reading-side companion. The
decision affects how posts 57 and 60 are positioned and whether
they appear in post 52's See Also. **This is the one open
question for the user that should be resolved before Phase 3
begins.**

**Effort estimate divergence.** For posts 37 and 42, TCP's
'high effort' rating and NRP's 'intro-only re-frame' verb
diverge sharply. The TCP estimate is likely correct (the body
content is incomplete), and the re-frame is a wrapper on top of
the heavy writing. Verify before scheduling.

**Post 44.** Listed as a stub in TCP but absent from the
directory listing. Likely already archived; worth confirming
before assuming it is gone.

**Image-generation dependency.** Phase 1 produces a coherent
curriculum on placeholder heroes; the image work in Phase 7 is
optional polish. If publication deadlines arise, the corpus is
publishable after Phase 6 with placeholder imagery; Phase 7 can
follow at the author's pace.

# 11. Open Question for the User

NRP places knowledge management (Zotero / Obsidian / Pandoc) in
Tier D as a separate cross-cutting tier. Post 52 currently lists
knowledge management as an extension family, not a layer. The
reconciliation could go either way: (a) keep KM as Tier D (the
curriculum framing), or (b) fold post 57 into Tier A as the
file-system layer's reading-side companion (the post-52
framing). The decision affects how posts 57 and 60 are
positioned and whether they appear in post 52's See Also.

The default in this plan is (a): KM is Tier D, parallel and
optional. The case for (b) is that knowledge management is a
file-system-layer concern (notes, references, citations all
live on disk under a convention), and that elevating it to a
separate tier inflates the framework. The case for (a) is that
KM has its own software stack (Zotero, Obsidian, Pandoc) that
is independent of the construct's other layers and that
naming it as a tier makes the construct's reach to the
research-input side legible.

A decision here is requested before Phase 3 (the new precursors
phase) begins, because post 60 (LLM-augmented editing) sits
adjacent to post 57 (KM) and the two are most naturally
authored as a pair if they share a tier.

---

*Rendered on 2026-04-27 at 10:06 PDT.*<br>
*Source: ~/prj/qblog/WORKFLOW_REFACTOR_PLAN.md*
