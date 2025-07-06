#!/usr/bin/env Rscript
# Fixed Research Page Generator
# Addresses issues with missing papers, blank highlights, and preprint integration

library(dplyr)
library(stringr)

# Enhanced BibTeX parser (reuse existing functions)
source("generate_research_final.R")

# Load preprint data from CSV
load_preprint_data <- function() {
  tryCatch({
    csv_file <- "preprint_search_results_20250705_172057.csv"
    if (file.exists(csv_file)) {
      preprint_df <- read.csv(csv_file, stringsAsFactors = FALSE)
      # Filter only found preprints and remove NA urls
      preprint_df <- preprint_df[preprint_df$found == TRUE & !is.na(preprint_df$url) & preprint_df$url != "", ]
      cat("📋 Loaded", nrow(preprint_df), "preprint URLs from CSV\n")
      return(preprint_df)
    }
    cat("⚠️ Preprint CSV file not found\n")
    return(data.frame())
  }, error = function(e) {
    cat("⚠️ Could not load preprint data:", e$message, "\n")
    return(data.frame())
  })
}

# Improved preprint matching function
get_preprint_url <- function(title, year) {
  # Load preprint data globally (cache it)
  if (!exists("PREPRINT_DATA")) {
    PREPRINT_DATA <<- load_preprint_data()
  }
  
  if (nrow(PREPRINT_DATA) == 0) {
    return(NULL)
  }
  
  # Clean the search title (from BibTeX)
  clean_bib_title <- tolower(str_remove_all(title, "[^a-z0-9\\s]"))
  clean_bib_title <- str_squish(clean_bib_title)
  
  # Try matching against each preprint
  for (i in 1:nrow(PREPRINT_DATA)) {
    # Clean CSV title (may be truncated with ...)
    csv_title <- PREPRINT_DATA$title[i]
    clean_csv_title <- tolower(str_remove_all(csv_title, "[^a-z0-9\\s]"))
    clean_csv_title <- str_squish(str_remove_all(clean_csv_title, "\\.+$"))  # Remove trailing dots
    
    # Method 1: Check if CSV title (truncated) is start of BibTeX title
    if (str_starts(clean_bib_title, clean_csv_title)) {
      return(list(url = PREPRINT_DATA$url[i], source = PREPRINT_DATA$source[i]))
    }
    
    # Method 2: Word-based matching for cases where titles are reordered
    bib_words <- str_split(clean_bib_title, "\\s+")[[1]]
    csv_words <- str_split(clean_csv_title, "\\s+")[[1]]
    
    # CSV words must match at least 80% of CSV words in BibTeX title
    if (length(csv_words) >= 5) {  # Only for substantial titles
      matches <- sum(csv_words %in% bib_words)
      threshold <- length(csv_words) * 0.8
      
      if (matches >= threshold) {
        return(list(url = PREPRINT_DATA$url[i], source = PREPRINT_DATA$source[i]))
      }
    }
  }
  
  return(NULL)
}

# Enhanced categorization function
categorize_publication_enhanced <- function(title, journal, year, keywords) {
  title_lower <- tolower(title %||% "")
  journal_lower <- tolower(journal %||% "")
  keywords_lower <- tolower(keywords %||% "")
  year_num <- as.numeric(year %||% 2000)
  
  # Primary categorization
  if (str_detect(title_lower, "alzheimer|dementia|cognitive|clinical trial|drug|treatment") ||
      str_detect(keywords_lower, "alzheimer|clinical trial")) {
    return("Medical/Clinical Research")
  } else if (str_detect(title_lower, "military|veteran|blast|combat|traumatic brain|tbi") ||
             str_detect(keywords_lower, "military|veteran")) {
    return("Military/Defense Research")
  } else if (str_detect(title_lower, "imaging|pet|mri|neuroimaging|biomarker|fdg") ||
             str_detect(keywords_lower, "neuroimaging|biomarker")) {
    return("Neuroimaging/Biomarkers")
  } else if (str_detect(title_lower, "covid|pandemic|healthcare worker|sleep|insomnia") ||
             str_detect(keywords_lower, "covid|pandemic")) {
    return("Public Health/COVID")
  } else if (str_detect(title_lower, "statistical|method|analysis|model") ||
             str_detect(keywords_lower, "statistical|biostatistics")) {
    return("Statistical Methods")
  } else if (year_num >= 2020) {
    return("Recent Research")
  } else {
    return("Earlier Research")
  }
}

# Function to create publication summary
create_publication_summary <- function(title, category) {
  title_lower <- tolower(title)
  
  # Create concise summaries based on content
  if (str_detect(title_lower, "alzheimer|dementia")) {
    return("Advancing understanding of neurodegenerative diseases through clinical research")
  } else if (str_detect(title_lower, "military|blast|veteran")) {
    return("Investigating health impacts in military populations and combat environments")
  } else if (str_detect(title_lower, "covid|pandemic")) {
    return("Addressing public health challenges during global health crises")
  } else if (str_detect(title_lower, "imaging|pet|mri")) {
    return("Developing biomarkers and imaging techniques for disease detection")
  } else if (str_detect(title_lower, "trial|treatment|drug")) {
    return("Evaluating therapeutic interventions through rigorous clinical trials")
  } else {
    return("Contributing to evidence-based medicine and biostatistical research")
  }
}

