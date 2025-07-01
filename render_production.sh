#!/bin/bash

# Production rendering - both HTML and PDF formats
echo "🏭 Production render (HTML + PDF)..."

# First uncomment PDF in _quarto.yml temporarily
sed -i.bak 's/^  # pdf:/  pdf:/' _quarto.yml
sed -i.bak 's/^  #   /    /' _quarto.yml

# Render with both formats
quarto render --to html,pdf

# Restore HTML-only config
mv _quarto.yml.bak _quarto.yml

echo ""
echo "✅ Production render complete!"
echo "📄 Both HTML and PDF formats generated"
echo "🌐 Preview at: http://localhost:4000"