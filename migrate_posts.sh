#!/usr/bin/env bash
set -euo pipefail

# migrate_posts.sh — Migrate qblog posts to standalone zzcollab projects
#
# Usage:
#   ./migrate_posts.sh                  # migrate all posts
#   ./migrate_posts.sh 01-configtermzsh # migrate single post
#   ./migrate_posts.sh --dry-run        # show what would happen
#   ./migrate_posts.sh --list           # list post mapping

QBLOG="/Users/zenn/Library/CloudStorage/Dropbox/prj/qblog"
BLOG_HOME="$HOME/prj/blog"
TEMPLATE="$QBLOG/posts/39-templatepost"
ZZCOLLAB_TEMPLATES="$HOME/prj/sfw/07-zzcollab/zzcollab/templates"
GITHUB_USER="rgt47"
LOG_FILE="$QBLOG/migration.log"

DRY_RUN=false
SINGLE_POST=""

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        --list)
            echo "Post mapping (NN-dirname → projectname):"
            for dir in "$QBLOG/posts"/[0-9]*; do
                nn_name=$(basename "$dir")
                proj_name=$(echo "$nn_name" | sed 's/^[0-9]*-//')
                echo "  $nn_name → $proj_name"
            done
            exit 0
            ;;
        --help|-h)
            echo "Usage: $0 [--dry-run] [--list] [POST_NAME]"
            exit 0
            ;;
        *)
            SINGLE_POST="$arg"
            ;;
    esac
done

log() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
    echo "$msg"
    echo "$msg" >> "$LOG_FILE"
}

run() {
    if $DRY_RUN; then
        echo "  [DRY-RUN] $*"
    else
        "$@"
    fi
}

FULL_SCAFFOLD_POSTS=(
    01-configtermzsh
    02-githubarchive
    06-markdowntoblog
    08-palmerpenguinspart1
    09-palmerpenguinspart2
    10-palmerpenguinspart3
    11-palmerpenguinspart4
    12-palmerpenguinspart5
    14-penguins1zzcollab
    17-rapidconversionRtoRmd
    24-setupdotfilesongithub
    34-shinyvsobservable
    39-templatepost
    42-zzedcindependence
)

is_full_scaffold() {
    local post="$1"
    for fs in "${FULL_SCAFFOLD_POSTS[@]}"; do
        [[ "$post" == "$fs" ]] && return 0
    done
    return 1
}

has_analysis_report() {
    local post_dir="$1"
    [[ -f "$post_dir/analysis/report/index.qmd" ]]
}

