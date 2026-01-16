# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **zzcollab research compendium** - a reproducible research project following the [rrtools](https://github.com/benmarwick/rrtools) structure. The project analyzes Palmer Penguins data through a Quarto blog post with statistical modeling.

## Architecture

### Two-Layer Reproducibility System

1. **Layer 1 (Docker)**: Ubuntu X11 minimal profile with R 4.5.1, Quarto, and base packages
2. **Layer 2 (renv)**: Dynamic package management via `renv.lock` for exact version reproducibility

### Directory Structure

- `analysis/paper/index.qmd` - Main Quarto blog post (symlinked to root `index.qmd`)
- `analysis/scripts/` - Analysis pipeline scripts
- `analysis/data/` - Raw and derived data (symlinked to root `data/`)
- `analysis/figures/` - Generated plots (symlinked to root `figures/`)
- `R/` - Reusable R functions
- `tests/` - Unit tests (`tests/testthat/`) and integration tests (`tests/integration/`)
- `modules/` - Shell modules for validation and utilities

### Key Files

- `Dockerfile` - Computational environment (ubuntu_x11_minimal profile)
- `renv.lock` - Exact R package versions
- `.Rprofile` - R session configuration with auto-snapshot on exit
- `Makefile` - Build automation (Docker and native targets)

## Common Commands

### Development Workflow

```bash
# Enter Docker container (validates packages on entry/exit)
make r                    # or: make docker-run

# Build Docker image from current renv.lock
make docker-build

# Run all tests
make docker-test

# Render Quarto document
quarto render analysis/paper/index.qmd --to html
```

### Package Validation (No Host R Required)

```bash
# Full validation with auto-fix (recommended before commits)
make check-renv

# Validation only, no auto-fix
make check-renv-no-fix

# Standard mode (skip tests/, vignettes/)
make check-renv-no-strict
```

### Running Tests

```bash
# All tests in Docker
make docker-test

# Native R (requires local R)
make test

# Single test file
Rscript -e "testthat::test_file('tests/testthat/test-utils.R')"

# Integration tests
Rscript tests/integration/test-analysis-scripts.R
```

## Package Management

Packages are managed automatically:

1. Install packages inside container: `install.packages("pkg")` or `renv::install("pkg")`
2. Exit container - auto-snapshot captures changes to `renv.lock`
3. Validation runs automatically via `modules/validation.sh`

The validation module (`modules/validation.sh`) is a pure shell implementation that:
- Extracts packages from R code using grep/sed/awk
- Parses DESCRIPTION and renv.lock without requiring R
- Auto-adds missing CRAN packages via CRAN API queries

## CI/CD

GitHub Actions workflow (`.github/workflows/blog-render.yml`) triggers on changes to:
- `analysis/paper/**`
- `renv.lock`
- `Dockerfile`

The workflow builds the Docker image, restores packages, and renders the Quarto document.

## Testing Strategy

- **Unit tests** (`tests/testthat/`): Test R functions in `R/`
- **Integration tests** (`tests/integration/`):
  - `test-analysis-scripts.R` - Verify analysis scripts run without errors
  - `test-data-pipeline.R` - Validate data transformations
  - `test-report-rendering.R` - Check Quarto rendering

## Key Symlinks

Root-level symlinks enable Quarto compatibility while maintaining rrtools structure:
- `index.qmd` -> `analysis/paper/index.qmd`
- `data/` -> `analysis/data/`
- `figures/` -> `analysis/figures/`
- `media/` -> `analysis/media/`
