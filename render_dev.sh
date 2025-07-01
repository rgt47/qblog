#!/bin/bash

# Development rendering - HTML only for speed
echo "🚀 Development render (HTML only)..."
quarto render

echo ""
echo "✅ HTML-only render complete!"
echo "🌐 Preview at: http://localhost:4000"
echo "💡 To generate PDFs: ./render_production.sh"