# REBELLION-BOT Installation Script for PowerShell
# Author: Ian Carter Kulani

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  REBELLION-BOT Installation Script" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "⚠️  Not running as Administrator. Some features may require admin rights." -ForegroundColor Yellow
    Write-Host "   Right-click PowerShell -> Run as Administrator" -ForegroundColor Yellow
    Write-Host ""
}

# Check Python
Write-Host "📌 Checking Python installation..." -ForegroundColor Blue
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ $pythonVersion detected" -ForegroundColor Green
} catch {
    Write-Host "❌ Python not found. Please install Python 3.7+" -ForegroundColor Red
    Write-Host "   Download from: https://www.python.org/downloads/" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Create virtual environment
Write-Host ""
Write-Host "🐍 Creating Python virtual environment..." -ForegroundColor Blue
python -m venv rebellion_env

# Activate virtual environment
Write-Host "📦 Activating virtual environment..." -ForegroundColor Blue
& .\rebellion_env\Scripts\Activate.ps1

# Install dependencies
Write-Host ""
Write-Host "📦 Installing Python dependencies..." -ForegroundColor Blue
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt

# Create directories
Write-Host ""
Write-Host "📁 Creating directory structure..." -ForegroundColor Blue
$directories = @(
    ".rebellion_bot",
    ".rebellion_bot\payloads",
    ".rebellion_bot\workspaces",
    ".rebellion_bot\scans",
    ".rebellion_bot\phishing_pages",
    ".rebellion_bot\phishing_templates",
    ".rebellion_bot\captured_credentials",
    ".rebellion_bot\ssh_keys",
    ".rebellion_bot\traffic_logs",
    ".rebellion_bot\nikto_results",
    ".rebellion_bot\keylog_exfil",
    ".rebellion_bot\deployments",
    ".rebellion_bot\domain_hosting",
    ".rebellion_bot\sessions",
    ".rebellion_bot\spear_phishing",
    ".rebellion_bot\email_templates",
    ".rebellion_bot\dos_logs",
    ".rebellion_bot\agents",
    ".rebellion_bot\c2_logs",
    ".rebellion_bot\modules",
    ".rebellion_bot\network_monitor",
    ".rebellion_bot\web_templates",
    "rebellion_reports",
    "rebellion_reports\graphics",
    "temp"
)

foreach ($dir in $directories) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  Created: $dir" -ForegroundColor Gray
    }
}

# Create config
Write-Host ""
Write-Host "📝 Creating configuration file..." -ForegroundColor Blue
$config = @'
{
    "version": "1.0.0",
    "auto_start": false,
    "auto_block_enabled": false,
    "auto_block_threshold": 5,
    "scan_timeout": 30,
    "report_format": "both",
    "generate_graphics": true,
    "keylogger": {
        "enabled": false,
        "hotkey": "f10",
        "log_file": ".rebellion_bot\\keylog.txt",
        "c2_server": "",
        "upload_interval": 30,
        "exfil_methods": ["file", "email", "c2", "telegram", "discord"],
        "screenshot_interval": 60,
        "capture_clipboard": true
    },
    "web": {
        "enabled": false,
        "port": 5000,
        "host": "0.0.0.0",
        "require_auth": true,
        "username": "admin"
    },
    "spear_phishing": {
        "enabled": true,
        "smtp_server": "",
        "smtp_port": 587,
        "track_opens": true,
        "track_clicks": true
    },
    "dos": {
        "enabled": true,
        "max_threads": 100,
        "default_timeout": 60
    },
    "reports": {
        "enabled": true,
        "auto_generate": true,
        "format": "pdf",
        "include_graphics": true,
        "save_path": "rebellion_reports"
    }
}
'@

$config | Out-File -FilePath ".rebellion_bot\config.json" -Encoding UTF8

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  ✅ Installation complete!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "📌 To run REBELLION-BOT:" -ForegroundColor Blue
Write-Host "   .\run.ps1" -ForegroundColor Yellow
Write-Host ""
Write-Host "📌 Or manually:" -ForegroundColor Blue
Write-Host "   .\rebellion_env\Scripts\Activate.ps1" -ForegroundColor Yellow
Write-Host "   python rebellion_bot.py" -ForegroundColor Yellow
Write-Host ""
Read-Host "Press Enter to exit"