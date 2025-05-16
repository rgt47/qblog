#!/bin/bash
# Script to update all blog posts with consistent structure and tags

# Define the standard sections to look for and add if missing
SECTIONS=(
  "Introduction"
  "Prerequisites"
  "Step-by-Step Implementation" 
  "Key Takeaways"
  "Further Reading"
)

# Define main categories
CATEGORIES=(
  "Programming & Development"
  "Data Analysis & Visualization"
  "Deployment & Operations"
  "Development Environment"
  "Shiny Applications"
  "AI & Automation"
  "System Administration"
)

# Process all post directories
find posts -type d -name "[a-zA-Z]*" | while read -r post_dir; do
  # Skip the template directory itself
  if [[ "$post_dir" == "posts/_template" || "$post_dir" == "posts/_post_template.qmd" ]]; then
    continue
  fi
  
  index_file="$post_dir/index.qmd"
  
  # Skip if no index.qmd exists
  if [ ! -f "$index_file" ]; then
    continue
  fi
  
  echo "Processing $index_file"
  
  # Check if YAML front matter needs updating
  if ! grep -q "categories:" "$index_file"; then
    # Determine appropriate category based on post content
    category=""
    
    if grep -q -i "docker\|deployment\|aws\|server" "$index_file"; then
      category="Deployment & Operations"
    elif grep -q -i "shiny\|app\|widget" "$index_file"; then
      category="Shiny Applications"
    elif grep -q -i "analysis\|visualization\|plot\|ggplot" "$index_file"; then
      category="Data Analysis & Visualization"
    elif grep -q -i "vim\|neovim\|shell\|terminal\|git" "$index_file"; then
      category="Development Environment"
    elif grep -q -i "package\|function\|programming\|code" "$index_file"; then
      category="Programming & Development"
    elif grep -q -i "chatgpt\|ai\|chatbot" "$index_file"; then
      category="AI & Automation"
    elif grep -q -i "linux\|ubuntu\|arch\|macos\|dual boot" "$index_file"; then
      category="System Administration"
    else
      category="Programming & Development"  # Default category
    fi
    
    # Generate tags based on content
    tags=""
    if grep -q -i "r\|rstudio" "$index_file"; then
      tags="$tags\n  - r"
    fi
    if grep -q -i "python" "$index_file"; then
      tags="$tags\n  - python"
    fi
    if grep -q -i "docker" "$index_file"; then
      tags="$tags\n  - docker"
    fi
    if grep -q -i "shiny" "$index_file"; then
      tags="$tags\n  - shiny"
    fi
    if grep -q -i "aws\|ec2\|cloud" "$index_file"; then
      tags="$tags\n  - aws"
    fi
    if grep -q -i "vim\|neovim" "$index_file"; then
      tags="$tags\n  - vim"
    fi
    if grep -q -i "git" "$index_file"; then
      tags="$tags\n  - git"
    fi
    if grep -q -i "linux\|ubuntu\|arch" "$index_file"; then
      tags="$tags\n  - linux"
    fi
    
    # Make a backup of the original file
    cp "$index_file" "${index_file}.bak"
    
    # Update YAML front matter
    sed -i.tmp '/^---/,/^---/ {
      s/^categories: \[.*\]/categories: \['$category'\]/g
      /^date:/a\
author: "Ronald G. Thomas"\
tags:'"$tags"'
    }' "$index_file"
  fi
  
  # Now check for each standard section and add if missing
  for section in "${SECTIONS[@]}"; do
    # Convert section name to regex pattern 
    # Remove spaces and make case insensitive
    section_pattern=$(echo "$section" | tr '[:upper:]' '[:lower:]' | tr -d ' -')
    
    # Check if section exists (in various forms like "## Introduction", "# Introduction", etc.)
    if ! grep -q -i "^#.*$section_pattern" "$index_file"; then
      echo "  Adding missing section: $section"
      
      # Add section at the end of the file
      echo -e "\n## $section\n\nIn development" >> "$index_file"
    fi
  done
  
  # Clean up temp files
  rm -f "${index_file}.tmp"
  
  echo "  Updated $index_file"
done

echo "Finished updating all posts"