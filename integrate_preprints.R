#!/usr/bin/env Rscript
# Integrate Pre-prints into Research Page
# Automatically adds pre-print links found by the automated finder

library(dplyr)
library(stringr)

# Function to create pre-print links in research page
add_preprint_links_to_research <- function(results_csv = NULL) {
  
  # Find the most recent results file if not specified
  if (is.null(results_csv)) {
    result_files <- list.files(pattern = "preprint_search_results_.*\\.csv")
    if (length(result_files) == 0) {
      cat("❌ No pre-print results found. Run automated_preprint_finder.R first.\n")
      return()
    }
    results_csv <- result_files[length(result_files)]  # Get most recent
  }
  
  cat("📋 Integrating pre-prints from:", results_csv, "\n")
  
  # Load pre-print results
  preprint_results <- read.csv(results_csv, stringsAsFactors = FALSE)
  found_preprints <- preprint_results[preprint_results$found == TRUE, ]
  
  cat("✅ Found", nrow(found_preprints), "pre-prints to integrate\n\n")
  
  if (nrow(found_preprints) == 0) {
    cat("No pre-prints found to integrate.\n")
    return()
  }
  
  # Show what will be added
  cat("🔗 Pre-prints that will be added:\n")
  cat("=====================================\n")
  for (i in 1:nrow(found_preprints)) {
    cat(i, ".", str_trunc(found_preprints$title[i], 60), "\n")
    cat("    Source:", found_preprints$source[i], "\n")
    cat("    URL:", found_preprints$url[i], "\n\n")
  }
  
  # Create enhanced research generator with pre-print integration
  cat("🔧 Creating enhanced research page generator with pre-print links...\n")
  
  # Read the current generator
  current_generator <- readLines("generate_research_enhanced.R")
  
  # Find where to insert pre-print checking function
  insert_point <- which(str_detect(current_generator, "# Enhanced categorization function"))
  
  if (length(insert_point) == 0) {
    cat("❌ Could not find insertion point in research generator\n")
    return()
  }
  
  # Create pre-print checking function
  preprint_function <- c(
    "",
    "# Pre-print URL lookup function",
    "get_preprint_url <- function(title, year) {",
    "  # Pre-print data (from automated finder)",
    "  preprint_data <- list("
  )
  
  # Add each found pre-print as data
  for (i in 1:nrow(found_preprints)) {
    title_key <- str_trunc(found_preprints$title[i], 50)
    url <- found_preprints$url[i]
    source <- found_preprints$source[i]
    
    preprint_function <- c(preprint_function,
      paste0("    \"", title_key, "\" = list(url = \"", url, "\", source = \"", source, "\"),")
    )
  }
  
  preprint_function <- c(preprint_function,
    "    \"dummy\" = list(url = \"\", source = \"\")  # Dummy entry to avoid trailing comma",
    "  )",
    "  ",
    "  # Look for matching title",
    "  title_short <- str_trunc(title, 50)",
    "  if (title_short %in% names(preprint_data)) {",
    "    return(preprint_data[[title_short]])",
    "  }",
    "  ",
    "  return(NULL)",
    "}",
    ""
  )
  
  # Insert the function into the generator
  new_generator <- c(
    current_generator[1:(insert_point-1)],
    preprint_function,
    current_generator[insert_point:length(current_generator)]
  )
  
  # Find and update the links section
  links_pattern <- "# Add placeholder for pre-print when available"
  links_line <- which(str_detect(new_generator, links_pattern))
  
  if (length(links_line) > 0) {
    # Replace the placeholder with actual pre-print checking
    new_generator[links_line] <- "          # Check for pre-print availability"
    new_generator[links_line + 1] <- "          preprint_info <- get_preprint_url(pub$title, pub$year)"
    new_generator[links_line + 2] <- "          if (!is.null(preprint_info)) {"
    new_generator[links_line + 3] <- "            source_label <- ifelse(str_detect(preprint_info$source, 'publisher'), 'Open Access PDF', 'Pre-print PDF')"
    new_generator[links_line + 4] <- "            links <- c(links, paste0('[📋 ', source_label, '](', preprint_info$url, '){target=\"_blank\"}'))"
    new_generator[links_line + 5] <- "          }"
    
    # Remove the old placeholder line
    old_placeholder <- which(str_detect(new_generator, "Pre-print coming soon"))
    if (length(old_placeholder) > 0) {
      new_generator <- new_generator[-old_placeholder]
    }
  }
  
  # Write the enhanced generator
  writeLines(new_generator, "generate_research_with_preprints.R")
  
  cat("✅ Created generate_research_with_preprints.R\n")
  cat("\n🎯 Next Steps:\n")
  cat("1. Run: Rscript generate_research_with_preprints.R\n")
  cat("2. Run: quarto render research/index.qmd\n")
  cat("3. Check your research page for new pre-print links!\n")
  
  # Optionally run it automatically
  cat("\n🚀 Generating research page with pre-prints now...\n")
  system("Rscript generate_research_with_preprints.R")
  
  cat("✅ Research page updated with pre-print links!\n")
  cat("📋 Run 'quarto render research/index.qmd' to see the changes\n")
}

# Run the integration
add_preprint_links_to_research()