@echo off
REM REBELLION-BOT Runner Script for Windows

echo =============================================
echo   REBELLION-BOT v1.0.0
echo =============================================
echo.

echo Checking for Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found!
    pause
    exit /b 1
)

echo.
echo Starting REBELLION-BOT...
python rebellion_bot.py %*

pause