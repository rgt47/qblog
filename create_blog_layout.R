# Create Blog Layout with Center Posts and Right Sidebar
# This script creates a custom blog layout with keyword filtering

library(dplyr)
library(stringr)
library(yaml)

cat("📝 Creating blog layout with sidebar filtering...\n")

# Function to extract metadata from blog/post files
extract_post_metadata <- function() {
  # Get all blog posts from both blog/ and posts/ directories
  blog_files <- c(
    list.files("blog", pattern = "index.qmd", recursive = TRUE, full.names = TRUE),
    list.files("posts", pattern = "index.qmd", recursive = TRUE, full.names = TRUE)
  )
  
  posts_data <- data.frame()
  all_categories <- character()
  
  for (file_path in blog_files) {
    cat("Reading:", file_path, "\n")
    
    # Read file and extract YAML frontmatter
    lines <- readLines(file_path, warn = FALSE)
    
    # Find YAML boundaries
    yaml_start <- which(lines == "---")[1]
    yaml_end <- which(lines == "---")[2]
    
    if (is.na(yaml_start) || is.na(yaml_end)) next
    
    # Extract YAML
    yaml_content <- paste(lines[(yaml_start + 1):(yaml_end - 1)], collapse = "\n")
    
    # Parse YAML
    tryCatch({
      metadata <- yaml.load(yaml_content)
      
      # Check if it's a draft
      if (!is.null(metadata$draft) && metadata$draft) {
        cat("Skipping draft:", file_path, "\n")
        next
      }
      
      # Extract relevant fields
      title <- metadata$title %||% "Untitled"
      date <- metadata$date %||% Sys.Date()
      description <- metadata$description %||% metadata$subtitle %||% ""
      categories <- metadata$categories %||% list()
      image <- metadata$image %||% ""
      
      # Convert categories to character vector
      if (is.list(categories)) {
        categories <- unlist(categories)
      }
      
      # Add to all categories
      all_categories <- c(all_categories, categories)
      
      # Create relative URL
      url <- str_replace(file_path, "^./", "/")
      url <- str_replace(url, "/index.qmd$", "/")
      
      # Add to posts data
      posts_data <- rbind(posts_data, data.frame(
        title = title,
        date = as.character(date),
        description = description,
        url = url,
        categories = paste(categories, collapse = ", "),
        image = image,
        stringsAsFactors = FALSE
      ))
      
    }, error = function(e) {
      cat("Error reading:", file_path, "-", e$message, "\n")
    })
  }
  
  # Get unique categories for sidebar
  unique_categories <- unique(all_categories[all_categories != ""])
  unique_categories <- sort(unique_categories)
  
  return(list(posts = posts_data, categories = unique_categories))
}

# Extract all post data
blog_data <- extract_post_metadata()
posts <- blog_data$posts
categories <- blog_data$categories

cat("Found", nrow(posts), "published posts\n")
cat("Found", length(categories), "unique categories\n")

# Sort posts by date (most recent first)
posts$date_parsed <- as.Date(posts$date)
posts <- posts[order(posts$date_parsed, decreasing = TRUE), ]

# Create new blog index content
blog_content <- c(
  "---",
  "title: \"Blog\"", 
  "subtitle: \"Latest thoughts, updates, and discoveries\"",
  "page-layout: full",
  "---",
  "",
  "<style>",
  ".blog-grid {",
  "  display: grid;",
  "  grid-template-columns: 1fr 300px;",
  "  gap: 2rem;",
  "  margin-top: 2rem;",
  "}",
  "",
  "@media (max-width: 768px) {",
  "  .blog-grid {",
  "    grid-template-columns: 1fr;",
  "  }",
  "}",
  "",
  ".post-card {",
  "  border: 1px solid #e9ecef;",
  "  border-radius: 0.5rem;",
  "  padding: 1.5rem;",
  "  margin-bottom: 1.5rem;",
  "  background-color: #f8f9fa;",
  "  transition: box-shadow 0.2s ease;",
  "}",
  "",
  ".post-card:hover {",
  "  box-shadow: 0 4px 8px rgba(0,0,0,0.1);",
  "}",
  "",
  ".post-title {",
  "  font-size: 1.25rem;",
  "  font-weight: bold;",
  "  margin-bottom: 0.5rem;",
  "}",
  "",
  ".post-date {",
  "  color: #6c757d;",
  "  font-size: 0.9rem;",
  "  margin-bottom: 0.5rem;",
  "}",
  "",
  ".post-description {",
  "  margin-bottom: 1rem;",
  "}",
  "",
  ".post-categories {",
  "  margin-bottom: 1rem;",
  "}",
  "",
  ".category-filter {",
  "  cursor: pointer;",
  "  margin: 0.2rem;",
  "  padding: 0.3rem 0.6rem;",
  "}",
  "",
  ".sidebar {",
  "  background-color: #f8f9fa;",
  "  padding: 1.5rem;",
  "  border-radius: 0.5rem;",
  "  height: fit-content;",
  "  position: sticky;",
  "  top: 2rem;",
  "}",
  "",
  ".filter-section {",
  "  margin-bottom: 1.5rem;",
  "}",
  "",
  ".filter-section h4 {",
  "  font-size: 1.1rem;",
  "  margin-bottom: 0.5rem;",
  "  color: #495057;",
  "}",
  "",
  ".hidden {",
  "  display: none !important;",
  "}",
  "</style>",
  "",
  "Welcome to my blog! Here you'll find my latest thoughts on R programming, data science, statistical computing, and research workflows.",
  "",
  "<div class=\"blog-grid\">",
  "",
  "<!-- Main content area -->",
  "<div class=\"main-content\">",
  "<h2>📚 Latest Posts</h2>",
  "<div id=\"posts-container\">"
)

