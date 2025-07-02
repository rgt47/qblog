# Simple Research Page Generator
# Process BibTeX file and create research page with basic categorization

library(dplyr)
library(stringr)

# Function to parse BibTeX manually (more robust)
parse_bibtex_simple <- function(file_path) {
  lines <- readLines(file_path)
  
  # Find entry starts
  entry_starts <- which(str_detect(lines, "^@"))
  entry_ends <- c(entry_starts[-1] - 1, length(lines))
  
  publications <- list()
  
  for (i in seq_along(entry_starts)) {
    start_line <- entry_starts[i]
    end_line <- entry_ends[i]
    entry_lines <- lines[start_line:end_line]
    
    # Extract entry type and key
    first_line <- entry_lines[1]
    entry_type <- str_extract(first_line, "(?<=@)\\w+")
    entry_key <- str_extract(first_line, "(?<={)[^,]+")
    
    # Extract fields
    entry_text <- paste(entry_lines, collapse = " ")
    
    # Extract common fields
    title <- str_extract(entry_text, "(?<=title=\\{)[^}]+(?=\\})")
    title <- str_replace_all(title, "\\{|\\}", "")
    
    author <- str_extract(entry_text, "(?<=author=\\{)[^}]+(?=\\})")
    
    year <- str_extract(entry_text, "(?<=year=\\{)[^}]+(?=\\})")
    if (is.na(year)) {
      year <- str_extract(entry_text, "(?<=year=)[0-9]{4}")
    }
    
    journal <- str_extract(entry_text, "(?<=journal=\\{)[^}]+(?=\\})")
    if (is.na(journal)) {
      journal <- str_extract(entry_text, "(?<=booktitle=\\{)[^}]+(?=\\})")
    }
    
    doi <- str_extract(entry_text, "(?<=doi=\\{)[^}]+(?=\\})")
    if (is.na(doi)) {
      doi <- str_extract(entry_text, "(?<=doi=)[^,}]+")
    }
    
    volume <- str_extract(entry_text, "(?<=volume=\\{)[^}]+(?=\\})")
    pages <- str_extract(entry_text, "(?<=pages=\\{)[^}]+(?=\\})")
    
    publications[[i]] <- list(
      key = entry_key,
      type = entry_type,
      title = title,
      author = author,
      year = as.numeric(year),
      journal = journal,
      doi = doi,
      volume = volume,
      pages = pages
    )
  }
  
  # Convert to data frame
  df <- map_dfr(publications, ~ {
    data.frame(
      key = .x$key %||% "",
      type = .x$type %||% "",
      title = .x$title %||% "",
      author = .x$author %||% "",
      year = .x$year %||% NA,
      journal = .x$journal %||% "",
      doi = .x$doi %||% "",
      volume = .x$volume %||% "",
      pages = .x$pages %||% "",
      stringsAsFactors = FALSE
    )
  })
  
  return(df)
}

# Function to categorize publications
categorize_pub <- function(title, journal) {
  title_lower <- tolower(title %||% "")
  journal_lower <- tolower(journal %||% "")
  
  if (str_detect(title_lower, "alzheimer|dementia|cognitive|clinical trial")) {
    return("Medical/Clinical")
  } else if (str_detect(title_lower, "military|veteran|blast|combat|traumatic brain")) {
    return("Military/Defense") 
  } else if (str_detect(title_lower, "imaging|pet|mri|neuroimaging|biomarker")) {
    return("Neuroimaging/Technical")
  } else if (str_detect(title_lower, "covid|pandemic|healthcare worker|sleep")) {
    return("COVID/Healthcare")
  } else {
    return("General Research")
  }
}

# Function to get badge color
get_badge_color <- function(category) {
  colors <- list(
    "Medical/Clinical" = "success",
    "Military/Defense" = "primary",
    "Neuroimaging/Technical" = "info", 
    "COVID/Healthcare" = "warning",
    "General Research" = "secondary"
  )
  return(colors[[category]] %||% "secondary")
}

# Function to extract topics for tagging
extract_topics <- function(title) {
  title_lower <- tolower(title %||% "")
  topics <- character()
  
  topic_keywords <- list(
    "Alzheimer's disease" = "alzheimer",
    "Traumatic brain injury" = "traumatic brain|tbi",
    "COVID-19" = "covid",
    "Sleep disorders" = "sleep|insomnia", 
    "Clinical trials" = "clinical trial|randomized",
    "Military health" = "military|veteran",
    "Neuroimaging" = "imaging|pet|mri",
    "Biomarkers" = "biomarker|plasma",
    "Cognitive decline" = "cognitive|memory"
  )
  
  for (topic in names(topic_keywords)) {
    if (str_detect(title_lower, topic_keywords[[topic]])) {
      topics <- c(topics, topic)
    }
  }
  
  return(topics)
}

# Function to format authors (highlight Ronald G. Thomas)
format_authors <- function(author_string) {
  if (is.na(author_string) || author_string == "") return("")
  
  # Split authors
  authors <- str_split(author_string, " and ")[[1]]
  
  # Highlight Ronald G. Thomas
  authors <- map_chr(authors, function(name) {
    if (str_detect(name, "Thomas, Ronald|Ronald.*Thomas")) {
      return(paste0("**", str_trim(name), "**"))
    }
    return(str_trim(name))
  })
  
  # Limit to first 3 authors + et al
  if (length(authors) > 3) {
    return(paste0(paste(authors[1:3], collapse = ", "), ", et al."))
  } else {
    return(paste(authors, collapse = ", "))
  }
}

