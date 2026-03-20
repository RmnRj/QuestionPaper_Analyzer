@echo off
SETLOCAL

:: Check if Python is installed
python --version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo Python found. Starting server on port 8000...
    start "" "http://localhost:8000/src/app-page.html"
    python -m http.server 8000
    goto :end
)

:: Check if Node.js is installed
node --version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo Node.js found. Starting server on port 8000...
    start "" "http://localhost:8000/src/app-page.html"
    npx http-server -p 8000
    goto :end
)

:: Neither Python nor Node.js found
echo.
echo ERROR: Neither Python nor Node.js is installed!
echo.
echo Please install one of the following:
echo   - Python: https://www.python.org/downloads/
echo   - Node.js: https://nodejs.org/
echo.
echo Then run this script again.
echo.
echo Or open this Web App using port by any mean like from Live Server of VS Code.
echo.
echo.
pause

:end
ENDLOCAL