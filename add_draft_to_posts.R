# Add draft: true to all blog posts
# This script adds "draft: true" to the YAML front matter of all blog posts

library(stringr)

# Get all blog post files
post_files <- list.files("posts", pattern = "index.qmd", recursive = TRUE, full.names = TRUE)

cat("📝 Found", length(post_files), "blog posts\n")

posts_updated <- 0

for (file_path in post_files) {
  cat("🔍 Processing:", file_path, "\n")
  
  # Read the file
  lines <- readLines(file_path, warn = FALSE)
  
  # Find YAML front matter boundaries
  yaml_start <- which(lines == "---")[1]
  yaml_end <- which(lines == "---")[2]
  
  if (is.na(yaml_start) || is.na(yaml_end)) {
    cat("⚠️  No YAML front matter found in", file_path, "\n")
    next
  }
  
  # Extract YAML content
  yaml_lines <- lines[(yaml_start + 1):(yaml_end - 1)]
  
  # Check if draft already exists
  has_draft <- any(str_detect(yaml_lines, "^draft\\s*:"))
  
  if (has_draft) {
    cat("✅ Already has draft field:", file_path, "\n")
    next
  }
  
  # Add draft: true after the title line
  title_line_idx <- which(str_detect(yaml_lines, "^title\\s*:"))[1]
  
  if (is.na(title_line_idx)) {
    # If no title found, add at the beginning
    yaml_lines <- c("draft: true", yaml_lines)
  } else {
    # Add after title line
    yaml_lines <- c(
      yaml_lines[1:title_line_idx],
      "draft: true",
      yaml_lines[(title_line_idx + 1):length(yaml_lines)]
    )
  }
  
  # Reconstruct the file
  new_lines <- c(
    lines[1:yaml_start],
    yaml_lines,
    lines[yaml_end:length(lines)]
  )
  
  # Write back to file
  writeLines(new_lines, file_path)
  posts_updated <- posts_updated + 1
  
  cat("✅ Added draft: true to", file_path, "\n")
}

cat("\n🎉 Process complete!\n")
cat("📊 Summary:\n")
cat("• Total posts found:", length(post_files), "\n")
cat("• Posts updated:", posts_updated, "\n")
cat("• Posts already had draft field:", length(post_files) - posts_updated, "\n")