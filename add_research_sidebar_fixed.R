# Add Advanced Sidebar Filtering to Research Page - Fixed Version
library(dplyr)
library(stringr)

# Function to extract all unique years and tags from the research page
analyze_research_content <- function(file_path = "research/index.qmd") {
  lines <- readLines(file_path)
  
  # Extract years from section headers (more carefully)
  year_lines <- lines[str_detect(lines, "^### \\d{4}$")]
  years <- as.numeric(str_extract(year_lines, "\\d{4}"))
  # Filter out unrealistic years (probably parsing errors)
  years <- years[!is.na(years) & years >= 1980 & years <= 2030]
  years <- sort(unique(years))
  
  # Extract all tags from data-tags attributes
  tag_lines <- lines[str_detect(lines, "data-tags=")]
  all_tags <- character()
  
  for (line in tag_lines) {
    tags_match <- str_extract(line, 'data-tags="([^"]+)"')
    if (!is.na(tags_match)) {
      tags_content <- str_match(tags_match, 'data-tags="([^"]+)"')[2]
      if (!is.na(tags_content)) {
        tags <- str_split(tags_content, ",")[[1]]
        tags <- str_trim(tags)
        all_tags <- c(all_tags, tags)
      }
    }
  }
  
  unique_tags <- unique(all_tags[all_tags != ""])
  unique_tags <- sort(unique_tags)
  
  return(list(
    years = years,
    tags = unique_tags,
    year_range = c(min(years), max(years))
  ))
}

