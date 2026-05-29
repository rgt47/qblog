#!/usr/bin/env python3
"""Inject cluster YAML keys and a 'Related posts in this cluster' block
into each renumbered qblog post. Writes via /tmp + mv to avoid CloudStorage
in-place-edit hazards."""

import os
import re
import shutil
import tempfile
from pathlib import Path

POSTS_DIR = Path(
    "/Users/zenn/Library/CloudStorage/Dropbox/prj/qblog/posts"
)

CLUSTERS = [
    (
        "zzcollab-compendia",
        "ZZCOLLAB Reproducible Compendia",
        [
            ("01-zc-quarto-compendium-intro",
             "Reproducible Blog Posts with ZZCOLLAB"),
            ("02-zc-blog-post-template",
             "Constructing a reproducible blog post using zzcollab tools"),
            ("03-zc-markdown-to-blog-workflow",
             "From Markdown to Blog Post: A ZZCOLLAB workflow"),
            ("04-zc-share-rmd-via-docker",
             "Sharing R Code via Docker: R Markdown Reports"),
            ("05-zc-analysis-initiation-checklist",
             "A 55-Item Initiation Checklist for zzcollab Data Analyses"),
            ("06-zc-manuscript-report-elements",
             "Seven Required Elements for a zzc Manuscript report.Rmd"),
            ("07-zc-tiered-ci-strategy",
             "A tiered CI strategy for zzcollab research compendia"),
            ("08-zc-github-actions-workflows",
             "GitHub Actions workflows for zzcollab research compendia"),
        ],
    ),
    (
        "workflow-construct",
        "Workflow Construct",
        [
            ("15-wf-construct-overview-anchor",
             "A Workflow Construct for the Modern Data Scientist"),
            ("16-wf-unix-workspace-config",
             "Unix Command-Line Workspace Setup for Data Science"),
            ("17-wf-multi-laptop-dotfiles-bootstrap",
             "Multi-Laptop macOS Bootstrap"),
            ("18-wf-git-for-data-science",
             "Setting Up Git for Data Science Workflows"),
            ("19-wf-neovim-data-science-ide",
             "Setting Up Neovim as a Data Science IDE"),
            ("20-wf-r-vim-latex-workflow",
             "Extending the R-Vim Workflow with LaTeX"),
            ("21-wf-modern-cli-tools",
             "Modern CLI Replacements for the Shell Layer"),
            ("22-wf-claude-code-in-shell",
             "LLM-Augmented Editing for the Workflow Construct"),
            ("23-wf-yabai-tiling-window-manager",
             "Configuring Yabai as a Tiling Window Manager"),
            ("24-wf-pocket-terminal-ttyd-tailscale",
             "A pocket terminal with ttyd and Tailscale"),
            ("25-wf-linux-mint-on-macbook",
             "Install Linux Mint on a MacBook Air"),
        ],
    ),
    (
        "security-and-sync",
        "Security, Backup, and Sync",
        [
            ("31-sec-three-tier-backup-architecture",
             "Research Backup Architecture"),
            ("32-sec-dropbox-to-portable-sync",
             "Migrating Off Dropbox: Beyond Dotfiles"),
            ("33-sec-pass-password-manager",
             "Setting Up pass: a Unix Password Manager"),
            ("34-sec-aws-and-pass-secrets",
             "Secrets Management for the Workflow Construct"),
            ("35-sec-multi-laptop-threat-model",
             "Security Foundations for a Multi-Laptop Research Cluster"),
        ],
    ),
    (
        "shell-and-git",
        "Shell Scripting and Git Tooling",
        [
            ("41-sh-scripts-vs-functions",
             "Refactoring a Personal Toolbox: Scripts versus Shell Functions"),
            ("43-sh-daily-research-log",
             "A Mac Workflow for Tracking Daily Research Progress"),
        ],
    ),
    (
        "penguins-arc",
        "Palmer Penguins Analysis Arc",
        [
            ("50-pp-eda",
             "Palmer Penguins Part 1: Exploratory Data Analysis"),
            ("51-pp-multiple-regression",
             "Palmer Penguins Part 2: Multiple Regression"),
            ("52-pp-cross-validation",
             "Palmer Penguins Part 3: Cross-Validation"),
            ("53-pp-diagnostics",
             "Palmer Penguins Part 4: Model Diagnostics"),
            ("54-pp-random-forest",
             "Palmer Penguins Part 5: Random Forest versus Linear"),
            ("55-pp-body-mass-prediction",
             "Predictive Modeling of Penguin Body Mass"),
            ("56-pp-grouped-plots-with-purrr",
             "Functional Plot Generation with purrr"),
        ],
    ),
    (
        "r-language",
        "R Language and Metaprogramming",
        [
            ("62-rl-pipe-equivalence-myth",
             "The Pipe Equivalence Myth"),
            ("63-rl-dynamic-column-names",
             "Dynamic Column Names: Seven Approaches Compared"),
        ],
    ),
    (
        "r-packages",
        "R Package Development and Testing",
        [
            ("70-rp-package-update-workflow",
             "Updating an R Package: A Complete Workflow"),
            ("72-rp-vim-r-repl-plugin",
             "Writing a Simple Vim Plugin for REPL Interaction"),
            ("73-rp-testing-data-analysis",
             "Testing Data Analysis Workflows in R"),
            ("74-rp-testthat-to-tinytest",
             "From testthat to tinytest"),
        ],
    ),
    (
        "publishing",
        "Quarto, R Markdown, and Publishing",
        [
            ("80-pub-multi-language-quarto",
             "Multi-Language Quarto Documents on macOS"),
            ("81-pub-r-script-to-rmd",
             "Rapid Conversion of Draft R Scripts to Formal Rmd"),
            ("83-pub-statistical-computing-textbook",
             "Building a Statistical Computing Textbook"),
            ("84-pub-obs-r-screencasts",
             "Setting up OBS for Live R Coding Screencasts"),
        ],
    ),
    (
        "shiny",
        "Shiny and Interactive Visualization",
        [
            ("90-shy-shiny-with-observable",
             "Combining Observable JS and Shiny in a Quarto Document"),
            ("91-shy-prototype-with-chatgpt",
             "Prototyping a Shiny App with ChatGPT"),
        ],
    ),
    (
        "clinical-and-cloud",
        "Clinical Trials and Cloud Deployment",
        [
            ("95-cln-multilang-trial-validation",
             "Clinical Trial Data Validation Across Languages"),
            ("96-cln-aws-ec2-provisioning",
             "Provisioning AWS EC2 Instances"),
            ("97-cln-zzedc-investigator-independence",
             "Running ZZedc Independently for Clinical Trials"),
        ],
    ),
]


