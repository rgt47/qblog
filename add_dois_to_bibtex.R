#!/usr/bin/env Rscript
# Add DOIs to BibTeX entries
# This script searches for DOIs using the Crossref API and adds them to publications

library(httr)
library(jsonlite)
library(stringr)
library(dplyr)

# Function to search for DOI using Crossref API
search_doi <- function(title, author, year) {
  # Clean title for search
  clean_title <- str_remove_all(title, "[{}\"']")
  clean_title <- str_replace_all(clean_title, "[^A-Za-z0-9\\s]", " ")
  clean_title <- str_squish(clean_title)
  
  # Get first author surname for search
  if (!is.na(author) && author != "") {
    first_author <- str_extract(author, "^[^,]+")
    first_author <- str_remove_all(first_author, "[^A-Za-z\\s]")
    first_author <- str_squish(first_author)
  } else {
    first_author <- ""
  }
  
  # Build search query
  query_parts <- c()
  if (clean_title != "") query_parts <- c(query_parts, clean_title)
  if (first_author != "") query_parts <- c(query_parts, first_author)
  if (!is.na(year) && year != "") query_parts <- c(query_parts, year)
  
  query <- paste(query_parts, collapse = " ")
  
  cat("🔍 Searching for:", str_trunc(query, 60), "\n")
  
  # Search Crossref API
  tryCatch({
    url <- "https://api.crossref.org/works"
    response <- GET(url, query = list(
      query = query,
      rows = 5,
      sort = "relevance"
    ))
    
    if (status_code(response) == 200) {
      data <- content(response, "text", encoding = "UTF-8")
      json_data <- fromJSON(data)
      
      if (length(json_data$message$items) > 0) {
        # Check each result for title similarity
        for (i in 1:min(3, length(json_data$message$items))) {
          item <- json_data$message$items[i, ]
          
          if (!is.null(item$title) && length(item$title) > 0) {
            api_title <- tolower(item$title[1])
            search_title <- tolower(clean_title)
            
            # Simple similarity check - look for key words
            title_words <- str_split(search_title, "\\s+")[[1]]
            title_words <- title_words[nchar(title_words) > 3]  # Only longer words
            
            if (length(title_words) > 0) {
              matches <- sum(sapply(title_words, function(word) str_detect(api_title, word)))
              similarity <- matches / length(title_words)
              
              cat("   📝 Found:", str_trunc(item$title[1], 50), "\n")
              cat("   📊 Similarity:", round(similarity * 100, 1), "%\n")
              
              # If we find a good match, return the DOI
              if (similarity > 0.5 && !is.null(item$DOI)) {
                cat("   ✅ DOI found:", item$DOI, "\n")
                return(item$DOI)
              }
            }
          }
        }
      }
    }
    
    cat("   ❌ No suitable DOI found\n")
    return(NA)
    
  }, error = function(e) {
    cat("   ⚠️ API error:", e$message, "\n")
    return(NA)
  })
}

# Function to add DOI to BibTeX entry
add_doi_to_entry <- function(entry_text, doi) {
  # Find the closing brace of the entry
  lines <- str_split(entry_text, "\n")[[1]]
  
  # Find where to insert DOI (before the closing brace)
  closing_brace_line <- which(str_detect(lines, "^\\s*}\\s*$"))
  
  if (length(closing_brace_line) > 0) {
    insert_line <- closing_brace_line[1] - 1
    
    # Add DOI field
    doi_field <- paste0("doi = {", doi, "},")
    
    # Insert the DOI field
    new_lines <- c(
      lines[1:insert_line],
      doi_field,
      lines[(insert_line + 1):length(lines)]
    )
    
    return(paste(new_lines, collapse = "\n"))
  }
  
  return(entry_text)
}

# Main function
add_dois_to_bibtex <- function(bibtex_file) {
  cat("🚀 Starting DOI lookup for", bibtex_file, "\n")
  cat("📖 Reading BibTeX file...\n")
  
  # Read the file
  lines <- readLines(bibtex_file, warn = FALSE)
  content <- paste(lines, collapse = "\n")
  
  # Find entry boundaries
  entry_starts <- str_locate_all(content, "@\\w+\\{")[[1]]
  
  if (nrow(entry_starts) == 0) {
    cat("❌ No BibTeX entries found\n")
    return()
  }
  
  cat("📚 Found", nrow(entry_starts), "BibTeX entries\n")
  
  # Process each entry
  updated_content <- content
  dois_added <- 0
  dois_skipped <- 0
  
  for (i in nrow(entry_starts):1) {  # Reverse order to maintain positions
    start_pos <- entry_starts[i, "start"]
    
    # Find the end of this entry
    if (i < nrow(entry_starts)) {
      end_pos <- entry_starts[i + 1, "start"] - 1
    } else {
      end_pos <- nchar(content)
    }
    
    entry_text <- str_sub(content, start_pos, end_pos)
    
    # Check if this entry already has a DOI
    if (str_detect(entry_text, "doi\\s*=")) {
      dois_skipped <- dois_skipped + 1
      next
    }
    
    # Extract title, author, year
    title_match <- str_match(entry_text, "title\\s*=\\s*\\{([^}]+)\\}")
    author_match <- str_match(entry_text, "author\\s*=\\s*\\{([^}]+)\\}")
    year_match <- str_match(entry_text, "year\\s*=\\s*\\{([^}]+)\\}")
    
    title <- if (!is.na(title_match[1, 2])) title_match[1, 2] else ""
    author <- if (!is.na(author_match[1, 2])) author_match[1, 2] else ""
    year <- if (!is.na(year_match[1, 2])) year_match[1, 2] else ""
    
    if (title == "") {
      cat("⚠️ Skipping entry without title\n")
      next
    }
    
    # Search for DOI
    doi <- search_doi(title, author, year)
    
    if (!is.na(doi)) {
      # Add DOI to the entry
      updated_entry <- add_doi_to_entry(entry_text, doi)
      
      # Replace in the full content
      updated_content <- str_replace(updated_content, fixed(entry_text), updated_entry)
      dois_added <- dois_added + 1
      
      cat("✅ Added DOI to:", str_trunc(title, 50), "\n")
    }
    
    # Rate limiting - be nice to the API
    Sys.sleep(1)
  }
  
  # Write updated content back to file
  backup_file <- paste0(bibtex_file, ".backup.", format(Sys.time(), "%Y%m%d_%H%M%S"))
  file.copy(bibtex_file, backup_file)
  cat("💾 Created backup:", backup_file, "\n")
  
  writeLines(str_split(updated_content, "\n")[[1]], bibtex_file)
  
  cat("\n📊 Summary:\n")
  cat("=============\n")
  cat("DOIs added:", dois_added, "\n")
  cat("DOIs already present:", dois_skipped, "\n")
  cat("Total entries processed:", nrow(entry_starts), "\n")
  cat("✅ Updated BibTeX file:", bibtex_file, "\n")
}

# Run the script
if (!interactive()) {
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) > 0) {
    add_dois_to_bibtex(args[1])
  } else {
    add_dois_to_bibtex("rgthomas_pubs_2025.bib")
  }
} else {
  cat("📋 Script loaded. Run: add_dois_to_bibtex('your_file.bib')\n")
}