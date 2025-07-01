#!/bin/bash

# Remove explicit PDF format from posts to use HTML-only default

posts=(
    "posts/simpleS3/index.qmd"
    "posts/_multilanguage_quarto_demo/index.qmd"
    "posts/setup_or_modifyto_rrtools_analysis_repo_p33/index.qmd"
)

for post in "${posts[@]}"; do
    if [ -f "$post" ]; then
        echo "Updating: $post"
        # Remove the pdf: default line
        sed -i.bak '/^  pdf: default$/d' "$post"
        echo "  ✅ Removed PDF format"
    else
        echo "⚠️  File not found: $post"
    fi
done

echo ""
echo "📊 Updated posts to use HTML-only default"
echo "ℹ️  To render both HTML and PDF: quarto render --to html,pdf"
echo "ℹ️  To render only HTML: quarto render"