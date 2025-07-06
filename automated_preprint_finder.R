#!/usr/bin/env Rscript
# Automated Pre-print Finder
# Searches multiple online sources for freely available versions of publications

library(httr)
library(jsonlite)
library(stringr)
library(dplyr)
library(xml2)

# Source the existing BibTeX parser
source("generate_research_final.R")

# Function to search bioRxiv
search_biorxiv <- function(title, authors = "") {
  tryCatch({
    # Clean title for search
    clean_title <- str_remove_all(title, "[{}\"']")
    clean_title <- str_replace_all(clean_title, "[^A-Za-z0-9\\s]", " ")
    clean_title <- str_squish(clean_title)
    
    # bioRxiv search API
    search_query <- clean_title
    url <- "https://api.biorxiv.org/details/biorxiv"
    
    # Use a more direct approach - search by title keywords
    response <- GET("https://www.biorxiv.org/search/", 
                    query = list(
                      abstract_title = clean_title,
                      abstract_title_flags = "match-phrase",
                      numresults = 5,
                      sort = "relevance-rank",
                      format_result = "standard"
                    ),
                    timeout(10))
    
    if (status_code(response) == 200) {
      # Parse the response to look for PDF links
      content_text <- content(response, "text", encoding = "UTF-8")
      
      # Look for bioRxiv DOI patterns in the response
      biorxiv_pattern <- "https://www\\.biorxiv\\.org/content/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}\\.[0-9]{2}\\.[0-9]{2}\\.[0-9]{6}"
      matches <- str_extract_all(content_text, biorxiv_pattern)[[1]]
      
      if (length(matches) > 0) {
        pdf_url <- paste0(matches[1], ".full.pdf")
        return(list(found = TRUE, url = pdf_url, source = "bioRxiv"))
      }
    }
    
    return(list(found = FALSE, url = NA, source = "bioRxiv"))
    
  }, error = function(e) {
    return(list(found = FALSE, url = NA, source = "bioRxiv", error = as.character(e)))
  })
}

# Function to search arXiv
search_arxiv <- function(title, authors = "") {
  tryCatch({
    clean_title <- str_remove_all(title, "[{}\"']")
    clean_title <- str_replace_all(clean_title, "[^A-Za-z0-9\\s]", " ")
    clean_title <- str_squish(clean_title)
    
    # arXiv API search
    base_url <- "http://export.arxiv.org/api/query"
    search_query <- paste0('ti:"', clean_title, '"')
    
    response <- GET(base_url, 
                    query = list(
                      search_query = search_query,
                      start = 0,
                      max_results = 5
                    ),
                    timeout(10))
    
    if (status_code(response) == 200) {
      content_xml <- content(response, "text", encoding = "UTF-8")
      
      # Parse XML response
      doc <- read_xml(content_xml)
      entries <- xml_find_all(doc, ".//entry")
      
      if (length(entries) > 0) {
        # Get the first entry's PDF link
        entry <- entries[1]
        links <- xml_find_all(entry, ".//link[@type='application/pdf']")
        
        if (length(links) > 0) {
          pdf_url <- xml_attr(links[1], "href")
          return(list(found = TRUE, url = pdf_url, source = "arXiv"))
        }
      }
    }
    
    return(list(found = FALSE, url = NA, source = "arXiv"))
    
  }, error = function(e) {
    return(list(found = FALSE, url = NA, source = "arXiv", error = as.character(e)))
  })
}

