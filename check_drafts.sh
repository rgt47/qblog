#\!/bin/bash

files_to_check=(
"blog/2025-01-01-year-ahead.qmd"
"blog/chatbots-in-stats/index.qmd"
"blog/coding-with-genai/index.qmd"
"blog/index.qmd"
"blog/research-management/index.qmd"
"posts/chatbots_in_stats/index.qmd"
"posts/coding_with_genAI/index.qmd"
"posts/config_term_zsh_p11/index.qmd"
"posts/config_ultisnips/index.qmd"
"posts/configure_vim_for_r/index.qmd"
"posts/develop_r_package/index.qmd"
"posts/dockerize_compose/index.qmd"
"posts/dockerize_simple/index.qmd"
"posts/donna/index.qmd"
"posts/dual_boot_thinkpad/index.qmd"
"posts/extend_shiny_app/index.qmd"
"posts/formula_parsing/index.qmd"
"posts/install_arch_on_macbook/index.qmd"
"posts/install_mint_on_macbook/index.qmd"
"posts/lowercasing_dataframes/index.qmd"
"posts/mimicsoftmood/index.qmd"
"posts/minimalist_edc_app/index.qmd"
"posts/palmer_penguins_regression/index.qmd"
"posts/plots_from_purrr/index.qmd"
"posts/power_analysis_shiny_app/index.qmd"
"posts/r_code_package_updating_p34/index.qmd"
"posts/rct_validation_lang/index.qmd"
"posts/research_backup_system_p32/index.qmd"
"posts/research_management/index.qmd"
"posts/server_setup_aws_cli/index.qmd"
"posts/server_setup_aws_console/index.qmd"
"posts/setup_obs_p09/index.qmd"
"posts/setup_or_modifyto_rrtools_analysis_repo_p33/index.qmd"
"posts/setup_R_vimtex/index.qmd"
"posts/setup_yabai/index.qmd"
"posts/setupgit/index.qmd"
"posts/setupneovim/index.qmd"
"posts/setupquarto/index.qmd"
"posts/share_R_code_via_docker_p25/index.qmd"
"posts/share_rmd_code_via_docker/index.qmd"
"posts/share_shiny_code_via_docker/index.qmd"
"posts/simple_shiny_app_with_chatgpt/index.qmd"
"posts/simple_vim_plugin/index.qmd"
"posts/simpleS3/index.qmd"
"posts/table_placement_rmarkdown/index.qmd"
"posts/ultisnips_python_post/index.qmd"
)

echo "Files that need draft: true added:"
echo "================================="

for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        # Check if file has draft: true or draft: false in the front matter
        if grep -q "^draft:" "$file"; then
            draft_value=$(grep "^draft:" "$file" | head -1 | sed 's/draft:[[:space:]]*//')
            if [ "$draft_value" \!= "true" ]; then
                echo "$file (currently has draft: $draft_value)"
            fi
        else
            echo "$file (no draft field)"
        fi
    else
        echo "Warning: $file does not exist"
    fi
done
