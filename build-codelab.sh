#!/bin/bash

# mBank Snowflake Quickstart Build Script
# Requires claat to be installed: go install github.com/googlecodelabs/tools/claat@latest

set -e

echo "🏗️  Building mBank Snowflake Quickstart Codelab..."

# Check if claat is installed
if ! command -v claat &> /dev/null; then
    echo "❌ claat is not installed. Please install it first:"
    echo "   go install github.com/googlecodelabs/tools/claat@latest"
    exit 1
fi

# Clean previous build
echo "🧹 Cleaning previous build..."
rm -rf docs/

# Export markdown to codelab format
echo "📝 Converting Markdown to Codelab format..."
claat export mbank-snowflake-quickstart.md

# Check if build was successful
if [ ! -d "snowflake-quickstart" ]; then
    echo "❌ Build failed - directory not created"
    exit 1
fi

# Move the generated content to docs folder
echo "📁 Moving content to docs folder..."
mv snowflake-quickstart docs

echo "🎨 Applying mBank custom styles..."

# Copy logo to codelab directory
cp mBank_logo.png docs/

# Copy custom styles
cp mbank-styles.css docs/

# Inject custom CSS into the HTML file
sed -i.bak '/<\/head>/i\
  <link rel="stylesheet" href="mbank-styles.css">
' docs/index.html

# Add custom favicon (using mBank logo as base)
echo "🖼️  Setting up favicon..."
cp mBank_logo.png docs/favicon.ico

# Update the HTML with mBank branding
sed -i.bak 's/<title>.*<\/title>/<title>mBank Snowflake Database Quickstart<\/title>/' docs/index.html

# Add mBank metadata
sed -i.bak '/<head>/a\
  <meta name="description" content="mBank Snowflake Database Quickstart Guide - Learn essential Snowflake concepts and operations">\
  <meta name="keywords" content="mBank, Snowflake, Database, SQL, Data Warehouse, Tutorial">\
  <meta name="author" content="mBank Technical Team">\
  <meta property="og:title" content="mBank Snowflake Database Quickstart">\
  <meta property="og:description" content="Comprehensive guide to Snowflake database operations for mBank developers">\
  <meta property="og:image" content="./mBank_logo.png">\
  <link rel="icon" type="image/png" href="./mBank_logo.png">
' docs/index.html

# Clean up backup files
rm -f docs/*.bak

echo "✅ Build completed successfully!"
echo "📁 Codelab is available in: docs/"
echo "🌐 Open docs/index.html in your browser"

# Optional: Start local server
read -p "🚀 Start local server? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🌐 Starting local server on http://localhost:8000"
    cd docs
    python3 -m http.server 8000 || python -m http.server 8000
fi 