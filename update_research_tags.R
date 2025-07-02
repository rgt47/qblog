# Update Research Page Generator to Use BibTeX Keywords
# This script modifies the research page generator to use keywords from BibTeX entries

library(dplyr)
library(stringr)

# Enhanced function to extract keywords from BibTeX entries
extract_field <- function(text, field) {
  pattern <- paste0(field, "\\s*=\\s*\\{([^}]+)\\}")
  match <- str_extract(text, pattern)
  if (is.na(match)) return(NA)
  
  # Extract content between braces
  content <- str_extract(match, "\\{([^}]+)\\}")
  content <- str_remove_all(content, "\\{|\\}")
  return(content)
}

# Enhanced function to get topics (now uses keywords + title analysis)
get_enhanced_topics <- function(title, keywords = NULL) {
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

# Enhanced BibTeX parser with keywords support
parse_bibtex_with_keywords <- function(file_path) {
  cat("📖 Reading", file_path, "with keyword support...\n")
  lines <- readLines(file_path, warn = FALSE)
  
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
    
    # Extract fields
    title <- extract_field(entry_text, "title")
    author <- extract_field(entry_text, "author")
    year <- extract_field(entry_text, "year")
    journal <- extract_field(entry_text, "journal")
    if (is.na(journal)) {
      journal <- extract_field(entry_text, "booktitle")
    }
    doi <- extract_field(entry_text, "doi")
    keywords <- extract_field(entry_text, "keywords")  # NEW: Extract keywords
    
    publications <- rbind(publications, data.frame(
      title = title %||% "",
      author = author %||% "",
      year = year %||% "",
      journal = journal %||% "",
      doi = doi %||% "",
      keywords = keywords %||% "",  # NEW: Include keywords
      stringsAsFactors = FALSE
    ))
  }
  
  cat("✅ Extracted", nrow(publications), "publications with keyword support\n")
  return(publications)
}

cat("📝 Instructions for Adding Tags to Publications:\n")
cat("==============================================\n")
cat("1. Edit your BibTeX file: rgthomas_cv_merged_dedup.bib\n")
cat("2. Add a 'keywords' field to each entry like this:\n")
cat("   keywords={Military health, Biomarkers, Longitudinal studies}\n")
cat("3. Use comma-separated values for multiple tags\n")
cat("4. Run the updated script to regenerate the research page\n")
cat("\n📋 Recommended Tag Categories:\n")
cat("==============================\n")
cat("• Medical/Clinical: Alzheimer's disease, Clinical trials, Drug development\n")
cat("• Military/Defense: Military health, Veterans, Combat exposure, TBI\n")
cat("• Neuroimaging: PET imaging, MRI, Biomarkers, Brain imaging\n")
cat("• COVID/Healthcare: COVID-19, Healthcare workers, Pandemic response\n")
cat("• Methods: Statistical methods, Longitudinal studies, Epidemiology\n")
cat("• Specialized: Sleep disorders, Cognitive assessment, Prevention trials\n")
cat("\n🔧 To update the research page generator:\n")
cat("==========================================\n")
cat("Replace the 'get_topics' function in generate_research_final.R with 'get_enhanced_topics'\n")
cat("Replace the 'parse_bibtex_basic' function with 'parse_bibtex_with_keywords'\n")