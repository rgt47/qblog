# PDF Generation System for qblog

This blog includes a PDF generation system that allows readers to download printer-friendly versions of articles.

## How It Works

### For Readers
Each blog post page automatically shows one of two options:

1. **Download PDF** button (if PDF already exists)
   - Click to download/view the PDF immediately
   - Shows file size for planning
   - Opens in new tab/window

2. **PDF Version Available** notice (if PDF needs to be generated)
   - Explains that a PDF can be created
   - Provides "Copy Command" button to copy the generation command
   - Shows instructions when clicked

### For Authors

#### Generate PDF for Single Post
```bash
# Interactive mode (asks to open PDF when done)
./generate_pdf.sh posts/my-post/index.qmd

# Non-interactive mode (no open prompt)
./generate_pdf.sh posts/my-post/index.qmd --no-open
```

#### Generate PDFs for All Posts
```bash
./generate_all_pdfs.sh
```

#### Check Which Posts Need PDFs
```bash
# See posts without PDFs
find posts -name "index.qmd" | while read qmd; do
  pdf_path="_site/${qmd%.qmd}.pdf"
  if [[ ! -f "$pdf_path" ]]; then
    echo "Missing PDF: $qmd"
  fi
done
```

## PDF Features

### Automatic Formatting
- Professional document layout
- Table of contents included  
- Page numbers and headers
- Proper typography for printing
- Code syntax highlighting preserved

### Generated PDFs Include:
- ✅ Article title and metadata
- ✅ Full content with formatting
- ✅ Images and figures
- ✅ Code blocks with syntax highlighting
- ✅ Mathematical equations (if any)
- ✅ Proper page breaks and margins

### PDF Configuration
PDFs are generated with these settings:
- Document class: `article`
- Paper size: `letter`
- Margins: 1 inch all around
- Color links: enabled
- Numbered sections: enabled

## User Experience

### When PDF Exists
- Immediate download link
- File size shown
- "View or save a printer-friendly version" message

### When PDF Needs Generation
- Clear explanation that PDF is available
- One-click command copying
- Instructions show on demand
- Professional styling with Bootstrap alerts

## Technical Details

### File Structure
```
posts/
├── my-post/
│   ├── index.qmd     # Source article
│   └── index.html    # Generated HTML
└── ...

_site/posts/
├── my-post/
│   ├── index.html    # Published HTML
│   └── index.pdf     # Generated PDF (if exists)
└── ...
```

### JavaScript Detection
The system automatically:
1. Detects when user is on a blog post page
2. Checks if corresponding PDF exists
3. Shows appropriate download or generation UI
4. Handles clipboard operations for command copying

### Benefits
- **For Readers**: Easy offline access, better printing
- **For Authors**: Minimal setup, automatic formatting  
- **For SEO**: PDF versions provide additional content format
- **For Accessibility**: Alternative format for different reading preferences

## Maintenance

### Regular PDF Updates
Run this periodically to keep PDFs current:
```bash
# Generate PDFs for recently modified posts
./generate_all_pdfs.sh
```

### Cleanup Old PDFs
```bash
# Remove PDFs for posts that no longer exist
find _site/posts -name "*.pdf" | while read pdf; do
  qmd_path="posts/${pdf#_site/posts/}"
  qmd_path="${qmd_path%.pdf}.qmd"
  if [[ ! -f "$qmd_path" ]]; then
    echo "Orphaned PDF: $pdf"
    rm "$pdf"
  fi
done
```