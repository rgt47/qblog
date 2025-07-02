# Add Keywords Field to All BibTeX Entries
# This script adds "Biostatistics, R" to every entry in the comprehensive BibTeX file

library(stringr)

# Function to add keywords to a BibTeX entry
add_keywords_to_entry <- function(entry_text) {
  # Check if keywords field already exists
  if (str_detect(entry_text, "keywords\\s*=")) {
    cat("⚠️  Entry already has keywords field, skipping...\n")
    return(entry_text)
  }
  
  # Find the closing brace of the entry
  lines <- str_split(entry_text, "\n")[[1]]
  
  # Find the last line that's not just whitespace or closing brace
  last_content_line <- NA
  for (i in length(lines):1) {
    line <- str_trim(lines[i])
    if (line != "" && line != "}" && !str_detect(line, "^\\s*}\\s*$")) {
      last_content_line <- i
      break
    }
  }
  
  if (is.na(last_content_line)) {
    cat("⚠️  Could not find insertion point, skipping entry\n")
    return(entry_text)
  }
  
  # Add comma to last field if it doesn't have one
  if (!str_detect(lines[last_content_line], ",$")) {
    lines[last_content_line] <- paste0(lines[last_content_line], ",")
  }
  
  # Insert keywords field before the closing brace
  keywords_line <- "  keywords={Biostatistics, R}"
  
  # Find where to insert (before the closing brace)
  closing_brace_line <- NA
  for (i in (last_content_line + 1):length(lines)) {
    if (str_detect(lines[i], "^\\s*}\\s*$")) {
      closing_brace_line <- i
      break
    }
  }
  
  if (!is.na(closing_brace_line)) {
    # Insert keywords before closing brace
    new_lines <- c(lines[1:(closing_brace_line - 1)], 
                   keywords_line,
                   lines[closing_brace_line:length(lines)])
  } else {
    # Append before last line (assuming it's the closing brace)
    new_lines <- c(lines[1:(length(lines) - 1)],
                   keywords_line,
                   lines[length(lines)])
  }
  
  return(paste(new_lines, collapse = "\n"))
}

# Main function to process the entire BibTeX file
process_bibtex_file <- function(input_file = "rgthomas_cv_merged_dedup.bib", 
                                output_file = "rgthomas_cv_merged_dedup_with_keywords.bib") {
  
  cat("📚 Processing BibTeX file:", input_file, "\n")
  
  # Read the entire file
  content <- readLines(input_file, warn = FALSE)
  full_text <- paste(content, collapse = "\n")
  
  # Find all entry boundaries
  entry_starts <- str_locate_all(full_text, "@\\w+\\{")[[1]]
  
  if (nrow(entry_starts) == 0) {
    cat("❌ No BibTeX entries found\n")
    return(NULL)
  }
  
  cat("📖 Found", nrow(entry_starts), "BibTeX entries\n")
  
  # Process each entry
  processed_entries <- character()
  
  for (i in 1:nrow(entry_starts)) {
    cat("🔄 Processing entry", i, "of", nrow(entry_starts), "\n")
    
    # Find the start and end of this entry
    start_pos <- entry_starts[i, "start"]
    
    # Find the end by counting braces
    entry_start_text <- substr(full_text, start_pos, nchar(full_text))
    brace_count <- 0
    end_pos <- start_pos
    
    for (j in 1:nchar(entry_start_text)) {
      char <- substr(entry_start_text, j, j)
      if (char == "{") {
        brace_count <- brace_count + 1
      } else if (char == "}") {
        brace_count <- brace_count - 1
        if (brace_count == 0) {
          end_pos <- start_pos + j - 1
          break
        }
      }
    }
    
    # Extract the entry
    entry_text <- substr(full_text, start_pos, end_pos)
    
    # Add keywords to this entry
    processed_entry <- add_keywords_to_entry(entry_text)
    processed_entries <- c(processed_entries, processed_entry)
  }
  
  # Combine all processed entries
  final_content <- c(
    "% Enhanced BibTeX file with keywords",
    "% Generated with Biostatistics and R keywords",
    paste("% Processed:", Sys.Date()),
    "",
    processed_entries
  )
  
  # Write to output file
  writeLines(final_content, output_file)
  
  cat("✅ Processed", length(processed_entries), "entries\n")
  cat("📁 Output file:", output_file, "\n")
  
  return(processed_entries)
}

