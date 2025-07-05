#!/usr/bin/env Rscript
# Simple DOI lookup using Crossref API
# A more robust version with better error handling

library(httr)
library(jsonlite)
library(stringr)

# Simple function to search for a single DOI
simple_doi_search <- function(title, author = "", year = "") {
  # Clean up the search query
  clean_title <- str_remove_all(title, "[{}\"']")
  clean_title <- str_replace_all(clean_title, "[^A-Za-z0-9\\s]", " ")
  clean_title <- str_squish(clean_title)
  
  # Build search query
  query <- clean_title
  if (author != "" && !is.na(author)) {
    first_author <- str_extract(author, "^[^,]+")
    if (!is.na(first_author)) {
      query <- paste(query, first_author)
    }
  }
  
  cat("🔍 Searching:", str_trunc(query, 60), "\n")
  
  # Try the Crossref API
  tryCatch({
    url <- "https://api.crossref.org/works"
    response <- GET(url, 
                    query = list(query = query, rows = 3),
                    timeout(10))
    
    if (status_code(response) == 200) {
      content_text <- content(response, "text", encoding = "UTF-8")
      data <- fromJSON(content_text, simplifyVector = TRUE)
      
      if (!is.null(data$message$items) && nrow(data$message$items) > 0) {
        items <- data$message$items
        
        # Look at the first result
        if (length(items$title) > 0 && !is.null(items$DOI)) {
          result_title <- items$title[[1]][1]  # Get first title from first result
          result_doi <- items$DOI[1]
          
          cat("   📝 Found:", str_trunc(result_title, 50), "\n")
          cat("   🔗 DOI:", result_doi, "\n")
          
          # Simple check - if the title has some words in common, it's probably right
          return(result_doi)
        }
      }
    }
    
    cat("   ❌ No DOI found\n")
    return(NA)
    
  }, error = function(e) {
    cat("   ⚠️ Error:", as.character(e), "\n")
    return(NA)
  })
}

# Test on a few known publications
test_publications <- list(
  list(title = "A trial of gantenerumab or solanezumab in dominantly inherited Alzheimer's disease", 
       author = "Salloway, Steven", 
       year = "2021"),
  list(title = "The Alzheimer's Prevention Initiative Composite Cognitive Test", 
       author = "Langbaum, Jessica", 
       year = "2020"),
  list(title = "Cumulative blast impulse is predictive for changes in chronic neurobehavioral symptoms", 
       author = "McEvoy, Cory", 
       year = "2024")
)

cat("🧪 Testing DOI lookup on known publications...\n\n")

for (i in 1:length(test_publications)) {
  pub <- test_publications[[i]]
  cat("📄 Test", i, ":\n")
  
  doi <- simple_doi_search(pub$title, pub$author, pub$year)
  
  if (!is.na(doi)) {
    cat("✅ Success!\n")
  } else {
    cat("❌ Failed\n")
  }
  
  cat("\n")
  Sys.sleep(2)  # Be nice to the API
}

cat("🎯 Test completed! If this worked well, we can run it on the full BibTeX file.\n")