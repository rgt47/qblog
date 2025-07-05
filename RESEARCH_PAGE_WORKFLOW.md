# Research Page Update Workflow

## Overview
The research page is automatically generated from a BibTeX file using an R script. This document outlines the complete workflow for updating publications and regenerating the research page.

## File Structure
```
qblog/
├── rgthomas_pubs_2025.bib              # Source BibTeX file (edit this)
├── generate_research_final.R           # R script (processes BibTeX → QMD)
├── research/index.qmd                  # Generated Quarto file (auto-generated)
└── _site/research/index.html           # Final rendered page (auto-generated)
```

## Workflow Steps

### 1. Update Publications Data
**File**: `rgthomas_pubs_2025.bib`

Add new entries or update keywords in the BibTeX file:

```bibtex
@article{example2025,
  title={Your Research Title},
  author={Authors, List and Thomas, Ronald G and Others},
  journal={Journal Name},
  year={2025},
  keywords={Medical/Clinical, Alzheimer's disease, Clinical trials}
}
```

**Keywords Categories**:
- **Medical/Clinical**: Alzheimer's disease, Clinical trials, Drug development
- **Military/Defense**: Military health, Veterans, Traumatic brain injury
- **Neuroimaging/Technical**: PET imaging, MRI, Biomarkers, Brain imaging
- **COVID/Healthcare**: COVID-19, Healthcare workers, Pandemic response
- **Methods**: Statistical methods, Longitudinal studies, Epidemiology
- **Core**: Biostatistics, R (automatically added)

### 2. Generate Research Page Content
**Command**: 
```bash
cd /Users/zenn/Dropbox/prj/qblog
Rscript generate_research_final.R
```

**What this does**:
- Parses `rgthomas_pubs_2025.bib`
- Extracts keywords and analyzes titles for automatic categorization
- Generates publication entries grouped by year
- Creates sidebar filter tags based on available topics
- Highlights "Thomas, Ronald G" in author lists
- **Overwrites** `research/index.qmd` completely

**Output**:
```
📖 Reading rgthomas_pubs_2025.bib with keyword support...
📚 Found 321 publication entries
📝 Processed 321 publications for display
✅ Generated research/index.qmd
📊 Publication Summary:
======================
Total publications: 321
Years covered: 1983-2025
```

### 3. Render with Quarto
**Command**:
```bash
quarto render research/index.qmd
```

**What this does**:
- Converts the generated QMD file to HTML
- Applies site styling and navigation
- Creates final `_site/research/index.html`

### 4. Test the Results
**Verify**:
- ✅ New publications appear in correct year sections
- ✅ Filter tags in sidebar reflect available topics
- ✅ Tag filtering works (click badges to filter)
- ✅ Year filtering works (2020-2024, 2015-2019, etc.)
- ✅ Search functionality works
- ✅ Clear/Reset buttons work

## Complete Update Workflow

```bash
# 1. Edit BibTeX file (add entries, update keywords)
# 2. Regenerate research page
Rscript generate_research_final.R

# 3. Render the page
quarto render research/index.qmd

# 4. (Optional) Render entire site
quarto render
```

## Automation Options

### Single Command Script
Create `update_research.sh`:
```bash
#!/bin/bash
cd /Users/zenn/Dropbox/prj/qblog
echo "🔄 Regenerating research page..."
Rscript generate_research_final.R
echo "🔄 Rendering with Quarto..."
quarto render research/index.qmd
echo "✅ Research page updated successfully!"
```

### Make it executable:
```bash
chmod +x update_research.sh
./update_research.sh
```

## Automatic Topic Detection

The R script automatically detects topics from paper titles using these patterns:

| Topic | Detection Pattern |
|-------|------------------|
| Alzheimer's disease | "alzheimer" |
| Traumatic brain injury | "traumatic brain", "tbi" |
| COVID-19 | "covid" |
| Sleep disorders | "sleep", "insomnia" |
| Clinical trials | "clinical trial", "randomized" |
| Military health | "military", "veteran" |
| Neuroimaging | "imaging", "pet", "mri" |
| Biomarkers | "biomarker" |
| Cognitive decline | "cognitive", "memory" |
| Drug development | "drug", "therapy", "treatment" |
| Prevention trials | "prevention", "preventive" |
| Longitudinal studies | "longitudinal", "follow.up" |

## Important Notes

⚠️ **Warning**: The R script **completely overwrites** `research/index.qmd`. Any manual edits to that file will be lost.

✅ **Best Practice**: Always edit the BibTeX file (`rgthomas_pubs_2025.bib`) as the source of truth.

🔧 **Customization**: To modify the page layout or filtering, edit `generate_research_final.R`, not the generated QMD file.

📊 **Statistics**: The script provides publication counts by year and category for verification.

## Troubleshooting

### R Script Errors
- **Missing packages**: Install required packages: `install.packages(c("dplyr", "stringr"))`
- **File not found**: Ensure `rgthomas_pubs_2025.bib` exists in the project root
- **Parse errors**: Check BibTeX syntax (matching braces, proper escaping)

### Quarto Render Errors
- **Missing QMD**: Ensure R script completed successfully first
- **Syntax errors**: Check the generated `research/index.qmd` for malformed content

### Filtering Not Working
- **JavaScript errors**: Check browser console for errors
- **Missing elements**: Ensure sidebar tags and filter buttons are present
- **Cache issues**: Hard refresh browser (Cmd+Shift+R / Ctrl+Shift+R)

---

*Last updated: 2025-07-05*
*For technical issues, check CLAUDE.md for detailed session history*