#!/usr/bin/env Rscript
# Test script to debug preprint matching

library(dplyr)
library(stringr)

# Load preprint data 
preprint_df <- read.csv("preprint_search_results_20250705_172057.csv", stringsAsFactors = FALSE)
preprint_df <- preprint_df[preprint_df$found == TRUE & !is.na(preprint_df$url) & preprint_df$url != "", ]

cat("Found preprints in CSV:\n")
for (i in 1:min(10, nrow(preprint_df))) {
  cat(i, ":", preprint_df$title[i], "\n")
}

# Test title from BibTeX
test_title <- "Cumulative blast impulse is predictive for changes in chronic neurobehavioral symptoms following low level blast exposure during military training"
csv_title <- "Cumulative blast impulse is predictive for changes in chronic neurobehavioral..."

cat("\nTest matching:\n")
cat("BibTeX title:", test_title, "\n")
cat("CSV title:   ", csv_title, "\n")

# Clean both titles
clean_bib <- tolower(str_remove_all(test_title, "[^a-z0-9\\s]"))
clean_bib <- str_squish(clean_bib)

clean_csv <- tolower(str_remove_all(csv_title, "[^a-z0-9\\s]"))
clean_csv <- str_squish(str_remove_all(clean_csv, "\\.+$"))  # Remove trailing dots

cat("Clean BibTeX: ", clean_bib, "\n")
cat("Clean CSV:    ", clean_csv, "\n")

# Test if CSV title is start of BibTeX title
if (str_starts(clean_bib, clean_csv)) {
  cat("✅ MATCH: CSV title is start of BibTeX title\n")
} else {
  cat("❌ NO MATCH\n")
}

# Test word matching
bib_words <- str_split(clean_bib, "\\s+")[[1]]
csv_words <- str_split(clean_csv, "\\s+")[[1]]

matches <- sum(csv_words %in% bib_words)
threshold <- length(csv_words) * 0.8

cat("Word matches:", matches, "/", length(csv_words), "words\n")
cat("Threshold:", threshold, "\n")

if (matches >= threshold) {
  cat("✅ WORD MATCH SUCCESS\n")
} else {
  cat("❌ WORD MATCH FAILED\n")
}