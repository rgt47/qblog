#!/bin/bash

# This script is automatically run after quarto render to generate PDFs
# for all blog posts that don't already have them

echo "🔄 Post-render: Checking for missing PDFs..."

generated_count=0
skipped_count=0

# Find all rendered HTML posts
for html_file in _site/posts/*/index.html; do
    if [[ -f "$html_file" ]]; then
        # Get the corresponding PDF path and source QMD path
        pdf_file="${html_file%.html}.pdf"
        post_dir=$(basename "$(dirname "$html_file")")
        qmd_file="posts/$post_dir/index.qmd"
        
        # Skip if QMD doesn't exist (might be a copied file)
        if [[ ! -f "$qmd_file" ]]; then
            continue
        fi
        
        # Skip if it's a draft
        if grep -q "^draft: true" "$qmd_file" 2>/dev/null; then
            continue
        fi
        
        # Check if PDF is missing or older than HTML
        if [[ ! -f "$pdf_file" ]] || [[ "$html_file" -nt "$pdf_file" ]]; then
            echo "📄 Generating PDF for: $post_dir"
            
            # Generate PDF quietly
            if ./generate_pdf.sh "$qmd_file" --no-open >/dev/null 2>&1; then
                generated_count=$((generated_count + 1))
            else
                echo "   ⚠️  Failed to generate PDF for: $post_dir"
            fi
        else
            skipped_count=$((skipped_count + 1))
        fi
    fi
done

if [[ $generated_count -gt 0 ]]; then
    echo "✅ Generated $generated_count PDF(s)"
elif [[ $skipped_count -gt 0 ]]; then
    echo "✅ All PDFs up to date ($skipped_count posts)"
else
    echo "ℹ️  No blog posts found"
fi