#!/bin/bash

# Script to generate PDFs for all blog posts that don't already have them

echo "🔍 Finding posts that need PDF generation..."

# Counter for generated PDFs
generated_count=0
total_posts=0

# Find all post index.qmd files
for post_qmd in posts/*/index.qmd; do
    if [[ -f "$post_qmd" ]]; then
        total_posts=$((total_posts + 1))
        
        # Get the corresponding PDF path
        post_dir=$(dirname "$post_qmd")
        post_name=$(basename "$post_dir")
        pdf_path="_site/posts/$post_name/index.pdf"
        
        # Check if PDF already exists
        if [[ -f "$pdf_path" ]]; then
            echo "✅ PDF already exists: $post_name"
        else
            echo "📄 Generating PDF for: $post_name"
            
            # Check if post is a draft
            if grep -q "^draft: true" "$post_qmd"; then
                echo "   ⏭️  Skipping draft post: $post_name"
                continue
            fi
            
            # Generate the PDF (with --no-open flag to suppress interactive prompt)
            if ./generate_pdf.sh "$post_qmd" --no-open; then
                echo "   ✅ Successfully generated PDF for: $post_name"
                generated_count=$((generated_count + 1))
            else
                echo "   ❌ Failed to generate PDF for: $post_name"
            fi
        fi
    fi
done

echo ""
echo "📊 Summary:"
echo "   Total posts: $total_posts"
echo "   PDFs generated: $generated_count"
echo "   PDFs already existed: $((total_posts - generated_count))"

if [[ $generated_count -gt 0 ]]; then
    echo ""
    echo "🎉 Generated $generated_count new PDF(s)!"
    echo "   You can now download PDFs from the blog post pages."
else
    echo ""
    echo "✨ All posts already have PDFs or are drafts."
fi