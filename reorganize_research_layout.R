# Reorganize Research Page Layout
# Move sidebar to right, add JavaScript to hide empty year groups

library(stringr)

cat("🔧 Reorganizing research page layout...\n")

# Read current research page
lines <- readLines("research/index.qmd", warn = FALSE)

# Find key sections
header_end <- which(lines == "## Publications")[1]
callout_end <- which(str_detect(lines, ":::$"))[1]

# Create new layout
new_content <- c(
  lines[1:callout_end],
  "",
  "::: {.column-screen-inset}",
  "::: {.grid}",
  "",
  "::: {.g-col-12 .g-col-md-9}",
  "## 📚 Publications",
  "",
  "::: {.publications-content}"
)

# Find where publications start (after the grid setup)
pub_start <- which(str_detect(lines, "^### \\d{4}$"))[1]
pub_end <- length(lines)

# Add all publications
new_content <- c(new_content, lines[pub_start:pub_end])

# Close publications div
new_content <- c(new_content, ":::", ":::")

# Add sidebar content to the right
sidebar_content <- c(
  "",
  "::: {.g-col-12 .g-col-md-3}",
  "## 🔍 Advanced Filters",
  "",
  "### 📅 Publication Year",
  "",
  "::: {.year-filter-container}",
  '<div class="year-range-slider">',
  '<label for="year-range">Year Range: <span id="year-display">1983 - 2024</span></label>',
  '<input type="range" id="year-min" min="1983" max="2024" value="1983" class="year-slider">',
  '<input type="range" id="year-max" min="1983" max="2024" value="2024" class="year-slider">',
  '<div class="year-labels">',
  '<span>1983</span>',
  '<span>2024</span>',
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
  '<div class="tag-categories">',
  '<div class="tag-category">',
  '<h6 class="tag-category-header">🔍 Key Research Areas</h6>',
  '<div class="tag-category-tags">',
  '[Biostatistics]{.badge .badge-dark .sidebar-tag .tag-clickable data-tag="Biostatistics"}',
  '[R]{.badge .badge-dark .sidebar-tag .tag-clickable data-tag="R"}',
  '</div>',
  '</div>',
  "",
  '<div class="tag-category">',
  '<h6 class="tag-category-header">Medical & Clinical</h6>',
  '<div class="tag-category-tags">',
  '[Alzheimer\'s disease]{.badge .badge-success .sidebar-tag .tag-clickable data-tag="Alzheimer\'s disease"}',
  '[Clinical trials]{.badge .badge-success .sidebar-tag .tag-clickable data-tag="Clinical trials"}',
  '[Drug development]{.badge .badge-success .sidebar-tag .tag-clickable data-tag="Drug development"}',
  '[Medical/Clinical]{.badge .badge-success .sidebar-tag .tag-clickable data-tag="Medical/Clinical"}',
  '</div>',
  '</div>',
  "",
  '<div class="tag-category">',
  '<h6 class="tag-category-header">Military & Defense</h6>',
  '<div class="tag-category-tags">',
  '[Military health]{.badge .badge-primary .sidebar-tag .tag-clickable data-tag="Military health"}',
  '[Military/Defense]{.badge .badge-primary .sidebar-tag .tag-clickable data-tag="Military/Defense"}',
  '[Traumatic brain injury]{.badge .badge-primary .sidebar-tag .tag-clickable data-tag="Traumatic brain injury"}',
  '</div>',
  '</div>',
  "</div>",
  ":::",
  "",
  "### 📊 Filter Summary",
  "",
  "::: {.filter-summary}",
  '<div id="filter-stats">',
  '<div class="total-pubs">Total: <span id="total-count">321</span> publications</div>',
  '<div class="filtered-pubs">Showing: <span id="filtered-count">All</span></div>',
  '<div class="active-filters">Active filters: <span id="active-filter-count">0</span></div>',
  '</div>',
  "",
  '<button id="reset-all-filters" class="btn btn-sm btn-danger mt-2 w-100">Reset All Filters</button>',
  ":::",
  ":::",
  "",
  ":::",  # Close grid
  ":::"   # Close column-screen-inset
)

# Combine content
final_content <- c(new_content[1:(length(new_content)-3)], sidebar_content)

