# Generate Research Page - Final Version
# Simple and robust BibTeX parser

library(dplyr)
library(stringr)

# Enhanced BibTeX parser with keywords support
parse_bibtex_basic <- function(file_path) {
  cat("📖 Reading", file_path, "with keyword support...\n")
  lines <- readLines(file_path, warn = FALSE)
  
  # Find entry boundaries
  entry_starts <- grep("^@", lines)
  cat("📚 Found", length(entry_starts), "publication entries\n")
  
  publications <- data.frame(
    title = character(),
    author = character(), 
    year = character(),
    journal = character(),
    doi = character(),
    keywords = character(),
    stringsAsFactors = FALSE
  )
  
  for (i in seq_along(entry_starts)) {
    start_idx <- entry_starts[i]
    end_idx <- ifelse(i < length(entry_starts), entry_starts[i + 1] - 1, length(lines))
    
    entry_lines <- lines[start_idx:end_idx]
    entry_text <- paste(entry_lines, collapse = " ")
    
    # Extract fields with simple regex
    title <- extract_field(entry_text, "title")
    author <- extract_field(entry_text, "author") 
    year <- extract_field(entry_text, "year")
    journal <- extract_field(entry_text, "journal")
    if (is.na(journal)) {
      journal <- extract_field(entry_text, "booktitle")
    }
    doi <- extract_field(entry_text, "doi")
    keywords <- extract_field(entry_text, "keywords")
    
    publications <- rbind(publications, data.frame(
      title = title %||% "",
      author = author %||% "",
      year = year %||% "",
      journal = journal %||% "",
      doi = doi %||% "",
      keywords = keywords %||% "",
      stringsAsFactors = FALSE
    ))
  }
  
  cat("✅ Extracted", nrow(publications), "publications with keyword support\n")
  return(publications)
}

# Helper function to extract BibTeX fields
extract_field <- function(text, field) {
  pattern <- paste0(field, "\\s*=\\s*\\{([^}]+)\\}")
  match <- str_extract(text, pattern)
  if (is.na(match)) return(NA)
  
  # Extract content between braces
  content <- str_extract(match, "\\{([^}]+)\\}")
  content <- str_remove_all(content, "\\{|\\}")
  return(content)
}

# Categorization function
categorize_publication <- function(title, journal) {
  title_lower <- tolower(title %||% "")
  journal_lower <- tolower(journal %||% "")
  
  if (str_detect(title_lower, "alzheimer|dementia|cognitive|clinical trial|drug|treatment")) {
    return("Medical/Clinical")
  } else if (str_detect(title_lower, "military|veteran|blast|combat|traumatic brain|tbi")) {
    return("Military/Defense")
  } else if (str_detect(title_lower, "imaging|pet|mri|neuroimaging|biomarker|fdg")) {
    return("Neuroimaging/Technical")
  } else if (str_detect(title_lower, "covid|pandemic|healthcare worker|sleep|insomnia")) {
    return("COVID/Healthcare")
  } else {
    return("General Research")
  }
}

# Get badge color for category
get_badge_color <- function(category) {
  switch(category,
    "Medical/Clinical" = "success",
    "Military/Defense" = "primary", 
    "Neuroimaging/Technical" = "info",
    "COVID/Healthcare" = "warning",
    "General Research" = "secondary"
  )
}

# Extract specific topics (enhanced with keywords support)
get_topics <- function(title, keywords = NULL) {
  topics <- c()
  
  # First, use keywords if available
  if (!is.na(keywords) && keywords != "") {
    keyword_list <- str_split(keywords, ",")[[1]]
    keyword_list <- str_trim(keyword_list)
    topics <- c(topics, keyword_list)
  }
  
  # Then, add automatic topic detection from title as fallback
  title_lower <- tolower(title %||% "")
  
  auto_topics <- list(
    "Alzheimer's disease" = "alzheimer",
    "Traumatic brain injury" = "traumatic brain|tbi",
    "COVID-19" = "covid",
    "Sleep disorders" = "sleep|insomnia",
    "Clinical trials" = "clinical trial|randomized",
    "Military health" = "military|veteran",
    "Neuroimaging" = "imaging|pet|mri",
    "Biomarkers" = "biomarker",
    "Cognitive decline" = "cognitive|memory",
    "Drug development" = "drug|therapy|treatment",
    "Prevention trials" = "prevention|preventive",
    "Epidemiology" = "epidemiology|population",
    "Statistical methods" = "statistical|analysis|method",
    "Longitudinal studies" = "longitudinal|follow.up"
  )
  
  for (topic in names(auto_topics)) {
    if (str_detect(title_lower, auto_topics[[topic]]) && !topic %in% topics) {
      topics <- c(topics, topic)
    }
  }
  
  return(unique(topics))
}