# Function to search PubMed Central
search_pmc <- function(title, authors = "", doi = "") {
  tryCatch({
    # If we have a DOI, we can check PMC directly
    if (!is.na(doi) && doi != "") {
      # Clean DOI
      clean_doi <- str_remove(doi, "^https?://doi\\.org/")
      
      # PMC OA Service API
      pmc_url <- "https://www.ncbi.nlm.nih.gov/pmc/utils/oa/oa.fcgi"
      response <- GET(pmc_url, 
                      query = list(id = paste0("DOI:", clean_doi)),
                      timeout(10))
      
      if (status_code(response) == 200) {
        content_xml <- content(response, "text", encoding = "UTF-8")
        
        # Check if there's a PDF link in the response
        if (str_detect(content_xml, "format=\"pdf\"")) {
          # Extract PMC ID and construct PDF URL
          pmc_match <- str_extract(content_xml, "PMC[0-9]+")
          if (!is.na(pmc_match)) {
            pdf_url <- paste0("https://www.ncbi.nlm.nih.gov/pmc/articles/", pmc_match, "/pdf/")
            return(list(found = TRUE, url = pdf_url, source = "PMC"))
          }
        }
      }
    }
    
    return(list(found = FALSE, url = NA, source = "PMC"))
    
  }, error = function(e) {
    return(list(found = FALSE, url = NA, source = "PMC", error = as.character(e)))
  })
}

# Function to search ResearchGate (limited - requires scraping)
search_researchgate <- function(title, authors = "") {
  tryCatch({
    clean_title <- str_remove_all(title, "[{}\"']")
    clean_title <- str_replace_all(clean_title, "[^A-Za-z0-9\\s]", " ")
    clean_title <- str_squish(clean_title)
    
    # ResearchGate search URL
    search_url <- "https://www.researchgate.net/search"
    response <- GET(search_url, 
                    query = list(q = clean_title),
                    timeout(10))
    
    if (status_code(response) == 200) {
      content_text <- content(response, "text", encoding = "UTF-8")
      
      # Look for PDF download links (this is simplified - RG has anti-scraping measures)
      if (str_detect(content_text, "pdf") && str_detect(content_text, clean_title)) {
        return(list(found = TRUE, url = "ResearchGate (manual check required)", source = "ResearchGate"))
      }
    }
    
    return(list(found = FALSE, url = NA, source = "ResearchGate"))
    
  }, error = function(e) {
    return(list(found = FALSE, url = NA, source = "ResearchGate", error = as.character(e)))
  })
}

# Function to check Unpaywall API
search_unpaywall <- function(doi, email = "research@example.com") {
  tryCatch({
    if (is.na(doi) || doi == "") {
      return(list(found = FALSE, url = NA, source = "Unpaywall"))
    }
    
    # Clean DOI
    clean_doi <- str_remove(doi, "^https?://doi\\.org/")
    
    # Unpaywall API
    unpaywall_url <- paste0("https://api.unpaywall.org/v2/", clean_doi)
    response <- GET(unpaywall_url, 
                    query = list(email = email),
                    timeout(10))
    
    if (status_code(response) == 200) {
      data <- content(response, "parsed")
      
      if (!is.null(data$is_oa) && data$is_oa == TRUE) {
        # Look for best OA location
        if (!is.null(data$best_oa_location) && !is.null(data$best_oa_location$url_for_pdf)) {
          pdf_url <- data$best_oa_location$url_for_pdf
          host_type <- ifelse(!is.null(data$best_oa_location$host_type), 
                             data$best_oa_location$host_type, "repository")
          return(list(found = TRUE, url = pdf_url, source = paste0("Unpaywall (", host_type, ")")))
        }
      }
    }
    
    return(list(found = FALSE, url = NA, source = "Unpaywall"))
    
  }, error = function(e) {
    return(list(found = FALSE, url = NA, source = "Unpaywall", error = as.character(e)))
  })
}

