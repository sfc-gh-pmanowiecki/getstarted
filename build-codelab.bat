@echo off
REM mBank Snowflake Quickstart Build Script for Windows
REM Requires claat to be installed: go install github.com/googlecodelabs/tools/claat@latest

echo 🏗️  Building mBank Snowflake Quickstart Codelab...

REM Check if claat is installed
claat version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ claat is not installed. Please install it first:
    echo    go install github.com/googlecodelabs/tools/claat@latest
    pause
    exit /b 1
)

REM Clean previous build
echo 🧹 Cleaning previous build...
if exist "mbank-snowflake-quickstart" rmdir /s /q "mbank-snowflake-quickstart"

REM Export markdown to codelab format
echo 📝 Converting Markdown to Codelab format...
claat export mbank-snowflake-quickstart.md

REM Check if build was successful
if not exist "mbank-snowflake-quickstart" (
    echo ❌ Build failed - directory not created
    pause
    exit /b 1
)

echo 🎨 Applying mBank custom styles...

REM Copy logo to codelab directory
copy "mBank_logo.png" "mbank-snowflake-quickstart\"

REM Copy custom styles
copy "mbank-styles.css" "mbank-snowflake-quickstart\"

REM Copy logo as favicon
echo 🖼️  Setting up favicon...
copy "mBank_logo.png" "mbank-snowflake-quickstart\favicon.ico"

REM Create temporary PowerShell script to modify HTML
echo 🔧 Updating HTML with mBank branding...
(
echo $htmlFile = "mbank-snowflake-quickstart\index.html"
echo $content = Get-Content $htmlFile -Raw
echo # Add custom CSS link
echo $content = $content -replace "</head>", "  <link rel=""stylesheet"" href=""mbank-styles.css"">^</head>"
echo # Update title
echo $content = $content -replace "<title>.*</title>", "<title>mBank Snowflake Database Quickstart</title>"
echo # Add meta tags
echo $metaTags = @"
echo   ^<meta name="description" content="mBank Snowflake Database Quickstart Guide - Learn essential Snowflake concepts and operations"^>
echo   ^<meta name="keywords" content="mBank, Snowflake, Database, SQL, Data Warehouse, Tutorial"^>
echo   ^<meta name="author" content="mBank Technical Team"^>
echo   ^<meta property="og:title" content="mBank Snowflake Database Quickstart"^>
echo   ^<meta property="og:description" content="Comprehensive guide to Snowflake database operations for mBank developers"^>
echo   ^<meta property="og:image" content="./mBank_logo.png"^>
echo   ^<link rel="icon" type="image/png" href="./mBank_logo.png"^>
echo "@
echo $content = $content -replace "<head>", "<head>^$metaTags"
echo Set-Content $htmlFile $content -Encoding UTF8
) > temp_update.ps1

powershell -ExecutionPolicy Bypass -File temp_update.ps1
del temp_update.ps1

echo ✅ Build completed successfully!
echo 📁 Codelab is available in: mbank-snowflake-quickstart\
echo 🌐 Open mbank-snowflake-quickstart\index.html in your browser

REM Optional: Start local server
set /p answer=🚀 Start local server? (y/n): 
if /i "%answer%"=="y" (
    echo 🌐 Starting local server on http://localhost:8000
    cd mbank-snowflake-quickstart
    python -m http.server 8000 2>nul || python3 -m http.server 8000
)

pause 