# Add enhanced JavaScript for hiding empty year groups
js_content <- c(
  "",
  "<script>",
  "document.addEventListener('DOMContentLoaded', function() {",
  "    let activeFilters = new Set();",
  "    const tags = document.querySelectorAll('.tag-clickable, .tag-filter');",
  "    const clearBtn = document.getElementById('clear-filters');",
  "    const papers = document.querySelectorAll('.paper-entry');",
  "    const yearSliders = document.querySelectorAll('.year-slider');",
  "    const yearDisplay = document.getElementById('year-display');",
  "    const filteredCount = document.getElementById('filtered-count');",
  "    const activeFilterCount = document.getElementById('active-filter-count');",
  "    const resetAllBtn = document.getElementById('reset-all-filters');",
  "    ",
  "    // Filter function with year group hiding",
  "    function filterPapers() {",
  "        let visibleCount = 0;",
  "        const minYear = parseInt(document.getElementById('year-min').value);",
  "        const maxYear = parseInt(document.getElementById('year-max').value);",
  "        ",
  "        // Update year display",
  "        yearDisplay.textContent = minYear + ' - ' + maxYear;",
  "        ",
  "        // Track which years have visible papers",
  "        const visibleYears = new Set();",
  "        ",
  "        papers.forEach(paper => {",
  "            let visible = true;",
  "            ",
  "            // Find paper year",
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
  "            // Check year filter",
  "            if (paperYear && (paperYear < minYear || paperYear > maxYear)) {",
  "                visible = false;",
  "            }",
  "            ",
  "            // Check tag filters",
  "            if (visible && activeFilters.size > 0) {",
  "                const paperTags = paper.getAttribute('data-tags').split(',');",
  "                const hasMatch = paperTags.some(tag => activeFilters.has(tag.trim()));",
  "                if (!hasMatch) visible = false;",
  "            }",
  "            ",
  "            if (visible) {",
  "                paper.style.display = 'block';",
  "                visibleCount++;",
  "                if (paperYear) visibleYears.add(paperYear);",
  "            } else {",
  "                paper.style.display = 'none';",
  "            }",
  "        });",
  "        ",
  "        // Hide/show year headers based on visible papers",
  "        document.querySelectorAll('h3').forEach(header => {",
  "            const yearMatch = header.textContent.match(/\\d{4}/);",
  "            if (yearMatch) {",
  "                const year = parseInt(yearMatch[0]);",
  "                if (visibleYears.has(year)) {",
  "                    header.style.display = 'block';",
  "                } else {",
  "                    header.style.display = 'none';",
  "                }",
  "            }",
  "        });",
  "        ",
  "        filteredCount.textContent = visibleCount;",
  "        activeFilterCount.textContent = activeFilters.size;",
  "    }",
  "    ",
  "    // Event listeners",
  "    yearSliders.forEach(slider => {",
  "        slider.addEventListener('input', filterPapers);",
  "    });",
  "    ",
  "    tags.forEach(tag => {",
  "        tag.style.cursor = 'pointer';",
  "        tag.addEventListener('click', function(e) {",
  "            e.preventDefault();",
  "            const tagText = this.textContent.trim();",
  "            if (activeFilters.has(tagText)) {",
  "                activeFilters.delete(tagText);",
  "                this.style.opacity = '1';",
  "            } else {",
  "                activeFilters.add(tagText);",
  "                this.style.opacity = '0.7';",
  "            }",
  "            filterPapers();",
  "        });",
  "    });",
  "    ",
  "    if (resetAllBtn) {",
  "        resetAllBtn.addEventListener('click', function() {",
  "            activeFilters.clear();",
  "            tags.forEach(tag => tag.style.opacity = '1');",
  "            document.getElementById('year-min').value = 1983;",
  "            document.getElementById('year-max').value = 2024;",
  "            filterPapers();",
  "        });",
  "    }",
  "    ",
  "    // Initialize",
  "    filterPapers();",
  "});",
  "</script>"
)

final_content <- c(final_content, js_content)

# Write the reorganized file
writeLines(final_content, "research/index.qmd")

cat("✅ Research page layout reorganized!\n")
cat("🔄 Changes made:\n")
cat("• Moved sidebar to the right side\n")
cat("• Publications now in left column (9/12 width)\n")
cat("• Sidebar now in right column (3/12 width)\n")
cat("• Added JavaScript to hide empty year groups\n")
cat("• Enhanced year filtering functionality\n")