#!/usr/bin/env Rscript
# Enhanced Research Page Generator
# Inspired by Andrew Heiss's design with improved categorization and layout

library(dplyr)
library(stringr)

# Enhanced BibTeX parser (reuse existing functions)
source("generate_research_final.R")


# Pre-print URL lookup function
get_preprint_url <- function(title, year) {
  # Pre-print data (from automated finder)
  preprint_data <- list(
    "Cumulative blast impulse is predictive for chan..." = list(url = "https://academic.oup.com/milmed/advance-article-pdf/doi/10.1093/milmed/usae082/57123645/usae082.pdf", source = "Unpaywall (publisher)"),
    "A public resource of baseline data from the Alz..." = list(url = "https://www.medrxiv.org/content/medrxiv/early/2023/01/28/2023.01.26.23285066.full.pdf", source = "Unpaywall (publisher)"),
    "A randomized controlled clinical trial of prazo..." = list(url = "https://link.springer.com/content/pdf/10.1007/s11606-021-07252-z.pdf", source = "Unpaywall (publisher)"),
    "Pontine pathology mediates common symptoms of b..." = list(url = "https://www.medrxiv.org/content/medrxiv/early/2023/01/28/2023.01.26.23285066.full.pdf", source = "Unpaywall (publisher)"),
    "The relative contribution of COVID-19 infection..." = list(url = "https://onlinelibrary.wiley.com/doi/pdfdirect/10.1002/alz.082317", source = "Unpaywall (publisher)"),
    "T2 Protect AD: Achieving a rapid recruitment ti..." = list(url = "https://www.nejm.org/doi/pdf/10.1056/NEJM199704243361704?articleTools=true", source = "Unpaywall (publisher)"),
    "The impact of the COVID-19 pandemic on mental h..." = list(url = "https://onlinelibrary.wiley.com/doi/pdf/10.1002/trc2.12265", source = "Unpaywall (publisher)"),
    "Optimizing aggregated N-of-1 trial designs for ..." = list(url = "https://onlinelibrary.wiley.com/doi/pdfdirect/10.1002/alz.041225", source = "Unpaywall (publisher)"),
    "Power and sample size for random coefficient re..." = list(url = "https://www.frontiersin.org/articles/10.3389/fdgth.2020.00013/pdf", source = "Unpaywall (publisher)"),
    "dummy" = list(url = "", source = "")  # Dummy entry to avoid trailing comma
  )
  
  # Look for matching title
  title_short <- str_trunc(title, 50)
  if (title_short %in% names(preprint_data)) {
    return(preprint_data[[title_short]])
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
generate_enhanced_research_page <- function() {
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
  
  # Start building enhanced content
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
    "### Research Areas",
    ""
  )
  
  # Add category overview
  for (i in 1:nrow(category_counts)) {
    cat_name <- category_counts$category[i]
    cat_count <- category_counts$n[i]
    content <- c(content, paste0("- **", cat_name, "**: ", cat_count, " publications"))
  }
  
  content <- c(content, 
    "",
    "---",
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
  
  # Group by category for better organization
  for (category in category_counts$category) {
    category_pubs <- pubs_clean[pubs_clean$category == category, ]
    
    content <- c(content, 
      paste("##", category),
      "",
      paste("*", nrow(category_pubs), "publications*"),
      ""
    )
    
    # Group by year within category
    years <- unique(category_pubs$year_num)
    years <- sort(years, decreasing = TRUE)
    
    for (year in years) {
      year_pubs <- category_pubs[category_pubs$year_num == year, ]
      
      if (nrow(year_pubs) > 0) {
        content <- c(content, paste("###", year), "")
        
        for (i in 1:nrow(year_pubs)) {
          pub <- year_pubs[i, ]
          
          # Create enhanced publication entry
          content <- c(content, 
            '```{=html}',
            paste0('<div class="publication-card" data-category="', category, '" data-year="', year, '">'),
            '```',
            ""
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
          
          # Check for pre-print availability
          preprint_info <- get_preprint_url(pub$title, pub$year)
          if (!is.null(preprint_info)) {
            source_label <- ifelse(str_detect(preprint_info$source, 'publisher'), 'Open Access PDF', 'Pre-print PDF')
            links <- c(links, paste0('[📋 ', source_label, '](', preprint_info$url, '){target="_blank"}'))
          }
          
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
    
    content <- c(content, "---", "")
  }
  
  # Close the results div
  content <- c(content, 
    '```{=html}',
    "</div>",
    '```'
  )
  
  # Add enhanced JavaScript for search and filtering
  js_code <- '
```{=html}
<style>
.publication-card {
  border: 1px solid #e9ecef;
  border-radius: 8px;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
  background: #f8f9fa;
}

.publication-card h4 {
  color: #2c3e50;
  margin-bottom: 0.8rem;
}

.publication-card code {
  background: #e3f2fd;
  color: #1565c0;
  font-size: 0.85rem;
}

#category-filter, #publication-search {
  border-radius: 6px;
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
  cat("✅ Generated enhanced research/index.qmd\n")
  
  # Summary stats
  cat("\n📊 Enhanced Publication Summary:\n")
  cat("=================================\n")
  
  # By category
  cat("By research category:\n")
  for (i in 1:nrow(category_counts)) {
    cat(sprintf("• %s: %d publications\n", category_counts$category[i], category_counts$n[i]))
  }
  
  return(pubs_clean)
}

# Run the enhanced generation
cat("🚀 Generating enhanced research page...\n")
result <- generate_enhanced_research_page()
cat("\n🎉 Enhanced research page generated successfully!\n")
cat("📋 Next steps:\n")
cat("1. Run 'quarto render research/index.qmd' to rebuild\n")
cat("2. Review the new categorized layout\n")
cat("3. Test the enhanced search and filtering\n")
