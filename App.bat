@echo off
SETLOCAL

:: Check if Python is installed
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Python not found. Downloading Python 3.12.2 installer...
    powershell -Command "Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.12.2/python-3.12.2-amd64.exe -OutFile python_installer.exe"

    echo Installing Python silently... Please wait.
    :: 'start /wait' ensures the script waits until the installation is 100% finished
    :: InstallAllUsers=0 allows it to run without Admin rights
    start /wait python_installer.exe /quiet InstallAllUsers=0 PrependPath=1 Include_test=0
    
    echo.
    echo Installation complete! 
    echo Please close this window and run this script again to apply the new system paths.
    pause
    exit /b
)



:: Start server
echo Starting local server on port 8000...
start "" "http://localhost:8000/src/app-page.html"
python -m http.server 8000

ENDLOCAL