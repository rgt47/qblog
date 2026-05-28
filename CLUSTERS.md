# Blog Post Cluster Reference

*2026-05-28 15:51 PDT*

This document records the cluster coding scheme used across the qblog
corpus. Each post directory under `posts/` follows the convention:

```
NN-<cluster-tag>-<goal-phrase>/
```

- `NN` is the position number within the corpus. Number ranges encode
  cluster membership (see table below). Gaps between ranges leave room
  for future posts within each cluster.
- `<cluster-tag>` is a short, stable abbreviation identifying the
  thematic cluster (two to four characters).
- `<goal-phrase>` is a kebab-case description of the post's objective,
  preferring verb-phrases or focused nouns over bare tool names.

The same `cluster:` and `cluster-order:` keys appear in each post's
YAML front matter so listings and future filters can group posts
without parsing directory names.

## Cluster table

| Range  | Tag   | Cluster slug          | Theme                                       |
|--------|-------|-----------------------|---------------------------------------------|
| 01-09  | `zc`  | zzcollab-compendia    | Reproducible research compendia, zzcollab   |
| 15-25  | `wf`  | workflow-construct    | Personal development environment            |
| 31-35  | `sec` | security-and-sync     | Backup, secrets, sync, threat models        |
| 41-43  | `sh`  | shell-and-git         | Shell scripting and git tooling             |
| 50-56  | `pp`  | penguins-arc          | Palmer Penguins analysis arc                |
| 61-63  | `rl`  | r-language            | R language semantics and metaprogramming    |
| 70-74  | `rp`  | r-packages            | R package development and testing           |
| 80-84  | `pub` | publishing            | Quarto, R Markdown, and authoring tools     |
| 90-91  | `shy` | shiny                 | Shiny and interactive visualization         |
| 95-97  | `cln` | clinical-and-cloud    | Clinical trials and cloud deployment        |

## Conventions

- The position number is unstable: future reorganization may shift it.
  The cluster tag and goal phrase are stable identifiers; rely on
  them when linking between posts.
- Per-post GitHub repositories use the goal phrase prefixed by the
  cluster tag, dropping the position number. Example: local
  `01-zc-quarto-compendium-intro/` corresponds to
  `github.com/rgt47/zc-quarto-compendium-intro`.
- Post 47 (`47-templatesetup/`) is reserved as the scaffold used by
  the `/newblog` skill. It is not a published post and is excluded
  from clustering.
- Each post contains a 'Related posts in this cluster' section that
  lists the other members in recommended reading order. Anchor posts
  (first in cluster) are marked as such.

## Anchor posts

The first post in each cluster typically functions as a reference or
overview that other cluster members extend or apply.

- C1 anchor: post 01 (`zc-quarto-compendium-intro`)
- C2 anchor: post 15 (`wf-construct-overview-anchor`)
- C3 first:  post 31 (`sec-three-tier-backup-architecture`)
- C5 first:  post 50 (`pp-eda`)
- C7 first:  post 70 (`rp-package-update-workflow`)

## Repository mapping

The `qblog` top-level repository tracks only the pre-built `_site/`
output and site configuration. Each post's source compendium lives in
its own GitHub repository under the `rgt47` account, named with the
cluster tag and goal phrase (no position number).

To enumerate the per-post repositories:

```bash
gh repo list rgt47 --limit 200 | grep -E '^rgt47/(zc|wf|sec|sh|pp|rl|rp|pub|shy|cln)-'
```