def find_qmd(post_dir: Path) -> Path | None:
    """Resolve the post's main index.qmd through any symlink. Tries the
    outer dir first, then any inner compendium subdir."""
    p = post_dir / "index.qmd"
    if p.exists():
        return p.resolve()
    for child in sorted(post_dir.iterdir()):
        if child.is_dir() and child.name not in (
            "archive", "_archive", ".git", "renv", "tests"
        ) and not child.name.startswith("."):
            inner = child / "index.qmd"
            if inner.exists():
                return inner.resolve()
    return None


def build_block(cluster_label: str, members: list,
                self_dir: str) -> str:
    lines = [
        "",
        "## Related posts in this cluster",
        "",
        f"This post is part of the *{cluster_label}* series.",
        "Recommended reading order:",
        "",
    ]
    for idx, (mdir, mtitle) in enumerate(members, start=1):
        link = f"../{mdir}/"
        marker = " (this post)" if mdir == self_dir else ""
        if mdir == self_dir:
            lines.append(
                f"{idx}. **Post {mdir[:2]}: {mtitle}**{marker}"
            )
        else:
            lines.append(
                f"{idx}. Post {mdir[:2]}: [{mtitle}]({link})"
            )
    lines.append("")
    return "\n".join(lines)


def inject_yaml(content: str, cluster_slug: str,
                cluster_order: int) -> str:
    """Insert cluster: and cluster-order: just before the second '---'."""
    if not content.startswith("---"):
        return content
    lines = content.split("\n")
    end_idx = None
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            end_idx = i
            break
    if end_idx is None:
        return content
    if any("cluster:" in ln for ln in lines[1:end_idx]):
        new_lines = []
        for ln in lines:
            if ln.startswith("cluster:") or ln.startswith("cluster-order:"):
                continue
            new_lines.append(ln)
        lines = new_lines
        for i in range(1, len(lines)):
            if lines[i].strip() == "---":
                end_idx = i
                break
    insert = [
        f"cluster: {cluster_slug}",
        f"cluster-order: {cluster_order}",
    ]
    new_lines = lines[:end_idx] + insert + lines[end_idx:]
    return "\n".join(new_lines)


def inject_body(content: str, block: str) -> str:
    """Insert block before '## Reproducibility' if present, else append."""
    marker = "## Related posts in this cluster"
    if marker in content:
        pre, _, post = content.partition(marker)
        next_h2 = re.search(r"\n## ", post)
        if next_h2:
            content = pre + post[next_h2.start() + 1:]
        else:
            content = pre.rstrip() + "\n"
    m = re.search(r"^## Reproducibility", content, re.MULTILINE)
    if m:
        return content[:m.start()] + block.lstrip() + "\n" + content[m.start():]
    return content.rstrip() + "\n" + block + "\n"


def safe_write(target: Path, new_content: str):
    fd, tmp_path = tempfile.mkstemp(
        suffix=".qmd", prefix="qblog-inject-", dir="/tmp"
    )
    os.close(fd)
    with open(tmp_path, "w") as f:
        f.write(new_content)
    shutil.move(tmp_path, str(target))


def main():
    summary = []
    for cluster_slug, cluster_label, members in CLUSTERS:
        for order, (post_dir, _) in enumerate(members, start=1):
            full_dir = POSTS_DIR / post_dir
            if not full_dir.is_dir():
                summary.append(f"MISSING_DIR  {post_dir}")
                continue
            qmd = find_qmd(full_dir)
            if qmd is None or not qmd.exists():
                summary.append(f"MISSING_QMD  {post_dir}")
                continue
            content = qmd.read_text()
            block = build_block(cluster_label, members, post_dir)
            new_content = inject_yaml(content, cluster_slug, order)
            new_content = inject_body(new_content, block)
            if new_content != content:
                safe_write(qmd, new_content)
                summary.append(f"UPDATED      {post_dir}")
            else:
                summary.append(f"NO_CHANGE    {post_dir}")
    print("\n".join(summary))
    print(f"\nTotal posts processed: {len(summary)}")


if __name__ == "__main__":
    main()