scaffold_post() {
    local nn_name="$1"
    local proj_name="$2"
    local proj_dir="$BLOG_HOME/$nn_name/$proj_name"

    log "  Scaffolding zzcollab files for $nn_name"

    # Copy infrastructure files from template
    for f in Dockerfile Makefile .Rprofile .gitignore .Rbuildignore; do
        if [[ ! -f "$proj_dir/$f" ]]; then
            log "    Copying $f"
            run cp "$TEMPLATE/$f" "$proj_dir/$f"
        else
            log "    $f already exists, skipping"
        fi
    done

    # Copy minimal renv.lock from zzcollab templates
    if [[ ! -f "$proj_dir/renv.lock" ]]; then
        log "    Copying minimal renv.lock"
        run cp "$ZZCOLLAB_TEMPLATES/renv.lock" "$proj_dir/renv.lock"
    fi

    # Copy renv/activate.R
    if [[ ! -d "$proj_dir/renv" ]]; then
        log "    Creating renv/ directory"
        run mkdir -p "$proj_dir/renv"
        run cp "$TEMPLATE/renv/activate.R" "$proj_dir/renv/activate.R"
        # renv .gitignore
        if [[ ! $DRY_RUN ]]; then
            true  # will be created below
        fi
        run bash -c "cat > '$proj_dir/renv/.gitignore' << 'RENVGI'
sandbox/
library/
local/
cellar/
lock/
python/
staging/
RENVGI"
    fi

    # Copy GitHub Actions workflow
    if [[ ! -d "$proj_dir/.github/workflows" ]]; then
        log "    Creating .github/workflows/"
        run mkdir -p "$proj_dir/.github/workflows"
        run cp "$TEMPLATE/.github/workflows/blog-render.yml" \
            "$proj_dir/.github/workflows/blog-render.yml"
    fi

    # Generate DESCRIPTION if it's the generic "BlogPost" one
    if [[ -f "$proj_dir/DESCRIPTION" ]]; then
        local pkg_name
        pkg_name=$(grep '^Package:' "$proj_dir/DESCRIPTION" | \
            awk '{print $2}')
        if [[ "$pkg_name" == "BlogPost" ]]; then
            log "    Updating DESCRIPTION Package name to $proj_name"
            if ! $DRY_RUN; then
                sed -i '' "s/^Package: BlogPost/Package: $proj_name/" \
                    "$proj_dir/DESCRIPTION"
                sed -i '' \
                    "s/^Title: Blog Post Content/Title: $proj_name blog post/" \
                    "$proj_dir/DESCRIPTION"
            fi
        fi
    else
        log "    Generating DESCRIPTION for $proj_name"
        if ! $DRY_RUN; then
            cat > "$proj_dir/DESCRIPTION" << DESCEOF
Package: $proj_name
Title: $proj_name blog post
Version: 0.0.0.9000
Authors@R:
    person("Ronald G.", "Thomas", role = c("aut", "cre"))
Description: Blog post in ZZCOLLAB reproducible research format.
License: CC-BY-4.0
Encoding: UTF-8
Imports:
    testthat,
    renv,
DESCEOF
        fi
    fi

    # Generate NAMESPACE if missing or minimal
    if [[ ! -f "$proj_dir/NAMESPACE" ]] || \
       [[ $(wc -l < "$proj_dir/NAMESPACE") -lt 2 ]]; then
        log "    Generating NAMESPACE"
        if ! $DRY_RUN; then
            cat > "$proj_dir/NAMESPACE" << 'NSEOF'
exportPattern("^[[:alpha:]]")
NSEOF
        fi
    fi

    # Create missing directories
    for d in analysis/scripts analysis/figures analysis/data/raw_data \
             analysis/data/derived_data analysis/media/images \
             R tests/testthat tests/integration .zzcollab; do
        if [[ ! -d "$proj_dir/$d" ]]; then
            log "    Creating $d/"
            run mkdir -p "$proj_dir/$d"
        fi
    done

    # Handle the special case: 15-piping has index.qmd at root, not
    # in analysis/report/
    if [[ ! -d "$proj_dir/analysis/report" ]]; then
        run mkdir -p "$proj_dir/analysis/report"
    fi
    if [[ -f "$proj_dir/index.qmd" && ! -L "$proj_dir/index.qmd" ]]; then
        log "    Moving root index.qmd to analysis/report/"
        run mv "$proj_dir/index.qmd" "$proj_dir/analysis/report/index.qmd"
    fi

    # Create root-level symlinks
    if [[ ! -L "$proj_dir/index.qmd" ]]; then
        log "    Creating root symlink: index.qmd → analysis/report/index.qmd"
        run ln -s analysis/report/index.qmd "$proj_dir/index.qmd"
    fi
    for link in data:analysis/data figures:analysis/figures \
                media:analysis/media; do
        local name="${link%%:*}"
        local target="${link##*:}"
        if [[ ! -L "$proj_dir/$name" && ! -d "$proj_dir/$name" ]]; then
            log "    Creating root symlink: $name → $target"
            run ln -s "$target" "$proj_dir/$name"
        fi
    done

    # Create analysis/report/ symlinks (for relative paths in qmd)
    for link in data:../data figures:../figures media:../media; do
        local name="${link%%:*}"
        local target="${link##*:}"
        if [[ ! -L "$proj_dir/analysis/report/$name" ]]; then
            log "    Creating report symlink: $name → $target"
            run ln -s "$target" "$proj_dir/analysis/report/$name"
        fi
    done
}

