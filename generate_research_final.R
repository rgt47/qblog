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

# Format authors
format_authors <- function(author_string) {
  if (is.na(author_string) || author_string == "") return("")
  
  # Split by "and"
  authors <- str_split(author_string, " and ")[[1]]
  authors <- str_trim(authors)
  
  # Highlight Ronald G. Thomas
  authors <- sapply(authors, function(name) {
    if (str_detect(name, "Thomas, Ronald|Ronald.*Thomas")) {
      return(paste0("**", name, "**"))
    }
    return(name)
  })
  
  # Limit authors
  if (length(authors) > 3) {
    return(paste0(paste(authors[1:3], collapse = ", "), ", et al."))
  } else {
    return(paste(authors, collapse = ", "))
  }
}

# Main generation function
generate_research_page <- function() {
  # Parse publications
  pubs <- parse_bibtex_basic("rgthomas_cv_merged_dedup.bib")
  
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
    "::: {.callout-note}",
    "**Filter by Topic:** Click any badge below to filter publications by research area.",
    "",
    "[Medical/Clinical]{.badge .badge-success .tag-filter}",
    "[Military/Defense]{.badge .badge-primary .tag-filter}",
    "[Neuroimaging/Technical]{.badge .badge-info .tag-filter}",
    "[COVID/Healthcare]{.badge .badge-warning .tag-filter}",
    "[General Research]{.badge .badge-secondary .tag-filter}",
    "",
    '<button id="clear-filters" class="btn btn-sm btn-outline-secondary mt-2">Clear All Filters</button>',
    ":::",
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
  
  # Add JavaScript for filtering
  js_code <- '
<script>
document.addEventListener("DOMContentLoaded", function() {
    let activeFilters = new Set();
    const tags = document.querySelectorAll(".tag-clickable, .tag-filter");
    const clearBtn = document.getElementById("clear-filters");
    const papers = document.querySelectorAll(".paper-entry");
    
    tags.forEach(tag => {
        tag.style.cursor = "pointer";
        tag.addEventListener("click", function(e) {
            e.preventDefault();
            const tagText = this.textContent.trim();
            
            if (activeFilters.has(tagText)) {
                activeFilters.delete(tagText);
                this.style.opacity = "1";
            } else {
                activeFilters.add(tagText);
                this.style.opacity = "0.7";
            }
            
            filterPapers();
            updateClearButton();
        });
    });
    
    clearBtn.addEventListener("click", function() {
        activeFilters.clear();
        tags.forEach(tag => tag.style.opacity = "1");
        filterPapers();
        updateClearButton();
    });
    
    function filterPapers() {
        if (activeFilters.size === 0) {
            papers.forEach(paper => paper.style.display = "block");
        } else {
            papers.forEach(paper => {
                const paperTags = paper.getAttribute("data-tags").split(",");
                const hasMatch = paperTags.some(tag => activeFilters.has(tag.trim()));
                paper.style.display = hasMatch ? "block" : "none";
            });
        }
    }
    
    function updateClearButton() {
        if (activeFilters.size > 0) {
            clearBtn.style.display = "inline-block";
            clearBtn.textContent = `Clear Filters (${activeFilters.size})`;
        } else {
            clearBtn.style.display = "none";
        }
    }
    
    updateClearButton();
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