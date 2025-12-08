#!/bin/bash

# Script to update posts with individual format configurations to include PDF

echo "🔍 Finding posts with individual format configurations..."

posts_updated=0

# Find posts with format: configurations
for post_qmd in $(grep -l "^format:" posts/*/index.qmd); do
    echo "📝 Updating: $post_qmd"
    
    # Check if it already has PDF format
    if grep -q "pdf:" "$post_qmd"; then
        echo "   ✅ Already has PDF format"
        continue
    fi
    
    # Check if it has html format section
    if grep -A 10 "^format:" "$post_qmd" | grep -q "html:"; then
        # Add PDF format after the HTML section
        # Use awk to insert pdf: default after the html section
        awk '
        /^format:/ { print; in_format=1; next }
        in_format && /^  html:/ { 
            print
            # Read and print all html options
            while ((getline line) > 0) {
                print line
                if (line !~ /^    / && line !~ /^$/) {
                    # We hit a non-indented line or non-html option
                    print "  pdf: default"
                    print line
                    in_format=0
                    next
                }
                if (line ~ /^[^ ]/) {
                    # Hit a top-level key
                    print "  pdf: default"
                    print line
                    in_format=0
                    next
                }
            }
            # If we reach end of file while in html section
            if (in_format) {
                print "  pdf: default"
                in_format=0
            }
            next
        }
        in_format && /^[^ ]/ { 
            # Hit a top-level key, add PDF and continue
            print "  pdf: default"
            print
            in_format=0
            next
        }
        { print }
        ' "$post_qmd" > "${post_qmd}.tmp" && mv "${post_qmd}.tmp" "$post_qmd"
        
        posts_updated=$((posts_updated + 1))
        echo "   ✅ Added PDF format"
    else
        echo "   ⚠️  Unusual format structure, skipping"
    fi
done

echo ""
echo "📊 Updated $posts_updated post(s) to include PDF format"
echo "ℹ️  Run 'quarto render' to generate both HTML and PDF for all posts"