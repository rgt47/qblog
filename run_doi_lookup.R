#!/usr/bin/env Rscript
# Production DOI lookup script
# Processes the full BibTeX file and adds DOIs

library(httr)
library(jsonlite)
library(stringr)

# Robust DOI search function
search_doi_robust <- function(title, author = "", year = "") {
  # Clean up the search query
  clean_title <- str_remove_all(title, "[{}\"']")
  clean_title <- str_replace_all(clean_title, "[^A-Za-z0-9\\s]", " ")
  clean_title <- str_squish(clean_title)
  
  # Build search query - focus on title for better matching
  query <- clean_title
  
  # Try the Crossref API
  tryCatch({
    url <- "https://api.crossref.org/works"
    response <- GET(url, 
                    query = list(query = query, rows = 3),
                    timeout(15))
    
    if (status_code(response) == 200) {
      content_text <- content(response, "text", encoding = "UTF-8")
      data <- fromJSON(content_text, simplifyVector = TRUE)
      
      if (!is.null(data$message$items) && nrow(data$message$items) > 0) {
        items <- data$message$items
        
        # Look at the first result
        if (length(items$title) > 0 && !is.null(items$DOI)) {
          result_doi <- items$DOI[1]
          return(result_doi)
        }
      }
    }
    
    return(NA)
    
  }, error = function(e) {
    return(NA)
  })
}

# Function to add DOI to BibTeX entry
add_doi_to_bibtex_entry <- function(entry_text, doi) {
  lines <- str_split(entry_text, "\n")[[1]]
  
  # Find the last field before the closing brace
  closing_brace_line <- which(str_detect(lines, "^\\s*\\}\\s*$"))
  
  if (length(closing_brace_line) > 0) {
    insert_line <- closing_brace_line[1] - 1
    
    # Add DOI field
    doi_field <- paste0("  doi = {", doi, "},")
    
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

# Main processing function
process_bibtex_dois <- function(bibtex_file, max_entries = 50) {
  cat("🚀 Processing DOI lookup for", bibtex_file, "\n")
  cat("📖 Reading BibTeX file...\n")
  
  # Read the file
  lines <- readLines(bibtex_file, warn = FALSE)
  content <- paste(lines, collapse = "\n")
  
  # Create backup
  backup_file <- paste0(bibtex_file, ".backup.", format(Sys.time(), "%Y%m%d_%H%M%S"))
  file.copy(bibtex_file, backup_file)
  cat("💾 Created backup:", backup_file, "\n")
  
  # Find entry boundaries
  entry_pattern <- "@\\w+\\{"
  entry_starts <- str_locate_all(content, entry_pattern)[[1]]
  
  if (nrow(entry_starts) == 0) {
    cat("❌ No BibTeX entries found\n")
    return()
  }
  
  cat("📚 Found", nrow(entry_starts), "BibTeX entries\n")
  cat("🎯 Processing up to", max_entries, "entries (recent publications prioritized)\n\n")
  
  # Process entries in reverse order (most recent first)
  updated_content <- content
  dois_added <- 0
  dois_skipped <- 0
  entries_processed <- 0
  
  for (i in 1:min(max_entries, nrow(entry_starts))) {
    start_pos <- entry_starts[i, "start"]
    
    # Find the end of this entry
    if (i < nrow(entry_starts)) {
      end_pos <- entry_starts[i + 1, "start"] - 1
    } else {
      end_pos <- nchar(content)
    }
    
    entry_text <- str_sub(updated_content, start_pos, end_pos)
    
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
      next
    }
    
    entries_processed <- entries_processed + 1
    
    cat("📄", entries_processed, "/", max_entries, ":", str_trunc(title, 50), "\n")
    
    # Search for DOI
    doi <- search_doi_robust(title, author, year)
    
    if (!is.na(doi)) {
      # Add DOI to the entry
      updated_entry <- add_doi_to_bibtex_entry(entry_text, doi)
      
      # Replace in the full content
      updated_content <- str_replace(updated_content, fixed(entry_text), updated_entry)
      dois_added <- dois_added + 1
      
      cat("   ✅ Added DOI:", doi, "\n")
    } else {
      cat("   ❌ No DOI found\n")
    }
    
    # Rate limiting - be respectful to the API
    Sys.sleep(2)
  }
  
  # Write updated content back to file
  writeLines(str_split(updated_content, "\n")[[1]], bibtex_file)
  
  cat("\n📊 Summary:\n")
  cat("=============\n")
  cat("Entries processed:", entries_processed, "\n")
  cat("DOIs added:", dois_added, "\n")
  cat("DOIs already present:", dois_skipped, "\n")
  cat("Success rate:", round(dois_added / entries_processed * 100, 1), "%\n")
  cat("✅ Updated BibTeX file:", bibtex_file, "\n")
  cat("💾 Backup saved as:", backup_file, "\n")
}

# Run the script - start with 30 entries to test
cat("🎯 Starting with recent publications (30 entries)\n")
cat("   This will take about 2-3 minutes with API rate limiting\n\n")

process_bibtex_dois("rgthomas_pubs_2025.bib", max_entries = 30)