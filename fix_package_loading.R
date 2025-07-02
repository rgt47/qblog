# Fix package loading in Palmer Penguins posts
# Add conditional loading for potentially missing packages

library(stringr)

# Define packages that might need conditional loading
optional_packages <- c("GGally", "car", "performance", "see", "lmtest", "pdp", "vip", "DALEX")

# Palmer Penguins post files
palmer_files <- c(
  "posts/palmer_penguins_part1/index.qmd",
  "posts/palmer_penguins_part2/index.qmd", 
  "posts/palmer_penguins_part3/index.qmd",
  "posts/palmer_penguins_part4/index.qmd",
  "posts/palmer_penguins_part5/index.qmd"
)

cat("🔧 Adding conditional package loading to Palmer Penguins posts...\n")

for (file_path in palmer_files) {
  if (!file.exists(file_path)) {
    cat("⚠️ File not found:", file_path, "\n")
    next
  }
  
  cat("📝 Processing:", file_path, "\n")
  
  # Read file
  content <- readLines(file_path, warn = FALSE)
  modified <- FALSE
  
  # Process each optional package
  for (pkg in optional_packages) {
    # Find lines with library(package) calls
    library_lines <- grep(paste0("library\\(", pkg, "\\)"), content)
    
    if (length(library_lines) > 0) {
      cat("  🔍 Found library(", pkg, ") on line(s):", paste(library_lines, collapse = ", "), "\n")
      
      # Replace each occurrence
      for (line_num in library_lines) {
        old_line <- content[line_num]
        
        # Create conditional loading
        new_lines <- c(
          paste0("# Conditional loading of ", pkg),
          paste0("if (requireNamespace(\"", pkg, "\", quietly = TRUE)) {"),
          paste0("  library(", pkg, ")"),
          "} else {",
          paste0("  cat(\"⚠️ Package '", pkg, "' not available. Install with: install.packages('", pkg, "')\\n\")"),
          "}"
        )
        
        # Replace the library line with conditional loading
        content <- c(
          content[1:(line_num-1)],
          new_lines,
          content[(line_num+1):length(content)]
        )
        
        modified <- TRUE
        cat("  ✅ Added conditional loading for", pkg, "\n")
        
        # Update line numbers for subsequent replacements
        library_lines <- library_lines + (length(new_lines) - 1)
      }
    }
  }
  
  if (modified) {
    # Write modified content back
    writeLines(content, file_path)
    cat("✅ Updated:", file_path, "\n")
  } else {
    cat("ℹ️ No changes needed for:", file_path, "\n")
  }
  
  cat("\n")
}

cat("🎉 Package loading fixes complete!\n")