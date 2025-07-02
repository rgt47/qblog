# Generate Research Page from Comprehensive BibTeX File
# This script processes the complete bibliography and creates a tagged, searchable research page

library(bib2df)
library(dplyr)
library(stringr)
library(purrr)
library(yaml)

# Function to categorize publications by keywords
categorize_publication <- function(title, journal, keywords = NULL) {
  title_lower <- tolower(title)
  journal_lower <- tolower(journal %||% "")
  
  tags <- character(0)
  
  # Medical/Clinical categories
  if (str_detect(title_lower, "alzheimer|dementia|cognitive|clinical trial|drug|treatment|therapy|medical|patient")) {
    tags <- c(tags, "Medical/Clinical")
  }
  
  # Military/Defense
  if (str_detect(title_lower, "military|veteran|blast|combat|traumatic brain|tbi|ptsd|soldier")) {
    tags <- c(tags, "Military/Defense")
  }
  
  # Neuroimaging/Technical
  if (str_detect(title_lower, "imaging|pet|mri|fmri|neuroimaging|fdg|florbetapir|biomarker|technical")) {
    tags <- c(tags, "Neuroimaging/Technical")
  }
  
  # COVID/Healthcare
  if (str_detect(title_lower, "covid|pandemic|healthcare worker|occupational|sleep|insomnia")) {
    tags <- c(tags, "COVID/Healthcare")
  }
  
  # Statistical/Methods
  if (str_detect(title_lower, "statistical|analysis|method|model|regression|bayesian|machine learning|data")) {
    tags <- c(tags, "Statistical/Methods")
  }
  
  # Prevention/Trials
  if (str_detect(title_lower, "prevention|trial|randomized|controlled|intervention|study design")) {
    tags <- c(tags, "Prevention/Trials")
  }
  
  # Default category if no specific match
  if (length(tags) == 0) {
    tags <- "General Research"
  }
  
  return(tags)
}

# Function to extract specific research topics
extract_topics <- function(title, journal = NULL) {
  title_lower <- tolower(title)
  topics <- character(0)
  
  # Specific disease/condition topics
  disease_topics <- list(
    "Alzheimer's disease" = "alzheimer",
    "Traumatic brain injury" = "traumatic brain|tbi",
    "COVID-19" = "covid",
    "Sleep disorders" = "sleep|insomnia",
    "PTSD" = "ptsd|trauma",
    "Substance abuse" = "alcohol|substance|abuse",
    "Cognitive decline" = "cognitive|memory|decline",
    "Military health" = "military|veteran|soldier",
    "Neuroimaging" = "imaging|pet|mri|fmri",
    "Clinical trials" = "clinical trial|randomized|controlled",
    "Biomarkers" = "biomarker|plasma|csf",
    "Prevention trials" = "prevention|preventive",
    "Drug development" = "drug|therapy|treatment|pharmacokinetic",
    "Healthcare workers" = "healthcare worker|occupational",
    "Longitudinal studies" = "longitudinal|follow.up"
  )
  
  for (topic in names(disease_topics)) {
    if (str_detect(title_lower, disease_topics[[topic]])) {
      topics <- c(topics, topic)
    }
  }
  
  return(unique(topics))
}

# Function to create badge colors
get_badge_color <- function(category) {
  color_map <- list(
    "Medical/Clinical" = "success",
    "Military/Defense" = "primary", 
    "Neuroimaging/Technical" = "info",
    "COVID/Healthcare" = "warning",
    "Statistical/Methods" = "secondary",
    "Prevention/Trials" = "success",
    "General Research" = "secondary"
  )
  
  return(color_map[[category]] %||% "secondary")
}

# Function to format author list (highlight Ronald G. Thomas)
format_authors <- function(authors) {
  if (is.null(authors) || length(authors) == 0) return("")
  
  # Handle different author formats
  if (is.list(authors)) {
    author_names <- map_chr(authors, ~ paste(.x$given, .x$family))
  } else {
    author_names <- str_split(authors, " and ")[[1]]
  }
  
  # Highlight Ronald G. Thomas
  author_names <- map_chr(author_names, function(name) {
    if (str_detect(name, "Thomas, Ronald|Ronald.*Thomas")) {
      return(paste0("**", str_trim(name), "**"))
    }
    return(str_trim(name))
  })
  
  # Format author list
  if (length(author_names) <= 3) {
    return(paste(author_names, collapse = ", "))
  } else {
    return(paste0(paste(author_names[1:3], collapse = ", "), ", et al."))
  }
}