# Add each post
for (i in 1:nrow(posts)) {
  post <- posts[i, ]
  
  # Create categories badges
  if (post$categories != "") {
    cats <- str_split(post$categories, ", ")[[1]]
    category_badges <- sapply(cats, function(cat) {
      paste0('<span class="badge bg-primary category-badge" data-category="', cat, '">', cat, '</span>')
    })
    category_html <- paste(category_badges, collapse = " ")
  } else {
    category_html <- ""
  }
  
  # Format date
  formatted_date <- format(post$date_parsed, "%B %d, %Y")
  
  post_html <- c(
    paste0('<div class="post-card" data-categories="', post$categories, '">'),
    paste0('<div class="post-title"><a href="', post$url, '">', post$title, '</a></div>'),
    paste0('<div class="post-date">', formatted_date, '</div>'),
    if (post$description != "") paste0('<div class="post-description">', post$description, '</div>') else "",
    if (category_html != "") paste0('<div class="post-categories">', category_html, '</div>') else "",
    paste0('<a href="', post$url, '" class="btn btn-primary btn-sm">Read More →</a>'),
    '</div>'
  )
  
  blog_content <- c(blog_content, post_html, "")
}

# Close main content and add sidebar
blog_content <- c(blog_content,
  "</div>", # Close posts-container
  "</div>", # Close main-content
  "",
  "<!-- Sidebar -->",
  "<div class=\"sidebar\">",
  "<div class=\"filter-section\">",
  "<h4>🔍 Filter by Category</h4>",
  '<button id="clear-filters" class="btn btn-sm btn-outline-secondary mb-2">Show All</button>'
)

# Add category filters
for (category in categories) {
  blog_content <- c(blog_content,
    paste0('<div><span class="badge bg-secondary category-filter" data-category="', category, '">', category, '</span></div>')
  )
}

blog_content <- c(blog_content,
  "</div>", # Close filter-section
  "",
  "<div class=\"filter-section\">",
  "<h4>📊 Blog Stats</h4>",
  paste0('<div>Total Posts: <span id="total-posts">', nrow(posts), '</span></div>'),
  '<div>Showing: <span id="visible-posts">All</span></div>',
  "</div>",
  "</div>", # Close sidebar
  "</div>", # Close blog-grid
  "",
  "<!-- JavaScript for filtering -->",
  "<script>",
  "document.addEventListener('DOMContentLoaded', function() {",
  "    const categoryFilters = document.querySelectorAll('.category-filter');",
  "    const postCards = document.querySelectorAll('.post-card');",
  "    const clearButton = document.getElementById('clear-filters');",
  "    const visiblePostsSpan = document.getElementById('visible-posts');",
  "    let activeCategories = new Set();",
  "",
  "    function updateDisplay() {",
  "        let visibleCount = 0;",
  "        ",
  "        postCards.forEach(card => {",
  "            const cardCategories = card.getAttribute('data-categories');",
  "            if (activeCategories.size === 0) {",
  "                card.classList.remove('hidden');",
  "                visibleCount++;",
  "            } else {",
  "                const hasMatch = Array.from(activeCategories).some(cat => ",
  "                    cardCategories.includes(cat)",
  "                );",
  "                if (hasMatch) {",
  "                    card.classList.remove('hidden');",
  "                    visibleCount++;",
  "                } else {",
  "                    card.classList.add('hidden');",
  "                }",
  "            }",
  "        });",
  "        ",
  "        visiblePostsSpan.textContent = activeCategories.size === 0 ? 'All' : visibleCount;",
  "    }",
  "",
  "    categoryFilters.forEach(filter => {",
  "        filter.addEventListener('click', function() {",
  "            const category = this.getAttribute('data-category');",
  "            ",
  "            if (activeCategories.has(category)) {",
  "                activeCategories.delete(category);",
  "                this.classList.remove('bg-primary');",
  "                this.classList.add('bg-secondary');",
  "            } else {",
  "                activeCategories.add(category);",
  "                this.classList.remove('bg-secondary');",
  "                this.classList.add('bg-primary');",
  "            }",
  "            ",
  "            updateDisplay();",
  "        });",
  "    });",
  "",
  "    clearButton.addEventListener('click', function() {",
  "        activeCategories.clear();",
  "        categoryFilters.forEach(filter => {",
  "            filter.classList.remove('bg-primary');",
  "            filter.classList.add('bg-secondary');",
  "        });",
  "        updateDisplay();",
  "    });",
  "",
  "    updateDisplay();",
  "});",
  "</script>"
)

# Write the new blog index
writeLines(blog_content, "blog/index.qmd")

cat("✅ Blog layout created successfully!\n")
cat("📋 Features added:\n")
cat("• Center panel with posts in reverse chronological order\n")
cat("• Right sidebar with category filtering\n")
cat("• Responsive design for mobile devices\n")
cat("• Interactive filtering with live post count\n")
cat("• Includes Palmer Penguins posts (if not drafts)\n")
cat("\n📊 Summary:\n")
cat("• Total posts:", nrow(posts), "\n")
cat("• Categories:", length(categories), "\n")
cat("• Categories:", paste(categories, collapse = ", "), "\n")