# Main function
generate_research_page <- function() {
  cat("🔄 Parsing BibTeX file...\n")
  
  # Parse the bibliography
  pubs <- parse_bibtex_simple("rgthomas_cv_merged_dedup.bib")
  
  cat("✅ Parsed", nrow(pubs), "publications\n")
  
  # Process publications
  pubs_processed <- pubs %>%
    filter(!is.na(year), !is.na(title), title != "") %>%
    mutate(
      category = map2_chr(title, journal, categorize_pub),
      badge_color = map_chr(category, get_badge_color),
      topics = map(title, extract_topics),
      author_formatted = map_chr(author, format_authors),
      # Create tags for data attributes
      all_topics = map2(topics, category, ~ c(.x, .y)),
      tag_string = map_chr(all_topics, ~ paste(.x, collapse = ","))
    ) %>%
    arrange(desc(year), title)
  
  cat("✅ Processed", nrow(pubs_processed), "publications\n")
  
  # Generate content
  content <- c(
    "---",
    "title: \"Research\"", 
    "subtitle: \"Publications, projects, and academic work\"",
    "page-layout: full",
    "---", 
    "",
    "## Publications",
    "",
    sprintf("**%d publications** across multiple research domains. Use the filters below to explore by topic.", nrow(pubs_processed)),
    "",
    "::: {.callout-note}",
    "**Topic Filters:** Click any badge to filter publications by topic.",
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
  
  # Group by year and add publications
  years <- sort(unique(pubs_processed$year), decreasing = TRUE)
  
  for (year in years) {
    if (is.na(year)) next
    
    year_pubs <- pubs_processed %>% filter(year == !!year)
    content <- c(content, paste("###", year), "")
    
    for (i in 1:nrow(year_pubs)) {
      pub <- year_pubs[i, ]
      
      # Paper entry
      content <- c(content, paste0('::: {.paper-entry data-tags="', pub$tag_string, '"}'))
      
      # Citation
      citation_parts <- c(
        pub$author_formatted,
        paste0('"', pub$title, '"')
      )
      
      if (!is.na(pub$journal) && pub$journal != "") {
        citation_parts <- c(citation_parts, paste0("*", pub$journal, "*"))
      }
      
      if (!is.na(pub$volume) && pub$volume != "") {
        vol_info <- pub$volume
        if (!is.na(pub$pages) && pub$pages != "") {
          vol_info <- paste0(vol_info, ": ", pub$pages)
        }
        citation_parts <- c(citation_parts, vol_info)
      }
      
      citation_parts <- c(citation_parts, paste0("(", pub$year, ")"))
      
      if (!is.na(pub$doi) && pub$doi != "") {
        citation_parts <- c(citation_parts, paste0("doi: ", pub$doi))
      }
      
      content <- c(content, paste(citation_parts, collapse = ", "), "")
      
      # Category badge
      content <- c(content, paste0("[", pub$category, "]{.badge .badge-", pub$badge_color, " .tag-clickable}"))
      
      # Topic badges
      if (length(pub$topics[[1]]) > 0) {
        topic_badges <- map_chr(pub$topics[[1]], function(topic) {
          paste0("[", topic, "]{.badge .badge-", pub$badge_color, " .tag-clickable}")
        })
        content <- c(content, paste(topic_badges, collapse = " "))
      }
      
      content <- c(content, "", "::: {.paper-links}")
      
      # Links
      if (!is.na(pub$doi) && pub$doi != "") {
        doi_url <- ifelse(str_starts(pub$doi, "http"), pub$doi, paste0("https://doi.org/", pub$doi))
        content <- c(content, paste0("[🔗 Article](", doi_url, ") • [📄 PDF](", doi_url, ")"))
      } else {
        content <- c(content, "🔗 Article")
      }
      
      content <- c(content, ":::", ":::", "")
    }
  }
  
  # Add JavaScript
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
            } else {
                activeFilters.add(tagText);
                this.style.opacity = "0.7";
            }
            
            filterPapers();
            updateClearButton();
        });
    });
    
    clearButton.addEventListener("click", function() {
        activeFilters.clear();
        clickableTags.forEach(tag => tag.style.opacity = "1");
        filterPapers();
        updateClearButton();
    });
    
    function filterPapers() {
        if (activeFilters.size === 0) {
            paperEntries.forEach(entry => entry.style.display = "block");
        } else {
            paperEntries.forEach(entry => {
                const tags = entry.getAttribute("data-tags").split(",");
                const hasMatch = tags.some(tag => activeFilters.has(tag.trim()));
                entry.style.display = hasMatch ? "block" : "none";
            });
        }
    }
    
    function updateClearButton() {
        clearButton.style.display = activeFilters.size > 0 ? "inline-block" : "none";
        clearButton.textContent = activeFilters.size > 0 ? 
            `Clear Filters (${activeFilters.size})` : "Clear All Filters";
    }
    
    updateClearButton();
});
</script>'
  
  content <- c(content, js_code)
  
  # Write to file
  writeLines(content, "research/index.qmd")
  
  cat("✅ Generated research/index.qmd with", nrow(pubs_processed), "publications\n")
  
  # Summary
  cat("\n📊 Summary by Year:\n")
  year_counts <- pubs_processed %>% count(year, sort = TRUE) %>% head(10)
  for (i in 1:nrow(year_counts)) {
    cat(sprintf("• %d: %d publications\n", year_counts$year[i], year_counts$n[i]))
  }
  
  cat("\n📋 Summary by Category:\n")  
  cat_counts <- pubs_processed %>% count(category, sort = TRUE)
  for (i in 1:nrow(cat_counts)) {
    cat(sprintf("• %s: %d publications\n", cat_counts$category[i], cat_counts$n[i]))
  }
  
  return(pubs_processed)
}

# Run it
cat("🚀 Generating research page from 340+ publications...\n")
result <- generate_research_page()
cat("\n🎉 Complete! Check research/index.qmd\n")