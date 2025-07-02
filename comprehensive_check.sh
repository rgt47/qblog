#\!/bin/bash

echo "Files that need 'draft: true' added (excluding Palmer Penguins parts 1-5):"
echo "======================================================================="

# Get all qmd files and filter appropriately
find blog posts -name "*.qmd" -type f | \
    grep -v "_archive" | \
    grep -v "_post_template" | \
    grep -v "palmer_penguins_part[1-5]" | \
    grep -v "quarto-blog-template" | \
    grep -v "chat_blog_draft" | \
    grep -v "_multilanguage_quarto_demo" | \
    grep -v "/analysis/" | \
    grep -v "_index3" | \
    grep -v "claude_synth" | \
    grep -v "docker_renv" | \
    grep -v "drafts.qmd" | \
    sort | while read file; do
    
    if [ -f "$file" ]; then
        # Check if file contains any draft field
        if grep -q "^draft:" "$file"; then
            # Get the draft value
            draft_line=$(grep "^draft:" "$file" | head -1)
            if [[ "$draft_line" =~ draft:[[:space:]]*false ]] || [[ "$draft_line" =~ draft:[[:space:]]*no ]]; then
                echo "$(pwd)/$file (has draft: false/no)"
            fi
            # If it has draft: true, we don't need to do anything
        else
            # No draft field found
            echo "$(pwd)/$file (missing draft field)"
        fi
    fi
done
