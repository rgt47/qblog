# Pre-print Publication Workflow

## Overview
This workflow helps you safely add pre-print PDFs to your research page while respecting copyright and legal requirements.

## Pre-print Types You Can Safely Post

### ✅ **SAFE TO POST**
1. **Author's Original Manuscript** - Your submitted version before peer review
2. **Author's Accepted Manuscript (AAM)** - Final version accepted by journal, before publisher formatting
3. **Pre-print Server Versions** - Versions posted to arXiv, bioRxiv, etc.
4. **Open Access Articles** - Articles published under CC licenses

### ⚠️ **CHECK FIRST**
1. **Post-print with Embargo** - Some publishers allow after 6-12 months
2. **Government-funded Research** - May have open access requirements
3. **Institutional Repository Versions** - Check if your institution has copies

### ❌ **AVOID**
1. **Final Published PDF** - Publisher's formatted version (unless open access)
2. **Copyrighted Material** - When you transferred all rights to publisher

## Implementation Steps

### Step 1: Create Pre-print Directory Structure
```bash
mkdir -p /Users/zenn/Dropbox/prj/qblog/preprints
mkdir -p /Users/zenn/Dropbox/prj/qblog/preprints/2024
mkdir -p /Users/zenn/Dropbox/prj/qblog/preprints/2023
mkdir -p /Users/zenn/Dropbox/prj/qblog/preprints/2022
```

### Step 2: File Naming Convention
Use this format: `YYYY_lastname_shortitle.pdf`

Examples:
- `2024_thomas_blast_tbi.pdf`
- `2023_thomas_alzheimer_prevention.pdf`
- `2022_thomas_covid_sleep.pdf`

### Step 3: Legal Checklist for Each Paper

Before adding any PDF, verify:

- [ ] **I am a co-author** on this publication
- [ ] **This is NOT the final published PDF** (unless open access)
- [ ] **I have legal right** to post this version
- [ ] **Publisher policy allows** self-archiving of this version
- [ ] **Embargo period has passed** (if applicable)

### Step 4: Publisher Policy Check

Check publisher policies at:
- **SHERPA/RoMEO**: https://v2.sherpa.ac.uk/romeo/
- **Publisher website**: Look for "self-archiving policy"
- **Journal website**: Check author rights section

### Step 5: Add Pre-print to Research Page

Update the enhanced research page generator to include pre-print links:

```r
# Add this to generate_research_enhanced.R
check_preprint_exists <- function(title, year, author) {
  # Create potential filename
  first_author_surname <- str_extract(author, "^[^,]+")
  short_title <- str_extract(tolower(title), "\\b\\w+")
  potential_filename <- paste0(year, "_", tolower(first_author_surname), "_", short_title, ".pdf")
  
  # Check if file exists
  preprint_path <- file.path("preprints", year, potential_filename)
  return(file.exists(preprint_path))
}

# Update the links section in the generator
if (check_preprint_exists(pub$title, pub$year, pub$author)) {
  preprint_url <- paste0("/preprints/", pub$year, "/", create_filename(pub))
  links <- c(links, paste0("[📄 Pre-print](", preprint_url, "){target=\"_blank\"}"))
}
```

## Safe Implementation Strategy

### Phase 1: Recent Open Access Papers (2020+)
Start with your most recent publications that are likely to:
- Be openly accessible
- Have clear author rights
- Be most valuable to visitors

### Phase 2: Government-Funded Research
Add papers from government-funded projects that often require open access.

### Phase 3: Pre-print Server Versions
Add versions that were posted to pre-print servers (these are definitely safe).

### Phase 4: Older Papers with Expired Embargoes
Check older papers where embargo periods have passed.

## Copyright-Safe Alternative Approaches

### 1. Link to Institutional Repositories
Many universities host author's accepted manuscripts:
```markdown
[📄 Institutional Repository](https://repository.university.edu/paper123)
```

### 2. Link to PubMed Central
For NIH-funded research:
```markdown
[📄 PMC Full Text](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC123456/)
```

### 3. Link to Author Profiles
```markdown
[📄 ResearchGate](https://researchgate.net/publication/123456)
[📄 ORCID](https://orcid.org/0000-0000-0000-0000)
```

### 4. "Request PDF" Contact Form
```markdown
[📧 Request PDF](mailto:your.email@institution.edu?subject=PDF%20Request:%20Paper%20Title)
```

## Implementation Script

Create this script to automate pre-print management:

```bash
#!/bin/bash
# add_preprint.sh - Safely add a pre-print to the research page

echo "Pre-print Addition Workflow"
echo "=========================="

read -p "Paper title: " title
read -p "Publication year: " year
read -p "PDF file path: " pdf_path
read -p "Confirm this is YOUR accepted manuscript (not publisher PDF) [y/N]: " confirm

if [ "$confirm" = "y" ]; then
    # Create filename and copy
    filename="${year}_thomas_$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g' | cut -c1-20).pdf"
    cp "$pdf_path" "preprints/$year/$filename"
    echo "✅ Added: preprints/$year/$filename"
    echo "💡 Now update the research page generator to include this pre-print"
else
    echo "❌ Cancelled - ensure you have legal rights to post this version"
fi
```

## Monitoring and Maintenance

### Regular Checks
- **Annual review** of publisher policies (they can change)
- **Monitor takedown requests** (though rare for legitimate pre-prints)
- **Update links** when papers move to open access

### Best Practices
- **Always include proper citation** to the published version
- **Add disclaimer** about pre-print status
- **Version control** - clearly label which version you're posting

## Disclaimer Template

Add this to your research page:
```markdown
**Note**: Pre-prints represent the author's accepted manuscript and may differ from the final published version. Please cite the published version when available.
```

## Legal Resources

- **Stanford Copyright Guide**: https://fairuse.stanford.edu/overview/academic-and-educational-permissions/
- **SPARC Author Rights**: https://sparcopen.org/our-work/author-rights/
- **Creative Commons**: https://creativecommons.org/about/cclicenses/

---

*This workflow prioritizes legal compliance while maximizing open access to your research.*