# Format authors according to APA style (up to 20 authors)
format_authors <- function(author_string) {
  if (is.na(author_string) || author_string == "") return("")
  
  # Split by "and"
  authors <- str_split(author_string, " and ")[[1]]
  authors <- str_trim(authors)
  
  # Check if Ronald G. Thomas is in the first 20 authors
  thomas_in_first_20 <- any(str_detect(authors[1:min(20, length(authors))], "Thomas, Ronald|Ronald.*Thomas"))
  
  # Determine how many authors to show based on APA guidelines
  if (length(authors) <= 20) {
    # Show all authors if 20 or fewer
    authors_to_show <- authors
    use_ellipsis <- FALSE
  } else if (thomas_in_first_20) {
    # If Thomas is in first 20, show first 19 + ellipsis + last author
    authors_to_show <- c(authors[1:19], "...", authors[length(authors)])
    use_ellipsis <- TRUE
  } else {
    # Thomas not in first 20, follow standard APA: first 19 + ellipsis + last
    authors_to_show <- c(authors[1:19], "...", authors[length(authors)])
    use_ellipsis <- TRUE
  }
  
  # Highlight Ronald G. Thomas wherever he appears
  authors_to_show <- sapply(authors_to_show, function(name) {
    if (name == "...") return(name)
    if (str_detect(name, "Thomas, Ronald|Ronald.*Thomas")) {
      return(paste0("**", name, "**"))
    }
    return(name)
  })
  
  # Format according to APA style
  if (length(authors_to_show) == 1) {
    return(as.character(authors_to_show[1]))
  } else if (length(authors_to_show) == 2) {
    return(paste(authors_to_show, collapse = " & "))
  } else {
    # For 3+ authors, use commas and & before last author (unless ellipsis)
    if (use_ellipsis) {
      # When using ellipsis, don't use & before last author
      return(paste(authors_to_show, collapse = ", "))
    } else {
      # Standard format: Author1, Author2, & Author3
      last_author <- authors_to_show[length(authors_to_show)]
      other_authors <- authors_to_show[1:(length(authors_to_show)-1)]
      return(paste0(paste(other_authors, collapse = ", "), ", & ", last_author))
    }
  }
}

