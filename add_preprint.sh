#!/bin/bash
# Safe pre-print addition script
# Helps ensure you only add files you have legal rights to post

echo "🔒 Safe Pre-print Addition Tool"
echo "================================"
echo ""

# Legal reminder
echo "⚖️  LEGAL CHECKLIST:"
echo "   ✅ This is MY accepted manuscript (not publisher's PDF)"
echo "   ✅ I am a co-author on this paper"
echo "   ✅ I have checked publisher self-archiving policy"
echo "   ✅ Any embargo period has passed"
echo ""

read -p "Have you completed the legal checklist above? [y/N]: " legal_check

if [ "$legal_check" != "y" ]; then
    echo "❌ Please complete the legal checklist first"
    echo "💡 See PREPRINT_WORKFLOW.md for guidance"
    exit 1
fi

echo ""
read -p "📄 Paper title: " title
read -p "📅 Publication year: " year
read -p "👥 First author surname: " first_author
read -p "📁 PDF file path: " pdf_path

# Validate inputs
if [ ! -f "$pdf_path" ]; then
    echo "❌ PDF file not found: $pdf_path"
    exit 1
fi

if [ ! -d "preprints/$year" ]; then
    echo "📁 Creating directory for year $year"
    mkdir -p "preprints/$year"
fi

# Create safe filename
safe_title=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g' | head -c 20)
filename="${year}_${first_author,,}_${safe_title}.pdf"

echo ""
echo "📋 Pre-print Details:"
echo "   Title: $title"
echo "   Year: $year"
echo "   Filename: $filename"
echo "   Destination: preprints/$year/$filename"
echo ""

read -p "Proceed with adding this pre-print? [y/N]: " confirm

if [ "$confirm" = "y" ]; then
    cp "$pdf_path" "preprints/$year/$filename"
    echo "✅ Successfully added pre-print!"
    echo "📁 Location: preprints/$year/$filename"
    echo ""
    echo "📋 Next Steps:"
    echo "   1. Update research page generator to include this pre-print"
    echo "   2. Run: Rscript generate_research_enhanced.R"
    echo "   3. Run: quarto render research/index.qmd"
    echo ""
    echo "💡 Consider adding a note about the pre-print version vs published version"
else
    echo "❌ Cancelled pre-print addition"
fi