# Alternative simpler approach using regex replacement
process_bibtex_simple <- function(input_file = "rgthomas_cv_merged_dedup.bib",
                                  output_file = "rgthomas_cv_merged_dedup_with_keywords.bib") {
  
  cat("📚 Processing BibTeX file with simple method:", input_file, "\n")
  
  # Read file
  lines <- readLines(input_file, warn = FALSE)
  
  cat("📄 Read", length(lines), "lines\n")
  
  # Track processing
  entries_processed <- 0
  new_lines <- character()
  in_entry <- FALSE
  entry_lines <- character()
  
  for (i in 1:length(lines)) {
    line <- lines[i]
    
    # Check if this is the start of a new entry
    if (str_detect(line, "^@\\w+\\{")) {
      # If we were in an entry, process the previous one
      if (in_entry && length(entry_lines) > 0) {
        processed_entry <- process_entry_lines(entry_lines)
        new_lines <- c(new_lines, processed_entry)
        entries_processed <- entries_processed + 1
      }
      
      # Start new entry
      in_entry <- TRUE
      entry_lines <- line
    } else if (in_entry) {
      entry_lines <- c(entry_lines, line)
      
      # Check if this is the end of the entry
      if (str_detect(line, "^\\s*}\\s*$")) {
        # Process this entry
        processed_entry <- process_entry_lines(entry_lines)
        new_lines <- c(new_lines, processed_entry)
        entries_processed <- entries_processed + 1
        
        # Reset for next entry
        in_entry <- FALSE
        entry_lines <- character()
      }
    } else {
      # Not in an entry, just copy the line
      new_lines <- c(new_lines, line)
    }
  }
  
  # Handle any remaining entry
  if (in_entry && length(entry_lines) > 0) {
    processed_entry <- process_entry_lines(entry_lines)
    new_lines <- c(new_lines, processed_entry)
    entries_processed <- entries_processed + 1
  }
  
  # Write output
  writeLines(new_lines, output_file)
  
  cat("✅ Processed", entries_processed, "entries\n")
  cat("📁 Output written to:", output_file, "\n")
  
  return(entries_processed)
}

# Helper function to process entry lines
process_entry_lines <- function(entry_lines) {
  # Check if keywords already exist
  has_keywords <- any(str_detect(entry_lines, "keywords\\s*="))
  
  if (has_keywords) {
    return(entry_lines)
  }
  
  # Find the closing brace line
  closing_brace_idx <- which(str_detect(entry_lines, "^\\s*}\\s*$"))
  
  if (length(closing_brace_idx) == 0) {
    # No clear closing brace, just return as is
    return(entry_lines)
  }
  
  closing_brace_idx <- closing_brace_idx[1]
  
  # Find the last content line before closing brace
  last_content_idx <- closing_brace_idx - 1
  while (last_content_idx > 1 && str_trim(entry_lines[last_content_idx]) == "") {
    last_content_idx <- last_content_idx - 1
  }
  
  # Add comma to last content line if needed
  if (!str_detect(entry_lines[last_content_idx], ",$")) {
    entry_lines[last_content_idx] <- paste0(entry_lines[last_content_idx], ",")
  }
  
  # Insert keywords line
  keywords_line <- "  keywords={Biostatistics, R}"
  
  new_entry <- c(
    entry_lines[1:last_content_idx],
    keywords_line,
    entry_lines[closing_brace_idx:length(entry_lines)]
  )
  
  return(new_entry)
}

# Run the processing
cat("🚀 Starting BibTeX keyword enhancement...\n")
cat("========================================\n")

# Check if input file exists
if (!file.exists("rgthomas_cv_merged_dedup.bib")) {
  cat("❌ Input file 'rgthomas_cv_merged_dedup.bib' not found\n")
  cat("📁 Current directory contents:\n")
  print(list.files())
} else {
  # Use the simple method
  result <- process_bibtex_simple()
  
  cat("\n🎉 BibTeX enhancement complete!\n")
  cat("=====================================\n")
  cat("📊 Summary:\n")
  cat("• Added 'keywords={Biostatistics, R}' to", result, "entries\n")
  cat("• Original file: rgthomas_cv_merged_dedup.bib\n")
  cat("• Enhanced file: rgthomas_cv_merged_dedup_with_keywords.bib\n")
  cat("\n📋 Next steps:\n")
  cat("1. Review the enhanced file\n")
  cat("2. Replace the original file if satisfied\n")
  cat("3. Regenerate the research page\n")
}