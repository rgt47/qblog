#!/bin/bash

# Script to manage draft status of blog posts

# Function to show usage
show_usage() {
    echo "Usage: $0 [draft|publish] <post-directory>"
    echo ""
    echo "Examples:"
    echo "  $0 draft posts/my-new-post/"
    echo "  $0 publish posts/my-new-post/"
    echo ""
    echo "This script adds or removes 'draft: true' from post YAML frontmatter."
}

# Function to add draft status
mark_as_draft() {
    local post_dir="$1"
    local index_file="$post_dir/index.qmd"
    
    if [[ ! -f "$index_file" ]]; then
        echo "Error: $index_file not found"
        return 1
    fi
    
    # Check if already has draft: true
    if grep -q "^draft: true" "$index_file"; then
        echo "Post is already marked as draft"
        return 0
    fi
    
    # Add draft: true after the date line
    sed -i '' '/^date:/a\
draft: true' "$index_file"
    
    echo "✅ Marked as draft: $post_dir"
}

# Function to publish (remove draft status)
publish_post() {
    local post_dir="$1"
    local index_file="$post_dir/index.qmd"
    
    if [[ ! -f "$index_file" ]]; then
        echo "Error: $index_file not found"
        return 1
    fi
    
    # Remove draft: true line
    sed -i '' '/^draft: true/d' "$index_file"
    
    echo "✅ Published: $post_dir"
}

# Main script logic
if [[ $# -ne 2 ]]; then
    show_usage
    exit 1
fi

action="$1"
post_dir="$2"

case "$action" in
    draft)
        mark_as_draft "$post_dir"
        ;;
    publish)
        publish_post "$post_dir"
        ;;
    *)
        echo "Error: Unknown action '$action'"
        show_usage
        exit 1
        ;;
esac