# Function to generate enhanced research page
generate_research_with_sidebar <- function() {
  cat("🔧 Adding advanced sidebar filtering to research page...\n")
  
  # Read current research page
  current_content <- readLines("research/index.qmd")
  
  # Analyze content
  analysis <- analyze_research_content()
  
  cat("📊 Found", length(analysis$years), "publication years\n")
  cat("🏷️ Found", length(analysis$tags), "unique tags\n")
  cat("📅 Year range:", min(analysis$years), "to", max(analysis$years), "\n")
  
  # Find insertion point (after the callout-note)
  callout_end <- which(str_detect(current_content, "^:::$"))[1]
  if (is.na(callout_end)) {
    callout_end <- 25
  }
  
  min_year <- min(analysis$years)
  max_year <- max(analysis$years)
  
  # Create sidebar content
  sidebar_content <- c(
    "",
    "::: {.column-screen-inset}",
    "::: {.grid}",
    "",
    "::: {.g-col-12 .g-col-md-9}",
    "## 📚 Publications",
    "",
    "::: {.publications-content}",
    "",
    content[callout_end+1:length(content)],
    "",
    ":::",  # Close publications-content
    ":::",  # Close g-col div
    "",
    "::: {.g-col-12 .g-col-md-3}",
    "## 🔍 Advanced Filters",
    "",
    "### 📅 Publication Year",
    "",
    "::: {.year-filter-container}",
    '<div class="year-range-slider">',
    paste0('<label for="year-range">Year Range: <span id="year-display">', min_year, ' - ', max_year, '</span></label>'),
    paste0('<input type="range" id="year-min" min="', min_year, '" max="', max_year, '" value="', min_year, '" class="year-slider">'),
    paste0('<input type="range" id="year-max" min="', min_year, '" max="', max_year, '" value="', max_year, '" class="year-slider">'),
    '<div class="year-labels">',
    paste0('<span>', min_year, '</span>'),
    paste0('<span>', max_year, '</span>'),
    '</div>',
    '</div>',
    ":::",
    "",
    "### 🏷️ Research Topics",
    "",
    "::: {.tag-filter-container}",
    '<div class="tag-search-box">',
    '<input type="text" id="tag-search" placeholder="Search topics..." class="form-control form-control-sm">',
    '<button id="clear-tag-search" class="btn btn-sm btn-outline-secondary mt-1">Clear Search</button>',
    '</div>',
    "",
    '<div class="tag-categories">'
  )
  
  # Group tags by category
  # Extract Biostatistics and R first (these are the key keywords)
  biostat_tags <- analysis$tags[str_detect(analysis$tags, "^(Biostatistics|R)$")]
  
  medical_tags <- analysis$tags[str_detect(analysis$tags, "Alzheimer|Clinical|Medical|Drug|Treatment|Biomarker") & 
                               !str_detect(analysis$tags, "^(Biostatistics|R)$")]
  military_tags <- analysis$tags[str_detect(analysis$tags, "Military|Veteran|Traumatic|TBI")]
  imaging_tags <- analysis$tags[str_detect(analysis$tags, "Imaging|PET|MRI|Neuroimaging")]
  covid_tags <- analysis$tags[str_detect(analysis$tags, "COVID|Sleep|Healthcare")]
  other_tags <- setdiff(analysis$tags, c(biostat_tags, medical_tags, military_tags, imaging_tags, covid_tags))
  
  tag_categories <- list(
    "🔍 Key Research Areas" = biostat_tags,
    "Medical & Clinical" = medical_tags,
    "Military & Defense" = military_tags,
    "Neuroimaging & Technical" = imaging_tags,
    "COVID & Healthcare" = covid_tags,
    "Other Research" = other_tags
  )
  
  # Add categorized tags
  for (category in names(tag_categories)) {
    if (length(tag_categories[[category]]) > 0) {
      sidebar_content <- c(sidebar_content,
        '<div class="tag-category">',
        paste0('<h6 class="tag-category-header">', category, '</h6>'),
        '<div class="tag-category-tags">'
      )
      
      for (tag in tag_categories[[category]]) {
        badge_color <- case_when(
          str_detect(tag, "^(Biostatistics|R)$") ~ "dark",
          str_detect(tag, "Medical|Clinical|Alzheimer|Drug") ~ "success",
          str_detect(tag, "Military|Veteran|Traumatic") ~ "primary",
          str_detect(tag, "Imaging|PET|MRI") ~ "info",
          str_detect(tag, "COVID|Sleep|Healthcare") ~ "warning",
          TRUE ~ "secondary"
        )
        
        sidebar_content <- c(sidebar_content,
          paste0('[', tag, ']{.badge .badge-', badge_color, ' .sidebar-tag .tag-clickable data-tag="', tag, '"}')
        )
      }
      
      sidebar_content <- c(sidebar_content,
        '</div>',
        '</div>',
        ""
      )
    }
  }
  
  sidebar_content <- c(sidebar_content,
    '</div>',
    ":::",
    "",
    "### 📊 Filter Summary",
    "",
    "::: {.filter-summary}",
    '<div id="filter-stats">',
    '<div class="total-pubs">Total: <span id="total-count">333</span> publications</div>',
    '<div class="filtered-pubs">Showing: <span id="filtered-count">All</span></div>',
    '<div class="active-filters">Active filters: <span id="active-filter-count">0</span></div>',
    '</div>',
    "",
    '<button id="reset-all-filters" class="btn btn-sm btn-danger mt-2 w-100">Reset All Filters</button>',
    ":::",
    ":::",
    "",
    "::: {.g-col-12 .g-col-md-9}",
    "## 📚 Publications",
    ""
  )
  
  # Insert sidebar content
  before_sidebar <- current_content[1:callout_end]
  after_sidebar <- current_content[(callout_end + 1):length(current_content)]
  
  # Remove old "## Publications" header
  publications_header_idx <- which(str_detect(after_sidebar, "^## Publications"))
  if (length(publications_header_idx) > 0) {
    after_sidebar <- after_sidebar[-publications_header_idx[1]]
  }
  
  # Add closing tags for grid layout
  closing_tags <- c(
    ":::",
    ":::",
    ":::"
  )
  
  # Find script location
  script_start <- which(str_detect(after_sidebar, "<script>"))
  if (length(script_start) > 0) {
    before_script <- after_sidebar[1:(script_start[1] - 1)]
    script_content <- after_sidebar[script_start[1]:length(after_sidebar)]
    new_content <- c(before_sidebar, sidebar_content, before_script, closing_tags, "", script_content)
  } else {
    new_content <- c(before_sidebar, sidebar_content, after_sidebar, closing_tags)
  }
  
  # Add enhanced CSS
  css_content <- c(
    "",
    "<style>",
    "/* Advanced Research Filters Styling */",
    ".year-filter-container {",
    "  background: #f8f9fa;",
    "  padding: 1rem;",
    "  border-radius: 8px;",
    "  margin-bottom: 1rem;",
    "}",
    "",
    ".year-range-slider {",
    "  margin: 0.5rem 0;",
    "}",
    "",
    ".year-slider {",
    "  width: 100%;",
    "  margin: 0.25rem 0;",
    "  -webkit-appearance: none;",
    "  height: 6px;",
    "  border-radius: 3px;",
    "  background: #ddd;",
    "  outline: none;",
    "}",
    "",
    ".year-slider::-webkit-slider-thumb {",
    "  -webkit-appearance: none;",
    "  appearance: none;",
    "  width: 16px;",
    "  height: 16px;",
    "  border-radius: 50%;",
    "  background: #007bff;",
    "  cursor: pointer;",
    "}",
    "",
    ".year-labels {",
    "  display: flex;",
    "  justify-content: space-between;",
    "  font-size: 0.8rem;",
    "  color: #666;",
    "}",
    "",
    ".tag-filter-container {",
    "  max-height: 400px;",
    "  overflow-y: auto;",
    "  border: 1px solid #dee2e6;",
    "  border-radius: 8px;",
    "  padding: 1rem;",
    "}",
    "",
    ".tag-search-box {",
    "  margin-bottom: 1rem;",
    "  position: sticky;",
    "  top: 0;",
    "  background: white;",
    "  z-index: 10;",
    "}",
    "",
    ".tag-category {",
    "  margin-bottom: 1rem;",
    "}",
    "",
    ".tag-category-header {",
    "  font-size: 0.85rem;",
    "  font-weight: 600;",
    "  color: #495057;",
    "  margin-bottom: 0.5rem;",
    "  border-bottom: 1px solid #dee2e6;",
    "  padding-bottom: 0.25rem;",
    "}",
    "",
    ".tag-category-tags {",
    "  display: flex;",
    "  flex-wrap: wrap;",
    "  gap: 0.25rem;",
    "}",
    "",
    ".sidebar-tag {",
    "  font-size: 0.7rem !important;",
    "  padding: 0.2rem 0.4rem !important;",
    "  margin: 0.1rem !important;",
    "  cursor: pointer;",
    "  transition: all 0.2s ease;",
    "}",
    "",
    ".sidebar-tag:hover {",
    "  transform: scale(1.05);",
    "}",
    "",
    ".sidebar-tag.active {",
    "  opacity: 0.7;",
    "  transform: scale(0.95);",
    "  box-shadow: inset 0 2px 4px rgba(0,0,0,0.2);",
    "}",
    "",
    ".filter-summary {",
    "  background: #e9ecef;",
    "  padding: 1rem;",
    "  border-radius: 8px;",
    "  font-size: 0.9rem;",
    "}",
    "",
    ".filter-summary div {",
    "  margin-bottom: 0.25rem;",
    "}",
    "",
    "#year-display {",
    "  font-weight: 600;",
    "  color: #007bff;",
    "}",
    "",
    "/* Mobile responsiveness */",
    "@media (max-width: 768px) {",
    "  .tag-filter-container {",
    "    max-height: 300px;",
    "  }",
    "  ",
    "  .sidebar-tag {",
    "    font-size: 0.6rem !important;",
    "    padding: 0.15rem 0.3rem !important;",
    "  }",
    "}",
    "</style>"
  )
  
  # Create enhanced JavaScript
  js_content <- c(
    "",
    "<script>",
    "document.addEventListener('DOMContentLoaded', function() {",
    "    // Enhanced filtering system",
    "    let activeTagFilters = new Set();",
    paste0("    let yearRange = { min: ", min_year, ", max: ", max_year, " };"),
    "    let searchTerm = '';",
    "    ",
    "    // Get elements",
    "    const yearMinSlider = document.getElementById('year-min');",
    "    const yearMaxSlider = document.getElementById('year-max');",
    "    const yearDisplay = document.getElementById('year-display');",
    "    const tagSearch = document.getElementById('tag-search');",
    "    const clearTagSearch = document.getElementById('clear-tag-search');",
    "    const resetAllFilters = document.getElementById('reset-all-filters');",
    "    const sidebarTags = document.querySelectorAll('.sidebar-tag');",
    "    const paperEntries = document.querySelectorAll('.paper-entry');",
    "    const totalCount = document.getElementById('total-count');",
    "    const filteredCount = document.getElementById('filtered-count');",
    "    const activeFilterCount = document.getElementById('active-filter-count');",
    "    ",
    "    // Year range filtering",
    "    function updateYearRange() {",
    "        const min = parseInt(yearMinSlider.value);",
    "        const max = parseInt(yearMaxSlider.value);",
    "        ",
    "        // Ensure min <= max",
    "        if (min > max) {",
    "            if (this === yearMinSlider) {",
    "                yearMaxSlider.value = min;",
    "            } else {",
    "                yearMinSlider.value = max;",
    "            }",
    "        }",
    "        ",
    "        yearRange.min = parseInt(yearMinSlider.value);",
    "        yearRange.max = parseInt(yearMaxSlider.value);",
    "        yearDisplay.textContent = yearRange.min + ' - ' + yearRange.max;",
    "        ",
    "        filterPapers();",
    "    }",
    "    ",
    "    yearMinSlider.addEventListener('input', updateYearRange);",
    "    yearMaxSlider.addEventListener('input', updateYearRange);",
    "    ",
    "    // Tag search functionality",
    "    tagSearch.addEventListener('input', function() {",
    "        searchTerm = this.value.toLowerCase();",
    "        filterTagsDisplay();",
    "        filterPapers();",
    "    });",
    "    ",
    "    clearTagSearch.addEventListener('click', function() {",
    "        tagSearch.value = '';",
    "        searchTerm = '';",
    "        filterTagsDisplay();",
    "        filterPapers();",
    "    });",
    "    ",
    "    // Filter tags display based on search",
    "    function filterTagsDisplay() {",
    "        sidebarTags.forEach(tag => {",
    "            const tagText = tag.textContent.toLowerCase();",
    "            if (searchTerm === '' || tagText.includes(searchTerm)) {",
    "                tag.style.display = 'inline-block';",
    "            } else {",
    "                tag.style.display = 'none';",
    "            }",
    "        });",
    "    }",
    "    ",
    "    // Tag clicking",
    "    sidebarTags.forEach(tag => {",
    "        tag.addEventListener('click', function() {",
    "            const tagText = this.textContent.trim();",
    "            ",
    "            if (activeTagFilters.has(tagText)) {",
    "                activeTagFilters.delete(tagText);",
    "                this.classList.remove('active');",
    "            } else {",
    "                activeTagFilters.add(tagText);",
    "                this.classList.add('active');",
    "            }",
    "            ",
    "            filterPapers();",
    "        });",
    "    });",
    "    ",
    "    // Main filtering function",
    "    function filterPapers() {",
    "        let visibleCount = 0;",
    "        const yearSections = document.querySelectorAll('h3');",
    "        ",
    "        paperEntries.forEach(paper => {",
    "            let visible = true;",
    "            ",
    "            // Find the year for this paper",
    "            let paperYear = null;",
    "            let currentElement = paper.previousElementSibling;",
    "            while (currentElement) {",
    "                if (currentElement.tagName === 'H3') {",
    "                    const yearMatch = currentElement.textContent.match(/\\d{4}/);",
    "                    if (yearMatch) {",
    "                        paperYear = parseInt(yearMatch[0]);",
    "                        break;",
    "                    }",
    "                }",
    "                currentElement = currentElement.previousElementSibling;",
    "            }",
    "            ",
    "            // Year filtering",
    "            if (paperYear && (paperYear < yearRange.min || paperYear > yearRange.max)) {",
    "                visible = false;",
    "            }",
    "            ",
    "            // Tag filtering",
    "            if (visible && activeTagFilters.size > 0) {",
    "                const paperTags = paper.getAttribute('data-tags');",
    "                if (paperTags) {",
    "                    const tagList = paperTags.split(',').map(t => t.trim());",
    "                    const hasMatchingTag = Array.from(activeTagFilters).some(filter => ",
    "                        tagList.some(tag => tag.toLowerCase().includes(filter.toLowerCase()))",
    "                    );",
    "                    if (!hasMatchingTag) {",
    "                        visible = false;",
    "                    }",
    "                }",
    "            }",
    "            ",
    "            // Search term filtering",
    "            if (visible && searchTerm) {",
    "                const paperText = paper.textContent.toLowerCase();",
    "                if (!paperText.includes(searchTerm)) {",
    "                    visible = false;",
    "                }",
    "            }",
    "            ",
    "            // Apply visibility",
    "            if (visible) {",
    "                paper.style.display = 'block';",
    "                visibleCount++;",
    "            } else {",
    "                paper.style.display = 'none';",
    "            }",
    "        });",
    "        ",
    "        // Update counters",
    "        filteredCount.textContent = visibleCount === paperEntries.length ? 'All' : visibleCount;",
    "        const totalFilters = activeTagFilters.size + (searchTerm ? 1 : 0) + ",
    paste0("            ((yearRange.min !== ", min_year, " || yearRange.max !== ", max_year, ") ? 1 : 0);"),
    "        activeFilterCount.textContent = totalFilters;",
    "    }",
    "    ",
    "    // Reset all filters",
    "    resetAllFilters.addEventListener('click', function() {",
    "        activeTagFilters.clear();",
    paste0("        yearRange.min = ", min_year, ";"),
    paste0("        yearRange.max = ", max_year, ";"),
    "        searchTerm = '';",
    "        ",
    "        yearMinSlider.value = yearRange.min;",
    "        yearMaxSlider.value = yearRange.max;",
    "        yearDisplay.textContent = yearRange.min + ' - ' + yearRange.max;",
    "        tagSearch.value = '';",
    "        ",
    "        sidebarTags.forEach(tag => {",
    "            tag.classList.remove('active');",
    "            tag.style.display = 'inline-block';",
    "        });",
    "        ",
    "        filterPapers();",
    "    });",
    "    ",
    "    // Initialize",
    "    totalCount.textContent = paperEntries.length;",
    "    filterPapers();",
    "});",
    "</script>"
  )
  
  # Replace old script with enhanced version
  script_start_idx <- which(str_detect(new_content, "<script>"))
  script_end_idx <- which(str_detect(new_content, "</script>"))
  
  if (length(script_start_idx) > 0 && length(script_end_idx) > 0) {
    before_script <- new_content[1:(script_start_idx[1] - 1)]
    after_script <- new_content[(script_end_idx[length(script_end_idx)] + 1):length(new_content)]
    final_content <- c(before_script, css_content, js_content, after_script)
  } else {
    final_content <- c(new_content, css_content, js_content)
  }
  
  # Write the enhanced file
  writeLines(final_content, "research/index.qmd")
  
  cat("✅ Enhanced research page with advanced sidebar filtering\n")
  cat("🎯 Features added:\n")
  cat("   • Year range slider (", min_year, "-", max_year, ")\n")
  cat("   • Tag search box with real-time filtering\n")
  cat("   • Categorized tag display (", length(analysis$tags), "total tags)\n")
  cat("   • Filter statistics and counters\n")
  cat("   • Reset all filters button\n")
  cat("   • Mobile-responsive design\n")
  
  return(analysis)
}

# Run the enhancement
cat("🚀 Enhancing research page with advanced sidebar filtering...\n")
result <- generate_research_with_sidebar()
cat("\n🎉 Research page enhanced successfully!\n")
cat("📋 Next steps:\n")
cat("1. Run 'quarto render research/index.qmd' to see the changes\n")
cat("2. Test the year range slider\n")
cat("3. Try the tag search functionality\n")
cat("4. Test filtering combinations\n")