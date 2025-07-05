#!/usr/bin/env Rscript
# Test DOI lookup on a few recent publications
# Run this first to test the DOI lookup before processing the full file

source("add_dois_to_bibtex.R")

# Test function that processes only recent publications (last 5 years)
test_doi_lookup <- function(bibtex_file, max_entries = 10) {
  cat("🧪 Testing DOI lookup on recent publications...\n")
  
  # Read the file
  lines <- readLines(bibtex_file, warn = FALSE)
  content <- paste(lines, collapse = "\n")
  
  # Find entry boundaries
  entry_starts <- str_locate_all(content, "@\\w+\\{")[[1]]
  
  if (nrow(entry_starts) == 0) {
    cat("❌ No BibTeX entries found\n")
    return()
  }
  
  # Process a few recent entries for testing
  entries_tested <- 0
  
  for (i in 1:min(max_entries, nrow(entry_starts))) {
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
      cat("⏭️ Entry already has DOI, skipping\n")
      next
    }
    
    # Extract year to focus on recent publications
    year_match <- str_match(entry_text, "year\\s*=\\s*\\{([^}]+)\\}")
    year <- if (!is.na(year_match[1, 2])) as.numeric(year_match[1, 2]) else 0
    
    if (year < 2020) {
      cat("⏭️ Skipping older publication (", year, ")\n")
      next
    }
    
    # Extract title, author
    title_match <- str_match(entry_text, "title\\s*=\\s*\\{([^}]+)\\}")
    author_match <- str_match(entry_text, "author\\s*=\\s*\\{([^}]+)\\}")
    
    title <- if (!is.na(title_match[1, 2])) title_match[1, 2] else ""
    author <- if (!is.na(author_match[1, 2])) author_match[1, 2] else ""
    
    if (title == "") {
      cat("⚠️ Skipping entry without title\n")
      next
    }
    
    cat("\n📄 Testing entry", entries_tested + 1, ":\n")
    cat("   Title:", str_trunc(title, 60), "\n")
    cat("   Year:", year, "\n")
    
    # Search for DOI
    doi <- search_doi(title, author, as.character(year))
    
    if (!is.na(doi)) {
      cat("✅ Success! Would add DOI:", doi, "\n")
    } else {
      cat("❌ No DOI found for this entry\n")
    }
    
    entries_tested <- entries_tested + 1
    
    # Rate limiting
    Sys.sleep(2)
    
    if (entries_tested >= max_entries) break
  }
  
  cat("\n🧪 Test completed! Processed", entries_tested, "entries\n")
  cat("💡 If results look good, run the full script with: Rscript add_dois_to_bibtex.R\n")
}

# Run test
test_doi_lookup("rgthomas_pubs_2025.bib", max_entries = 5)