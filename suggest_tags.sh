#!/bin/bash

# Tag Suggestion Tool for Thomas Lab Blog
# Helps suggest appropriate tags based on post content

echo "🏷️  Thomas Lab Blog Tag Suggestion Tool"
echo "======================================"
echo ""

if [ $# -eq 0 ]; then
    echo "Usage: ./suggest_tags.sh <post_file.qmd>"
    echo "       ./suggest_tags.sh 'post description'"
    echo ""
    echo "Example: ./suggest_tags.sh posts/my-analysis/index.qmd"
    echo "         ./suggest_tags.sh 'Bayesian analysis of clinical trial data'"
    exit 1
fi

INPUT="$1"

# If it's a file, read the content
if [[ -f "$INPUT" ]]; then
    CONTENT=$(head -50 "$INPUT" | tr '[:upper:]' '[:lower:]')
    echo "📄 Analyzing file: $INPUT"
else
    CONTENT=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]')
    echo "📝 Analyzing description: $INPUT"
fi

echo ""
echo "🎯 Suggested tags based on content analysis:"
echo ""

# Core R & Programming
CORE_TAGS=()
[[ $CONTENT =~ (ggplot|visualization|plot) ]] && CORE_TAGS+=("ggplot2")
[[ $CONTENT =~ (shiny|interactive|dashboard) ]] && CORE_TAGS+=("Shiny")
[[ $CONTENT =~ (python|py) ]] && CORE_TAGS+=("Python")
[[ $CONTENT =~ (package|library) ]] && CORE_TAGS+=("R Packages")
CORE_TAGS+=("R Programming" "Data Science" "Statistical Computing")

# Statistical Methods
STATS_TAGS=()
[[ $CONTENT =~ (bayesian|mcmc|prior) ]] && STATS_TAGS+=("Bayesian Methods")
[[ $CONTENT =~ (machine.learning|ml|random.forest|svm) ]] && STATS_TAGS+=("Machine Learning")
[[ $CONTENT =~ (time.series|forecast|arima) ]] && STATS_TAGS+=("Time Series Analysis")
[[ $CONTENT =~ (pca|principal.component) ]] && STATS_TAGS+=("PCA (Principal Component Analysis)")
[[ $CONTENT =~ (neural|deep.learning|network) ]] && STATS_TAGS+=("Neural Networks")
[[ $CONTENT =~ (survival|hazard|kaplan) ]] && STATS_TAGS+=("Survival Analysis")

# Biostatistics & Medical
BIO_TAGS=()
[[ $CONTENT =~ (clinical.trial|rct|randomized) ]] && BIO_TAGS+=("Clinical Trials")
[[ $CONTENT =~ (biostatistics|medical|health) ]] && BIO_TAGS+=("Biostatistics")
[[ $CONTENT =~ (epidemiology|population|disease) ]] && BIO_TAGS+=("Epidemiology")
[[ $CONTENT =~ (drug|pharma|medication) ]] && BIO_TAGS+=("Drug Development")

# Domain Applications
DOMAIN_TAGS=()
[[ $CONTENT =~ (genomic|genetic|dna) ]] && DOMAIN_TAGS+=("Genomics")
[[ $CONTENT =~ (spatial|geographic|map) ]] && DOMAIN_TAGS+=("Spatial Analysis")
[[ $CONTENT =~ (financial|finance|economic) ]] && DOMAIN_TAGS+=("Financial Analysis")
[[ $CONTENT =~ (neuroimaging|brain|mri) ]] && DOMAIN_TAGS+=("Neuroimaging")

# Emerging Technologies
EMERGING_TAGS=()
[[ $CONTENT =~ (llm|large.language|gpt|ai) ]] && EMERGING_TAGS+=("Large Language Models")
[[ $CONTENT =~ (simulation|monte.carlo) ]] && EMERGING_TAGS+=("Simulation")
[[ $CONTENT =~ (reproducible|open.science) ]] && EMERGING_TAGS+=("Open Science")

# Display suggestions
if [ ${#CORE_TAGS[@]} -gt 0 ]; then
    echo "🔧 Core R & Programming:"
    printf "   %s\n" "${CORE_TAGS[@]:0:3}"
fi

if [ ${#STATS_TAGS[@]} -gt 0 ]; then
    echo "📊 Statistical Methods:"
    printf "   %s\n" "${STATS_TAGS[@]:0:3}"
fi

if [ ${#BIO_TAGS[@]} -gt 0 ]; then
    echo "🏥 Biostatistics & Medical:"
    printf "   %s\n" "${BIO_TAGS[@]:0:2}"
fi

if [ ${#DOMAIN_TAGS[@]} -gt 0 ]; then
    echo "🌍 Domain Applications:"
    printf "   %s\n" "${DOMAIN_TAGS[@]:0:2}"
fi

if [ ${#EMERGING_TAGS[@]} -gt 0 ]; then
    echo "🚀 Emerging Technologies:"
    printf "   %s\n" "${EMERGING_TAGS[@]:0:2}"
fi

echo ""
echo "💡 Copy-paste format for YAML:"
echo "tags:"
ALL_SUGGESTIONS=(${CORE_TAGS[@]:0:2} ${STATS_TAGS[@]:0:2} ${BIO_TAGS[@]:0:1} ${DOMAIN_TAGS[@]:0:1} ${EMERGING_TAGS[@]:0:1})
for tag in "${ALL_SUGGESTIONS[@]:0:6}"; do
    echo "  - $tag"
done

echo ""
echo "📖 See TAGGING_GUIDE.md for complete tag reference"