migrate_post() {
    local nn_name="$1"
    local proj_name
    proj_name=$(echo "$nn_name" | sed 's/^[0-9]*-//')
    local leadin="$BLOG_HOME/$nn_name"
    local proj_dir="$leadin/$proj_name"
    local src_dir="$QBLOG/posts/$nn_name"

    log "=== Migrating $nn_name → $proj_name ==="

    # Skip if already migrated (project dir exists with .git)
    if [[ -d "$proj_dir/.git" ]]; then
        log "  Already migrated (has .git), skipping"
        return 0
    fi

    # Step 1: Create lead-in directory
    if [[ ! -d "$leadin/archive" ]]; then
        log "  Creating lead-in: $leadin/archive/"
        run mkdir -p "$leadin/archive"
    fi

    # Step 2: Move post content to project directory
    if [[ -d "$src_dir" && ! -L "$src_dir" ]]; then
        log "  Moving $src_dir → $proj_dir"
        run mv "$src_dir" "$proj_dir"
    elif [[ -L "$src_dir" ]]; then
        log "  Source is already a symlink, skipping move"
    else
        log "  WARNING: Source directory $src_dir does not exist"
        return 1
    fi

    # Step 3: Scaffold if needed
    if ! is_full_scaffold "$nn_name"; then
        scaffold_post "$nn_name" "$proj_name"
    else
        log "  Full scaffold already present"
        # Still ensure root-level symlinks exist for fully-scaffolded
        # posts that may be missing some
        for link in data:analysis/data figures:analysis/figures \
                    media:analysis/media; do
            local name="${link%%:*}"
            local target="${link##*:}"
            if [[ ! -L "$proj_dir/$name" && ! -d "$proj_dir/$name" ]]; then
                log "    Creating missing root symlink: $name → $target"
                run ln -s "$target" "$proj_dir/$name"
            fi
        done
        # Ensure analysis/report/ symlinks exist
        if [[ -d "$proj_dir/analysis/report" ]]; then
            for link in data:../data figures:../figures media:../media; do
                local name="${link%%:*}"
                local target="${link##*:}"
                if [[ ! -L "$proj_dir/analysis/report/$name" ]]; then
                    log "    Creating missing report symlink: $name → $target"
                    run ln -s "$target" "$proj_dir/analysis/report/$name"
                fi
            done
        fi
        # Ensure directories exist
        for d in analysis/scripts analysis/figures \
                 analysis/data/raw_data analysis/data/derived_data \
                 analysis/media/images R tests/testthat \
                 tests/integration; do
            if [[ ! -d "$proj_dir/$d" ]]; then
                run mkdir -p "$proj_dir/$d"
            fi
        done
    fi

    # Step 4: Initialize git repo
    if [[ ! -d "$proj_dir/.git" ]] && ! $DRY_RUN; then
        log "  Initializing git repo"
        (
            cd "$proj_dir"
            git init -b main
            git add .
            git commit -m "Initial zzcollab scaffold for blog post: $proj_name"
        )
    elif $DRY_RUN; then
        echo "  [DRY-RUN] git init && git add . && git commit in $proj_dir"
    fi

    # Step 5: Create GitHub repo and push
    if ! $DRY_RUN; then
        local repo_exists
        repo_exists=$(gh repo view "$GITHUB_USER/$proj_name" \
            --json name 2>/dev/null || echo "")
        if [[ -z "$repo_exists" ]]; then
            log "  Creating GitHub repo: $GITHUB_USER/$proj_name"
            (
                cd "$proj_dir"
                gh repo create "$GITHUB_USER/$proj_name" \
                    --public --source=. --remote=origin
                git remote set-url origin \
                    "git@github.com:$GITHUB_USER/$proj_name.git"
                git push -u origin main
            )
        else
            log "  GitHub repo already exists, pushing"
            (
                cd "$proj_dir"
                git remote get-url origin 2>/dev/null || \
                    git remote add origin \
                        "git@github.com:$GITHUB_USER/$proj_name.git"
                git remote set-url origin \
                    "git@github.com:$GITHUB_USER/$proj_name.git"
                git push -u origin main 2>/dev/null || true
            )
        fi
    else
        echo "  [DRY-RUN] gh repo create $GITHUB_USER/$proj_name --public"
    fi

    # Step 6: Create symlink in qblog/posts/
    local symlink_target="$proj_dir"
    local symlink_path="$QBLOG/posts/$nn_name"
    if [[ -L "$symlink_path" ]]; then
        log "  Symlink already exists at $symlink_path"
    elif [[ ! -e "$symlink_path" ]]; then
        log "  Creating symlink: $symlink_path → $symlink_target"
        run ln -s "$symlink_target" "$symlink_path"
    fi

    log "  Done: $nn_name"
}

# --- Main ---

log "Migration started (dry_run=$DRY_RUN)"

# Create top-level blog directory
if [[ ! -d "$BLOG_HOME" ]]; then
    log "Creating $BLOG_HOME"
    run mkdir -p "$BLOG_HOME"
fi

if [[ -n "$SINGLE_POST" ]]; then
    migrate_post "$SINGLE_POST"
else
    for dir in "$QBLOG/posts"/[0-9]*; do
        nn_name=$(basename "$dir")
        # Skip if it's already a symlink (already migrated)
        if [[ -L "$dir" ]]; then
            log "Skipping $nn_name (already a symlink)"
            continue
        fi
        migrate_post "$nn_name"
    done
fi

log "Migration complete"