# Main generation function
generate_research_page <- function() {
  # Parse publications
  pubs <- parse_bibtex_basic("rgthomas_pubs_2025.bib")
  
  # Filter and process
  pubs_clean <- pubs %>%
    filter(title != "", !is.na(title)) %>%
    mutate(
      year_num = as.numeric(year),
      category = mapply(categorize_publication, title, journal, SIMPLIFY = TRUE),
      badge_color = sapply(category, get_badge_color),
      author_formatted = sapply(author, format_authors),
      topics_list = mapply(get_topics, title, keywords, SIMPLIFY = FALSE)
    ) %>%
    filter(!is.na(year_num)) %>%
    arrange(desc(year_num), title)
  
  cat("📝 Processed", nrow(pubs_clean), "publications for display\n")
  
  # Start building content
  content <- c(
    "---",
    "title: \"Research\"",
    "subtitle: \"Publications, projects, and academic work\"", 
    "page-layout: full",
    "---",
    "",
    "## Publications",
    "",
    sprintf("**%d total publications** spanning multiple research domains in biostatistics, clinical trials, and medical research.", nrow(pubs_clean)),
    "",
    "<style>",
    ".year-interval-buttons {",
    "  display: flex;",
    "  flex-wrap: wrap;",
    "  gap: 0.3rem;",
    "  margin-bottom: 0.5rem;",
    "}",
    "",
    ".year-interval {",
    "  font-size: 0.8rem;",
    "  padding: 0.3rem 0.6rem;",
    "  margin: 0.1rem;",
    "}",
    "",
    ".year-interval.active {",
    "  background-color: #0d6efd;",
    "  border-color: #0d6efd;",
    "  color: white;",
    "}",
    "",
    ".year-interval:hover {",
    "  background-color: #0b5ed7;",
    "  border-color: #0a58ca;",
    "  color: white;",
    "}",
    "",
    ".selected-years {",
    "  margin-top: 0.5rem;",
    "  font-style: italic;",
    "}",
    "</style>",
    "",
    "::: {.column-screen-inset}",
    "::: {.grid}",
    ""
  )
  
  # Add multi-column layout for years
  content <- c(content, 
    "::: {.g-col-12 .g-col-md-9}",
    "",
    "::: {.publications-content}",
    ""
  )
  
  # Group by year
  years <- unique(pubs_clean$year_num)
  years <- sort(years, decreasing = TRUE)
  
  for (year in years) {
    year_pubs <- pubs_clean[pubs_clean$year_num == year, ]
    content <- c(content, paste("###", year), "")
    
    for (i in 1:nrow(year_pubs)) {
      pub <- year_pubs[i, ]
      
      # Create tags for filtering
      all_tags <- c(pub$category, unlist(pub$topics_list))
      tag_string <- paste(all_tags, collapse = ",")
      
      # Paper entry
      content <- c(content, paste0('::: {.paper-entry data-tags="', tag_string, '"}'))
      
      # Citation
      citation_parts <- c()
      if (pub$author_formatted != "") citation_parts <- c(citation_parts, pub$author_formatted)
      citation_parts <- c(citation_parts, paste0('"', pub$title, '"'))
      if (!is.na(pub$journal) && pub$journal != "") {
        citation_parts <- c(citation_parts, paste0("*", pub$journal, "*"))
      }
      citation_parts <- c(citation_parts, paste0("(", pub$year, ")"))
      if (!is.na(pub$doi) && pub$doi != "") {
        citation_parts <- c(citation_parts, paste0("doi: ", pub$doi))
      }
      
      content <- c(content, paste(citation_parts, collapse = ", "), "")
      
      # Badges
      badges <- paste0("[", pub$category, "]{.badge .badge-", pub$badge_color, " .tag-clickable}")
      
      if (length(unlist(pub$topics_list)) > 0) {
        topic_badges <- sapply(unlist(pub$topics_list), function(topic) {
          paste0("[", topic, "]{.badge .badge-", pub$badge_color, " .tag-clickable}")
        })
        badges <- c(badges, topic_badges)
      }
      
      content <- c(content, paste(badges, collapse = " "), "")
      
      # Links
      content <- c(content, "::: {.paper-links}")
      if (!is.na(pub$doi) && pub$doi != "") {
        doi_url <- if (str_starts(pub$doi, "http")) pub$doi else paste0("https://doi.org/", pub$doi)
        content <- c(content, paste0("[🔗 Article](", doi_url, ") • [📄 PDF](", doi_url, ")"))
      } else {
        content <- c(content, "🔗 Article")
      }
      content <- c(content, ":::", ":::", "")
    }
  }
  
  # Close the main content column
  content <- c(content,
    ":::",  # Close publications-content
    ":::",  # Close g-col-12 g-col-md-9
    ""
  )
  
  # Add the sidebar (still inside the grid)
  content <- c(content,
    "::: {.g-col-12 .g-col-md-3}",
    "## 🔍 Advanced Filters",
    "",
    "### 🏷️ Quick Topic Filters",
    "",
    "**Click any badge to filter publications by research area:**",
    "",
    "[Medical/Clinical]{.badge .badge-success .tag-filter}",
    "[Military/Defense]{.badge .badge-primary .tag-filter}",
    "[Neuroimaging/Technical]{.badge .badge-info .tag-filter}",
    "[COVID/Healthcare]{.badge .badge-warning .tag-filter}",
    "[General Research]{.badge .badge-secondary .tag-filter}",
    "",
    '<button id="clear-filters" class="btn btn-sm btn-outline-secondary mt-2">Clear All Filters</button>',
    "",
    "### 📅 Publication Year",
    "",
    "::: {.year-filter-container}",
    '<div class="year-intervals">',
    '<div class="year-interval-buttons">',
    '<button class="btn btn-sm btn-outline-primary year-interval active" data-years="all">All Years</button>',
    '<button class="btn btn-sm btn-outline-primary year-interval" data-years="2020-2024">2020-2024</button>',
    '<button class="btn btn-sm btn-outline-primary year-interval" data-years="2015-2019">2015-2019</button>',
    '<button class="btn btn-sm btn-outline-primary year-interval" data-years="2010-2014">2010-2014</button>',
    '<button class="btn btn-sm btn-outline-primary year-interval" data-years="2005-2009">2005-2009</button>',
    '<button class="btn btn-sm btn-outline-primary year-interval" data-years="2000-2004">2000-2004</button>',
    '<button class="btn btn-sm btn-outline-primary year-interval" data-years="1995-1999">1995-1999</button>',
    '<button class="btn btn-sm btn-outline-primary year-interval" data-years="1990-1994">1990-1994</button>',
    '<button class="btn btn-sm btn-outline-primary year-interval" data-years="1983-1989">1983-1989</button>',
    '</div>',
    '<div class="selected-years">',
    '<small class="text-muted">Selected: <span id="year-display">All Years (1983-2024)</span></small>',
    '</div>',
    '</div>',
    ":::",
    "",
    "### 📊 Filter Summary",
    "",
    "::: {.filter-summary}",
    '<div id="filter-stats">',
    '<div class="total-pubs">Total: <span id="total-count">321</span> publications</div>',
    '<div class="filtered-pubs">Showing: <span id="filtered-count">All</span></div>',
    '<div class="active-filters">Active filters: <span id="active-filter-count">0</span></div>',
    '</div>',
    "",
    '<button id="reset-all-filters" class="btn btn-sm btn-danger mt-2 w-100">Reset All Filters</button>',
    ":::",
    ":::",  # Close g-col-12 g-col-md-3
    "",
    ":::",  # Close grid  
    ":::"   # Close column-screen-inset
  )
  
  # Add simple JavaScript for filtering
  js_code <- '
<script>
document.addEventListener("DOMContentLoaded", function() {
    console.log("Research page JavaScript loaded");
    
    let activeFilters = new Set();
    const tags = document.querySelectorAll(".tag-clickable, .tag-filter");
    const papers = document.querySelectorAll(".paper-entry");
    
    console.log("Found " + tags.length + " tags and " + papers.length + " papers");
    
    function filterPapers() {
        console.log("Filtering papers, active filters: " + activeFilters.size);
        
        if (activeFilters.size === 0) {
            papers.forEach(paper => paper.style.display = "block");
        } else {
            papers.forEach(paper => {
                const paperTags = paper.getAttribute("data-tags");
                if (paperTags) {
                    const tags = paperTags.split(",").map(tag => tag.trim());
                    const hasMatch = tags.some(tag => activeFilters.has(tag));
                    paper.style.display = hasMatch ? "block" : "none";
                } else {
                    paper.style.display = "none";
                }
            });
        }
    }
    
    // Add click handlers to all tags
    tags.forEach(tag => {
        tag.style.cursor = "pointer";
        tag.addEventListener("click", function(e) {
            e.preventDefault();
            const tagText = this.textContent.trim();
            
            console.log("Tag clicked: " + tagText);
            
            if (activeFilters.has(tagText)) {
                activeFilters.delete(tagText);
                this.style.opacity = "1";
            } else {
                activeFilters.add(tagText);
                this.style.opacity = "0.7";
            }
            
            filterPapers();
        });
    });
    
    // Initialize
    filterPapers();
});
</script>'
  
  content <- c(content, js_code)
  
  # Write file
  writeLines(content, "research/index.qmd")
  cat("✅ Generated research/index.qmd\n")
  
  # Summary stats
  cat("\n📊 Publication Summary:\n")
  cat("======================\n")
  
  # By year (top 10)
  year_counts <- pubs_clean %>% count(year_num, sort = TRUE) %>% head(10)
  cat("Top publication years:\n")
  for (i in 1:nrow(year_counts)) {
    cat(sprintf("• %d: %d publications\n", year_counts$year_num[i], year_counts$n[i]))
  }
  
  # By category
  cat("\nBy research area:\n")
  cat_counts <- pubs_clean %>% count(category, sort = TRUE)
  for (i in 1:nrow(cat_counts)) {
    cat(sprintf("• %s: %d publications\n", cat_counts$category[i], cat_counts$n[i]))
  }
  
  return(pubs_clean)
}

# Run the generation
cat("🚀 Generating research page from comprehensive bibliography...\n")
result <- generate_research_page()
cat("\n🎉 Research page generated successfully!\n")
cat("📋 Next steps:\n")
cat("1. Run 'quarto render' to rebuild the site\n")
cat("2. Check the Research tab to see all publications\n")
cat("3. Test the filtering functionality\n")