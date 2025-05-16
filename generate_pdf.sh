#!/bin/bash

# This script renders individual blog posts as both HTML and PDF
# Usage: ./generate_pdf.sh [path/to/post.qmd]
# Example: ./generate_pdf.sh posts/dockerize_simple/index.qmd
# If no argument is provided, it will generate a PDF for the most recently modified post

# Check if an argument was provided
if [ $# -eq 0 ]; then
  echo "No post specified. Finding the most recently modified post..."
  POST_PATH=$(find posts -name "index.qmd" -type f -print0 | xargs -0 ls -t | head -1)
  if [ -z "$POST_PATH" ]; then
    echo "Error: Could not find any posts."
    exit 1
  fi
  echo "Found most recent post: $POST_PATH"
else
  POST_PATH=$1
fi

# Check if the file exists
if [ ! -f "$POST_PATH" ]; then
  echo "Error: File $POST_PATH not found."
  exit 1
fi

echo "Generating PDF for $POST_PATH..."

# Check if the post already has PDF format defined
if grep -q "format:.*pdf:" "$POST_PATH"; then
  echo "This post already has PDF format settings. Rendering with existing settings..."
  # Just render with the existing settings
  quarto render "$POST_PATH" --to pdf
else
  echo "Adding PDF format settings for this render..."
  # Create a temporary YAML file with PDF format settings
  TMP_YAML=$(mktemp)
  cat > $TMP_YAML << EOF
format:
  pdf:
    documentclass: article
    papersize: letter
    colorlinks: true
    number-sections: true
    toc: true
    include-in-header:
      text: |
        \usepackage{fancyhdr}
        \pagestyle{fancy}
        \fancyhead[L]{Thomas Lab}
        \fancyhead[R]{\thepage}
        \fancyfoot[C]{Generated on $(date '+%Y-%m-%d')}
EOF

  # Run quarto render with the additional metadata
  quarto render "$POST_PATH" --to pdf --metadata-file $TMP_YAML

  # Clean up
  rm $TMP_YAML
fi

# Get the output pdf path
# Quarto puts PDFs in the _site directory
POST_REL_PATH=$(echo "$POST_PATH" | sed 's|^posts/||')
PDF_PATH="_site/posts/${POST_REL_PATH%.qmd}.pdf"

# Check if PDF was generated
if [ -f "$PDF_PATH" ]; then
  echo "Success! PDF generated at: $PDF_PATH"

  # Display file size
  PDF_SIZE=$(du -h "$PDF_PATH" | cut -f1)
  echo "PDF size: $PDF_SIZE"

  # If we're on macOS, offer to open the PDF
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Would you like to open the PDF? (y/n)"
    read -r OPEN_PDF
    if [[ "$OPEN_PDF" =~ ^[Yy]$ ]]; then
      open "$PDF_PATH"
    fi
  fi
else
  echo "Error: PDF generation failed. Please check the console output for errors."
fi