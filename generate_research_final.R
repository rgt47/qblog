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
  
  # Start building content with simple structure and search box
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
    "Use the search box below to filter publications by title, author, journal, or research topic.",
    "",
    '<div class="input-group mb-3">',
    '  <span class="input-group-text"><i class="bi bi-search"></i></span>',
    '  <input type="text" class="form-control" id="publication-search" placeholder="Search publications...">',
    '</div>',
    "",
    '<div id="publication-results">',
    ""
  )
  
  # Add publications content section
  content <- c(content, "")
  
  # Group by year
  years <- unique(pubs_clean$year_num)
  years <- sort(years, decreasing = TRUE)
  
  for (year in years) {
    year_pubs <- pubs_clean[pubs_clean$year_num == year, ]
    content <- c(content, paste("###", year), "")
    
    for (i in 1:nrow(year_pubs)) {
      pub <- year_pubs[i, ]
      
      # Create searchable topics
      all_topics <- c(pub$category, unlist(pub$topics_list))
      topics_text <- paste(all_topics, collapse = " • ")
      
      # Simple paper entry
      content <- c(content, '<div class="publication-entry">')
      
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
      
      # Topics (no longer clickable, just for display)
      if (topics_text != "") {
        content <- c(content, paste0("**Topics:** ", topics_text), "")
      }
      
      # Links
      if (!is.na(pub$doi) && pub$doi != "") {
        doi_url <- if (str_starts(pub$doi, "http")) pub$doi else paste0("https://doi.org/", pub$doi)
        content <- c(content, paste0("[🔗 Article](", doi_url, "){target=\"_blank\"}"))
      }
      content <- c(content, "</div>", "")
    }
  }
  
  # Close the results div
  content <- c(content, "</div>")  # Close publication-results
  
  # Add simple text search JavaScript
  js_code <- '
```{=html}
<script>
document.addEventListener("DOMContentLoaded", function() {
    const searchInput = document.getElementById("publication-search");
    const publicationEntries = document.querySelectorAll(".publication-entry");
    
    function filterPublications() {
        const searchTerm = searchInput.value.toLowerCase();
        let visibleCount = 0;
        
        publicationEntries.forEach(entry => {
            const text = entry.textContent.toLowerCase();
            if (text.includes(searchTerm)) {
                entry.style.display = "block";
                visibleCount++;
            } else {
                entry.style.display = "none";
            }
        });
        
        // Update year headings visibility
        const yearHeadings = document.querySelectorAll("h3");
        yearHeadings.forEach(heading => {
            const nextElements = [];
            let nextElement = heading.nextElementSibling;
            
            // Collect all publication entries under this heading
            while (nextElement && !nextElement.matches("h3")) {
                if (nextElement.classList.contains("publication-entry")) {
                    nextElements.push(nextElement);
                }
                nextElement = nextElement.nextElementSibling;
            }
            
            // Show/hide heading based on visible publications
            const hasVisiblePubs = nextElements.some(el => el.style.display !== "none");
            heading.style.display = hasVisiblePubs ? "block" : "none";
        });
    }
    
    searchInput.addEventListener("input", filterPublications);
});
</script>
```'
  
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