# Function to format journal citation
format_citation <- function(entry) {
  authors <- format_authors(entry$AUTHOR)
  title <- entry$TITLE
  journal <- entry$JOURNAL %||% entry$BOOKTITLE %||% "Unknown Journal"
  year <- entry$YEAR
  volume <- entry$VOLUME
  pages <- entry$PAGES
  doi <- entry$DOI
  
  # Build citation
  citation_parts <- c(
    authors,
    paste0('"', title, '"'),
    paste0("*", journal, "*")
  )
  
  # Add volume and pages if available
  if (!is.null(volume) && !is.null(pages)) {
    citation_parts <- c(citation_parts, paste0(volume, " (", entry$NUMBER %||% "", "): ", pages))
  } else if (!is.null(volume)) {
    citation_parts <- c(citation_parts, paste0("Volume ", volume))
  } else if (!is.null(pages)) {
    citation_parts <- c(citation_parts, paste0("Pages ", pages))
  }
  
  citation_parts <- c(citation_parts, paste0("(", year, ")"))
  
  if (!is.null(doi)) {
    citation_parts <- c(citation_parts, paste0("doi: ", doi))
  }
  
  return(paste(citation_parts, collapse = ", "))
}

# Main processing function
generate_research_page <- function(bib_file = "rgthomas_cv_merged_dedup.bib", 
                                  output_file = "research/index.qmd") {
  
  cat("📚 Processing", bib_file, "...\n")
  
  # Read BibTeX file
  tryCatch({
    bib_data <- bib2df(bib_file)
  }, error = function(e) {
    cat("❌ Error reading BibTeX file:", e$message, "\n")
    cat("Trying alternative parsing...\n")
    
    # Alternative: Read raw and process manually
    bib_lines <- readLines(bib_file)
    cat("✅ Read", length(bib_lines), "lines from BibTeX file\n")
    cat("⚠️ Manual parsing not yet implemented. Please install bib2df package.\n")
    return(NULL)
  })
  
  if (is.null(bib_data)) {
    cat("❌ Failed to parse bibliography. Exiting.\n")
    return(NULL)
  }
  
  cat("✅ Successfully parsed", nrow(bib_data), "publications\n")
  
  # Process each publication
  processed_pubs <- bib_data %>%
    mutate(
      # Clean and categorize
      YEAR = as.numeric(YEAR),
      category = map2_chr(TITLE, JOURNAL, ~ paste(categorize_publication(.x, .y), collapse = ",")),
      topics = map2(TITLE, JOURNAL, ~ extract_topics(.x, .y)),
      badge_color = map_chr(str_split(category, ","), ~ get_badge_color(.x[1])),
      citation = pmap_chr(list(.), format_citation),
      
      # Create tags for filtering
      all_tags = map2(topics, str_split(category, ","), ~ c(.x, .y[[1]])),
      tag_string = map_chr(all_tags, ~ paste(.x, collapse = ","))
    ) %>%
    arrange(desc(YEAR), TITLE)
  
  # Group by year
  pubs_by_year <- processed_pubs %>%
    group_by(YEAR) %>%
    group_split()
  
  # Generate YAML header
  yaml_header <- list(
    title = "Research",
    subtitle = "Publications, projects, and academic work", 
    `page-layout` = "full"
  )
  
  # Start building the Quarto content
  content <- c(
    "---",
    yaml::as.yaml(yaml_header, indent = 2),
    "---",
    "",
    "## Publications",
    "",
    "::: {.callout-note}",
    "**Topic Color Legend & Filters:**",
    "Click any tag to filter publications by topic. Click again to remove filter.",
    "",
    "[Medical/Clinical]{.badge .badge-success .tag-filter}",
    "[Military/Defense]{.badge .badge-primary .tag-filter}",
    "[Neuroimaging/Technical]{.badge .badge-info .tag-filter}", 
    "[COVID/Healthcare]{.badge .badge-warning .tag-filter}",
    "[Statistical/Methods]{.badge .badge-secondary .tag-filter}",
    "[Prevention/Trials]{.badge .badge-success .tag-filter}",
    "[General Research]{.badge .badge-secondary .tag-filter}",
    "",
    '<button id="clear-filters" class="btn btn-sm btn-outline-secondary mt-2">Clear All Filters</button>',
    ":::",
    ""
  )
  
  # Add publications by year
  for (year_group in pubs_by_year) {
    year <- unique(year_group$YEAR)
    content <- c(content, paste("###", year), "")
    
    for (i in 1:nrow(year_group)) {
      pub <- year_group[i, ]
      
      # Paper entry div with data tags
      content <- c(content, paste0('::: {.paper-entry data-tags="', pub$tag_string, '"}'))
      
      # Citation
      content <- c(content, pub$citation, "")
      
      # Tags
      tag_badges <- map_chr(pub$topics[[1]], function(topic) {
        paste0("[", topic, "]{.badge .badge-", pub$badge_color, " .tag-clickable}")
      })
      
      if (length(tag_badges) > 0) {
        content <- c(content, paste(tag_badges, collapse = " "), "")
      }
      
      # Links section
      content <- c(content, "::: {.paper-links}")
      
      # DOI link if available
      if (!is.null(pub$DOI) && !is.na(pub$DOI)) {
        doi_url <- ifelse(str_starts(pub$DOI, "http"), pub$DOI, paste0("https://doi.org/", pub$DOI))
        content <- c(content, paste0("[🔗 Article](", doi_url, ") • [📄 PDF](", doi_url, ")"))
      } else {
        content <- c(content, "🔗 Article • 📄 PDF")
      }
      
      content <- c(content, ":::", ":::", "")
    }
  }
  
  # Add JavaScript for filtering
  js_code <- '
<script>
document.addEventListener("DOMContentLoaded", function() {
    let activeFilters = new Set();
    
    const clickableTags = document.querySelectorAll(".tag-clickable, .tag-filter");
    const clearButton = document.getElementById("clear-filters");
    const paperEntries = document.querySelectorAll(".paper-entry");
    
    clickableTags.forEach(tag => {
        tag.style.cursor = "pointer";
        tag.addEventListener("click", function(e) {
            e.preventDefault();
            const tagText = this.textContent.trim();
            
            if (activeFilters.has(tagText)) {
                activeFilters.delete(tagText);
                this.style.opacity = "1";
                this.style.transform = "none";
            } else {
                activeFilters.add(tagText);
                this.style.opacity = "0.7";
                this.style.transform = "scale(0.95)";
            }
            
            filterPapers();
            updateClearButton();
        });
    });
    
    clearButton.addEventListener("click", function() {
        activeFilters.clear();
        clickableTags.forEach(tag => {
            tag.style.opacity = "1";
            tag.style.transform = "none";
        });
        filterPapers();
        updateClearButton();
    });
    
    function filterPapers() {
        if (activeFilters.size === 0) {
            paperEntries.forEach(entry => {
                entry.style.display = "block";
                entry.style.opacity = "1";
            });
        } else {
            paperEntries.forEach(entry => {
                const tags = entry.getAttribute("data-tags").split(",");
                const hasMatchingTag = tags.some(tag => activeFilters.has(tag.trim()));
                
                if (hasMatchingTag) {
                    entry.style.display = "block";
                    entry.style.opacity = "1";
                } else {
                    entry.style.display = "none";
                    entry.style.opacity = "0.3";
                }
            });
        }
    }
    
    function updateClearButton() {
        if (activeFilters.size > 0) {
            clearButton.style.display = "inline-block";
            clearButton.textContent = `Clear Filters (${activeFilters.size})`;
        } else {
            clearButton.style.display = "none";
        }
    }
    
    updateClearButton();
});
</script>'
  
  content <- c(content, js_code)
  
  # Write to file
  writeLines(content, output_file)
  
  cat("✅ Generated research page with", nrow(processed_pubs), "publications\n")
  cat("📍 Output file:", output_file, "\n")
  
  # Summary statistics
  cat("\n📊 Publication Summary:\n")
  cat("======================\n")
  year_summary <- processed_pubs %>%
    count(YEAR, sort = TRUE) %>%
    head(10)
  
  for (i in 1:nrow(year_summary)) {
    cat(sprintf("• %d: %d publications\n", year_summary$YEAR[i], year_summary$n[i]))
  }
  
  cat("\n🏷️ Category Summary:\n")
  cat("====================\n")
  category_summary <- processed_pubs %>%
    separate_rows(category, sep = ",") %>%
    count(category, sort = TRUE)
  
  for (i in 1:nrow(category_summary)) {
    cat(sprintf("• %s: %d publications\n", category_summary$category[i], category_summary$n[i]))
  }
  
  return(processed_pubs)
}

# Check if required packages are installed
required_packages <- c("bib2df", "dplyr", "stringr", "purrr", "yaml")
missing_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]

if (length(missing_packages) > 0) {
  cat("📦 Installing required packages:", paste(missing_packages, collapse = ", "), "\n")
  install.packages(missing_packages)
}

# Run the generation
cat("🚀 Starting research page generation...\n")
result <- generate_research_page()

if (!is.null(result)) {
  cat("\n🎉 Research page generated successfully!\n")
  cat("📋 Next steps:\n")
  cat("1. Review the generated research/index.qmd file\n")
  cat("2. Run 'quarto render' to rebuild the site\n") 
  cat("3. Check the Research tab for all 340+ publications\n")
}