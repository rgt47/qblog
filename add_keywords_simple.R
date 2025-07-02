# Simple Keywords Addition to BibTeX
# Adds "Biostatistics, R" keywords to every BibTeX entry

# Read the file
cat("📚 Reading BibTeX file...\n")
lines <- readLines("rgthomas_cv_merged_dedup.bib", warn = FALSE)
cat("📄 Read", length(lines), "lines\n")

# Process line by line
new_lines <- character()
entries_processed <- 0

i <- 1
while (i <= length(lines)) {
  line <- lines[i]
  
  # Check if this line starts a new entry
  if (grepl("^@", line)) {
    # This is the start of an entry
    entry_lines <- line
    i <- i + 1
    
    # Collect all lines until we find the closing brace
    brace_count <- 1  # We started with one opening brace
    
    while (i <= length(lines) && brace_count > 0) {
      current_line <- lines[i]
      entry_lines <- c(entry_lines, current_line)
      
      # Count braces
      open_braces <- length(gregexpr("\\{", current_line)[[1]])
      if (open_braces > 0 && gregexpr("\\{", current_line)[[1]][1] != -1) {
        brace_count <- brace_count + open_braces
      }
      
      close_braces <- length(gregexpr("\\}", current_line)[[1]])
      if (close_braces > 0 && gregexpr("\\}", current_line)[[1]][1] != -1) {
        brace_count <- brace_count - close_braces
      }
      
      i <- i + 1
    }
    
    # Now we have a complete entry in entry_lines
    # Check if it already has keywords
    has_keywords <- any(grepl("keywords", entry_lines, ignore.case = TRUE))
    
    if (!has_keywords) {
      # Find the closing brace line
      closing_line_idx <- length(entry_lines)
      
      # Find the last content line (before closing brace)
      last_content_idx <- closing_line_idx - 1
      while (last_content_idx > 1 && trimws(entry_lines[last_content_idx]) == "") {
        last_content_idx <- last_content_idx - 1
      }
      
      # Add comma to last content line if it doesn't have one
      if (!grepl(",$", trimws(entry_lines[last_content_idx]))) {
        entry_lines[last_content_idx] <- paste0(entry_lines[last_content_idx], ",")
      }
      
      # Insert keywords before closing brace
      keywords_line <- "  keywords={Biostatistics, R}"
      
      modified_entry <- c(
        entry_lines[1:last_content_idx],
        keywords_line,
        entry_lines[closing_line_idx]
      )
      
      new_lines <- c(new_lines, modified_entry)
      entries_processed <- entries_processed + 1
    } else {
      # Entry already has keywords, keep as is
      new_lines <- c(new_lines, entry_lines)
    }
    
    # Add blank line after entry
    new_lines <- c(new_lines, "")
    
  } else {
    # Not an entry start, just copy the line
    new_lines <- c(new_lines, line)
    i <- i + 1
  }
}

# Write the enhanced file
output_file <- "rgthomas_cv_merged_dedup_with_keywords.bib"
writeLines(new_lines, output_file)

cat("✅ Processing complete!\n")
cat("📊 Summary:\n")
cat("• Processed", entries_processed, "entries\n")
cat("• Added keywords={Biostatistics, R} to each entry\n")
cat("• Output file:", output_file, "\n")

# Verify the output
cat("\n🔍 Verification:\n")
output_lines <- readLines(output_file, warn = FALSE)
keyword_lines <- grep("keywords.*Biostatistics.*R", output_lines)
cat("• Found", length(keyword_lines), "entries with new keywords\n")

# Show a sample entry
cat("\n📋 Sample enhanced entry:\n")
sample_start <- grep("^@", output_lines)[1]
sample_end <- sample_start
brace_count <- 0
for (j in sample_start:length(output_lines)) {
  line <- output_lines[j]
  brace_count <- brace_count + length(gregexpr("\\{", line)[[1]])
  if (gregexpr("\\{", line)[[1]][1] == -1) brace_count <- brace_count + 1
  brace_count <- brace_count - length(gregexpr("\\}", line)[[1]])
  if (gregexpr("\\}", line)[[1]][1] == -1) brace_count <- brace_count + 1
  if (brace_count <= 0) {
    sample_end <- j
    break
  }
}

cat("=====================================\n")
for (k in sample_start:min(sample_end, sample_start + 15)) {
  cat(output_lines[k], "\n")
}
if (sample_end > sample_start + 15) cat("...\n")
cat("=====================================\n")

cat("\n🎉 Keywords successfully added to all BibTeX entries!\n")
cat("📁 Next step: Replace original file with enhanced version if satisfied\n")