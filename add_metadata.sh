#!/bin/bash

# Script to add document-type metadata to posts

# Blog posts (tutorials, explorations, casual content)
blog_posts=(
    "chatbots_in_stats"
    "coding_with_genAI" 
    "configure_vim_for_r"
    "setupneovim"
    "setup_yabai"
    "simple_shiny_app_with_chatgpt"
    "table_placement_rmarkdown"
    "lowercasing_dataframes"
)

# White papers (in-depth technical reports, frameworks)
white_papers=(
    "research_backup_system_p32"
    "share_R_code_via_docker_p25"
    "server_setup_aws_cli"
    "dockerize_compose"
    "power_analysis_shiny_app"
)

echo "🔄 Adding metadata to blog posts..."
for post in "${blog_posts[@]}"; do
    file="posts/$post/index.qmd"
    if [ -f "$file" ]; then
        # Check if document-type already exists
        if ! grep -q "document-type:" "$file"; then
            # Add document-type after date line
            sed -i.bak 's/^date: /document-type: "blog"\
date: /' "$file"
            echo "✅ Added blog metadata to $post"
        else
            echo "⏭️  $post already has document-type"
        fi
    else
        echo "❌ File not found: $file"
    fi
done

echo ""
echo "🔄 Adding metadata to white papers..."
for post in "${white_papers[@]}"; do
    file="posts/$post/index.qmd"
    if [ -f "$file" ]; then
        # Check if document-type already exists
        if ! grep -q "document-type:" "$file"; then
            # Add document-type after date line
            sed -i.bak 's/^date: /document-type: "white-paper"\
date: /' "$file"
            echo "✅ Added white-paper metadata to $post"
        else
            echo "⏭️  $post already has document-type"
        fi
    else
        echo "❌ File not found: $file"
    fi
done

echo ""
echo "🎉 Metadata addition complete!"
echo "📋 Next steps:"
echo "1. Review the changes in each file"
echo "2. Run 'quarto render blog/index.qmd' to test blog filtering"
echo "3. Run 'quarto render white-papers/index.qmd' to test white paper filtering"