# Main function to find pre-prints for all publications
find_all_preprints <- function(max_entries = 20, email = "research@example.com") {
  cat("🔍 Automated Pre-print Finder\n")
  cat("===============================\n\n")
  
  # Parse publications
  pubs <- parse_bibtex_basic("rgthomas_pubs_2025.bib")
  
  # Filter and prepare
  pubs_clean <- pubs %>%
    filter(title != "", !is.na(title)) %>%
    mutate(year_num = as.numeric(year)) %>%
    filter(!is.na(year_num)) %>%
    arrange(desc(year_num), title) %>%
    head(max_entries)  # Limit for testing
  
  cat("📚 Checking", nrow(pubs_clean), "recent publications for pre-prints...\n\n")
  
  results <- data.frame(
    title = character(),
    year = character(),
    source = character(),
    found = logical(),
    url = character(),
    stringsAsFactors = FALSE
  )
  
  for (i in 1:nrow(pubs_clean)) {
    pub <- pubs_clean[i, ]
    
    # Enhanced progress reporting for long runs
    if (i %% 10 == 1 || i <= 10) {
      cat("📄", i, "/", nrow(pubs_clean), ":", str_trunc(pub$title, 50), "(", pub$year, ")\n")
    } else if (i %% 10 == 0) {
      cat("   ⏱️ Processed", i, "publications... (", round(i/nrow(pubs_clean)*100, 1), "% complete)\n")
    }
    
    # Try multiple sources
    sources_to_try <- list(
      unpaywall = function() search_unpaywall(pub$doi, email),
      pmc = function() search_pmc(pub$title, pub$author, pub$doi),
      biorxiv = function() search_biorxiv(pub$title, pub$author),
      arxiv = function() search_arxiv(pub$title, pub$author)
    )
    
    found_any <- FALSE
    
    for (source_name in names(sources_to_try)) {
      source_func <- sources_to_try[[source_name]]
      result <- source_func()
      
      if (result$found) {
        cat("   ✅", result$source, ":", result$url, "\n")
        results <- rbind(results, data.frame(
          title = str_trunc(pub$title, 80),
          year = pub$year,
          source = result$source,
          found = TRUE,
          url = result$url,
          stringsAsFactors = FALSE
        ))
        found_any <- TRUE
        break  # Stop at first successful find
      }
    }
    
    if (!found_any) {
      cat("   ❌ No pre-print found\n")
      results <- rbind(results, data.frame(
        title = str_trunc(pub$title, 80),
        year = pub$year,
        source = "None",
        found = FALSE,
        url = NA,
        stringsAsFactors = FALSE
      ))
    }
    
    # Rate limiting to be respectful
    Sys.sleep(1)
  }
  
  # Summary
  cat("\n📊 Pre-print Search Summary:\n")
  cat("=============================\n")
  found_count <- sum(results$found)
  total_count <- nrow(results)
  cat("Pre-prints found:", found_count, "/", total_count, "(", round(found_count/total_count*100, 1), "%)\n\n")
  
  # By source
  if (found_count > 0) {
    cat("Sources found:\n")
    source_summary <- results %>% 
      filter(found) %>% 
      count(source, sort = TRUE)
    
    for (i in 1:nrow(source_summary)) {
      cat("•", source_summary$source[i], ":", source_summary$n[i], "pre-prints\n")
    }
  }
  
  # Save results
  results_file <- paste0("preprint_search_results_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".csv")
  write.csv(results, results_file, row.names = FALSE)
  cat("\n💾 Detailed results saved to:", results_file, "\n")
  
  return(results)
}

# Run the search
cat("🚀 Starting COMPREHENSIVE automated pre-print search...\n")
cat("   Checking multiple sources: Unpaywall, PMC, bioRxiv, arXiv\n")
cat("   Processing ALL publications (~328 entries)\n")
cat("   This will take about 15-20 minutes with respectful rate limiting\n")
cat("   Progress will be shown every 10 publications\n\n")

# Process ALL publications for comprehensive coverage
results <- find_all_preprints(max_entries = 999, email = "research@thomaslab.org")

cat("\n🎯 Next Steps:\n")
cat("1. Review the CSV file for detailed results\n")
cat("2. Manually verify promising URLs before adding to research page\n")
cat("3. Use the add_preprint.sh script to safely add verified pre-prints\n")
cat("4. Update research page generator to include pre-print links\n")