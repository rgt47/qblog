#!/bin/bash

# Script to generate PDF from Quarto document
# Usage: ./generate_pdf.sh path/to/file.qmd

if [ $# -eq 0 ]; then
    echo "Usage: $0 <path-to-qmd-file>"
    echo "Example: $0 posts/palmer_penguins_part1/index.qmd"
    exit 1
fi

QMD_FILE="$1"

if [ ! -f "$QMD_FILE" ]; then
    echo "Error: File $QMD_FILE does not exist"
    exit 1
fi

echo "Generating PDF for: $QMD_FILE"

# First render HTML to generate any plots/figures
echo "Step 1: Rendering HTML to generate figures..."
quarto render "$QMD_FILE" --to html --quiet

# Then render PDF using a simpler format
echo "Step 2: Rendering PDF..."
quarto render "$QMD_FILE" --to pdf \
  --pdf-engine=pdflatex \
  --quiet \
  --metadata documentclass=article \
  --metadata geometry="margin=1in" \
  --metadata fontsize=11pt

if [ $? -eq 0 ]; then
    PDF_FILE="${QMD_FILE%.qmd}.pdf"
    echo "✅ PDF generated successfully: $PDF_FILE"
    
    # Copy to _site if it exists
    SITE_DIR="_site/$(dirname "$QMD_FILE")"
    if [ -d "$SITE_DIR" ]; then
        cp "$PDF_FILE" "$SITE_DIR/"
        echo "✅ PDF copied to: $SITE_DIR/$(basename "$PDF_FILE")"
    fi
else
    echo "❌ PDF generation failed"
    exit 1
fi