# Enhanced research page generator
generate_fixed_research_page <- function() {
  # Clear global preprint data cache
  if (exists("PREPRINT_DATA")) {
    rm(PREPRINT_DATA, envir = .GlobalEnv)
  }
  
  # Parse publications
  pubs <- parse_bibtex_basic("rgthomas_pubs_2025.bib")
  
  # Enhanced processing
  pubs_clean <- pubs %>%
    filter(title != "", !is.na(title)) %>%
    mutate(
      year_num = as.numeric(year),
      category = mapply(categorize_publication_enhanced, title, journal, year, keywords, SIMPLIFY = TRUE),
      author_formatted = sapply(author, format_authors),
      topics_list = mapply(get_topics, title, keywords, SIMPLIFY = FALSE),
      summary = mapply(create_publication_summary, title, category, SIMPLIFY = TRUE)
    ) %>%
    filter(!is.na(year_num)) %>%
    arrange(desc(year_num), title)
  
  cat("📝 Processed", nrow(pubs_clean), "publications for enhanced display\n")
  
  # Count by category
  category_counts <- pubs_clean %>% count(category, sort = TRUE)
  
  # Start building enhanced content (without category list)
  content <- c(
    "---",
    "title: \"Research\"",
    "subtitle: \"Publications, projects, and academic contributions\"", 
    "page-layout: full",
    "number-sections: false",
    "---",
    "",
    "## Publications & Research",
    "",
    sprintf("**%d total publications** spanning multiple research domains in biostatistics, clinical trials, and medical research.", nrow(pubs_clean)),
    "",
    "### Search Publications",
    "",
    "Use the search box below to filter publications by title, author, journal, topic, or year.",
    "",
    '```{=html}',
    '<div class="row mb-4">',
    '  <div class="col-md-8">',
    '    <div class="input-group">',
    '      <span class="input-group-text"><i class="bi bi-search"></i></span>',
    '      <input type="text" class="form-control" id="publication-search" placeholder="Search publications by keyword, author, title, or year...">',
    '    </div>',
    '  </div>',
    '  <div class="col-md-4">',
    '    <select class="form-select" id="category-filter">',
    '      <option value="">All Categories</option>'
  )
  
  # Add category filter options
  for (i in 1:nrow(category_counts)) {
    cat_name <- category_counts$category[i]
    cat_count <- category_counts$n[i]
    content <- c(content, paste0('      <option value="', cat_name, '">', cat_name, ' (', cat_count, ')</option>'))
  }
  
  content <- c(content,
    '    </select>',
    '  </div>',
    '</div>',
    '<div id="publication-results">',
    '```',
    ""
  )
  
  # Track preprint matches for debugging
  preprint_matches <- 0
  
  # Simple chronological organization by year (no category grouping)
  years <- unique(pubs_clean$year_num)
  years <- sort(years, decreasing = TRUE)
  
  for (year in years) {
    year_pubs <- pubs_clean[pubs_clean$year_num == year, ]
    
    if (nrow(year_pubs) > 0) {
      content <- c(content, paste("##", year), "")
      
      for (i in 1:nrow(year_pubs)) {
        pub <- year_pubs[i, ]
        
        # Start publication card
        content <- c(content, 
          '```{=html}',
          paste0('<div class="publication-card" data-category="', pub$category, '" data-year="', year, '">'),
          '```'
        )
        
        # Title as header
        content <- c(content, paste0("#### ", pub$title))
        
        # Authors and journal
        citation_parts <- c()
        if (pub$author_formatted != "") citation_parts <- c(citation_parts, pub$author_formatted)
        if (!is.na(pub$journal) && pub$journal != "") {
          citation_parts <- c(citation_parts, paste0("*", pub$journal, "*"))
        }
        citation_parts <- c(citation_parts, paste0("(", pub$year, ")"))
        
        content <- c(content, paste(citation_parts, collapse = " | "), "")
        
        # Summary
        content <- c(content, paste0("**Summary**: ", pub$summary), "")
        
        # Topics/Keywords
        all_topics <- c(unlist(pub$topics_list))
        if (length(all_topics) > 0) {
          topic_badges <- sapply(all_topics, function(topic) {
            paste0("`", topic, "`")
          })
          content <- c(content, paste("**Topics**:", paste(topic_badges, collapse = " ")), "")
        }
        
        # Links
        links <- c()
        if (!is.na(pub$doi) && pub$doi != "") {
          doi_url <- if (str_starts(pub$doi, "http")) pub$doi else paste0("https://doi.org/", pub$doi)
          links <- c(links, paste0("[📄 Article](", doi_url, "){target=\"_blank\"}"))
        }
        
        # Check for pre-print availability with improved matching
        preprint_info <- get_preprint_url(pub$title, pub$year)
        if (!is.null(preprint_info)) {
          preprint_matches <- preprint_matches + 1
          source_label <- ifelse(str_detect(preprint_info$source, 'publisher'), 'Open Access PDF', 'Pre-print PDF')
          links <- c(links, paste0('[📋 ', source_label, '](', preprint_info$url, '){target="_blank"}'))
          cat("  ✅ Matched preprint for:", str_trunc(pub$title, 50), "\n")
        }
        
        if (length(links) > 0) {
          content <- c(content, paste("**Links**:", paste(links, collapse = " • ")), "")
        }
        
        # Close publication card
        content <- c(content, 
          "",
          '```{=html}',
          "</div>",
          '```',
          ""
        )
      }
    }
  }
  
  # Close the results div
  content <- c(content, 
    '```{=html}',
    "</div>",
    '```'
  )
  
  # Add simplified CSS with reliable highlighting
  js_code <- '
```{=html}
<style>
/* Simple, reliable highlighting for ALL publication cards */
.publication-card {
  border-left: 4px solid #3498db;
  border-radius: 0 8px 8px 0;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
  background: #f8f9fa;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  transition: all 0.3s ease;
}

.publication-card:hover {
  border-left-color: #2980b9;
  box-shadow: 0 4px 8px rgba(0,0,0,0.15);
  transform: translateX(2px);
}

.publication-card h4 {
  color: #2c3e50;
  margin-bottom: 0.8rem;
  margin-top: 0;
}

.publication-card code {
  background: #e3f2fd;
  color: #1565c0;
  font-size: 0.85rem;
}

#category-filter, #publication-search {
  border-radius: 6px;
}

/* Remove all section numbering */
.header-section-number {
  display: none !important;
}

/* Ensure clean headers without numbers */
h2::before, h3::before, h4::before {
  content: none !important;
}
</style>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const searchInput = document.getElementById("publication-search");
    const categoryFilter = document.getElementById("category-filter");
    const publicationCards = document.querySelectorAll(".publication-card");
    
    function filterPublications() {
        const searchTerm = searchInput.value.toLowerCase();
        const selectedCategory = categoryFilter.value;
        let visibleCount = 0;
        
        publicationCards.forEach(card => {
            const text = card.textContent.toLowerCase();
            const cardCategory = card.getAttribute("data-category");
            
            const matchesSearch = text.includes(searchTerm);
            const matchesCategory = selectedCategory === "" || cardCategory === selectedCategory;
            
            if (matchesSearch && matchesCategory) {
                card.style.display = "block";
                visibleCount++;
            } else {
                card.style.display = "none";
            }
        });
        
        // Update category headings visibility
        const categoryHeadings = document.querySelectorAll("h2");
        categoryHeadings.forEach(heading => {
            const categoryName = heading.textContent.trim();
            const categoryCards = Array.from(publicationCards).filter(card => 
                card.getAttribute("data-category") === categoryName && 
                card.style.display !== "none"
            );
            
            // Show/hide the entire section
            let currentElement = heading;
            let hasVisibleCards = categoryCards.length > 0;
            
            // Toggle heading and all content until next h2
            while (currentElement && !currentElement.nextElementSibling?.matches("h2")) {
                currentElement.style.display = hasVisibleCards ? "block" : "none";
                currentElement = currentElement.nextElementSibling;
                if (!currentElement) break;
            }
            if (currentElement?.nextElementSibling?.matches("h2")) {
                // We stopped before the next h2, so show/hide the current element too
                currentElement.style.display = hasVisibleCards ? "block" : "none";
            }
        });
    }
    
    searchInput.addEventListener("input", filterPublications);
    categoryFilter.addEventListener("change", filterPublications);
});
</script>
```'
  
  content <- c(content, js_code)
  
  # Write file
  writeLines(content, "research/index.qmd")
  cat("✅ Generated FIXED research/index.qmd\n")
  
  # Summary stats
  cat("\n📊 Fixed Research Page Summary:\n")
  cat("===============================\n")
  cat("Total publications processed:", nrow(pubs_clean), "\n")
  cat("Preprint matches found:", preprint_matches, "\n")
  
  # By category
  cat("\nBy research category:\n")
  for (i in 1:nrow(category_counts)) {
    cat(sprintf("• %s: %d publications\n", category_counts$category[i], category_counts$n[i]))
  }
  
  return(pubs_clean)
}

# Run the fixed generation
cat("🚀 Generating FIXED research page...\n")
cat("   - Improved preprint matching\n")
cat("   - Fixed blank line highlighting\n")
cat("   - Better publication coverage\n\n")

result <- generate_fixed_research_page()
cat("\n🎉 FIXED research page generated successfully!\n")
cat("📋 Next steps:\n")
cat("1. Run 'quarto render research/index.qmd' to rebuild\n")
cat("2. Review the improved layout and preprint integration\n")
cat("3. Check that all papers appear and highlight bars work correctly\n")