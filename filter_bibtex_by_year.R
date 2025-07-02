# Filter BibTeX entries by year - remove entries from 1982 or earlier
# This script removes all entries with year <= 1982 from the BibTeX file

library(stringr)

cat("📚 Filtering BibTeX entries by year...\n")
cat("Removing all entries from 1982 or earlier\n")

# Read the file
input_file <- "rgthomas_cv_merged_dedup_with_keywords.bib"
lines <- readLines(input_file, warn = FALSE)

cat("📄 Read", length(lines), "lines from", input_file, "\n")

# Process line by line to extract complete entries
new_lines <- character()
entries_removed <- 0
entries_kept <- 0

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
    entry_text <- paste(entry_lines, collapse = " ")
    
    # Extract year from the entry
    year_match <- str_extract(entry_text, "year\\s*=\\s*\\{([^}]+)\\}")
    if (!is.na(year_match)) {
      year_content <- str_extract(year_match, "\\{([^}]+)\\}")
      year_content <- str_remove_all(year_content, "\\{|\\}")
      year_num <- as.numeric(year_content)
      
      # Check if year is valid and after 1982
      if (!is.na(year_num) && year_num > 1982) {
        # Keep this entry
        new_lines <- c(new_lines, entry_lines)
        new_lines <- c(new_lines, "")  # Add blank line after entry
        entries_kept <- entries_kept + 1
      } else {
        # Remove this entry
        cat("🗑️ Removing entry from year:", year_num, "\n")
        entries_removed <- entries_removed + 1
      }
    } else {
      # No year found, keep the entry to be safe
      cat("⚠️ No year found in entry, keeping it\n")
      new_lines <- c(new_lines, entry_lines)
      new_lines <- c(new_lines, "")
      entries_kept <- entries_kept + 1
    }
    
  } else {
    # Not an entry start, check if it's a comment or header line
    if (grepl("^%", line) || str_trim(line) == "") {
      new_lines <- c(new_lines, line)
    }
    i <- i + 1
  }
}

# Write the filtered file
output_file <- "rgthomas_cv_merged_dedup_with_keywords_filtered.bib"
writeLines(new_lines, output_file)

cat("✅ Filtering complete!\n")
cat("📊 Summary:\n")
cat("• Original file:", input_file, "\n")
cat("• Filtered file:", output_file, "\n")
cat("• Entries removed:", entries_removed, "\n")
cat("• Entries kept:", entries_kept, "\n")
cat("• Total entries processed:", entries_removed + entries_kept, "\n")

# Verify the filtering
cat("\n🔍 Verification:\n")
output_lines <- readLines(output_file, warn = FALSE)

# Find all years in the filtered file
year_matches <- str_extract_all(paste(output_lines, collapse = " "), "year\\s*=\\s*\\{([^}]+)\\}")[[1]]
years <- character()

for (match in year_matches) {
  year_content <- str_extract(match, "\\{([^}]+)\\}")
  year_content <- str_remove_all(year_content, "\\{|\\}")
  years <- c(years, year_content)
}

years_numeric <- as.numeric(years[!is.na(as.numeric(years))])
if (length(years_numeric) > 0) {
  cat("• Year range in filtered file:", min(years_numeric), "to", max(years_numeric), "\n")
  
  # Check if any entries from 1982 or earlier remain
  old_entries <- sum(years_numeric <= 1982, na.rm = TRUE)
  if (old_entries > 0) {
    cat("⚠️ Warning:", old_entries, "entries from 1982 or earlier still remain\n")
  } else {
    cat("✅ Confirmed: No entries from 1982 or earlier remain\n")
  }
} else {
  cat("⚠️ No valid years found in filtered file\n")
}

cat("\n🎉 BibTeX filtering complete!\n")