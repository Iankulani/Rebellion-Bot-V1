# REBELLION-BOT Runner Script for PowerShell

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  REBELLION-BOT v1.0.0" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "⚠️  Not running as Administrator. Some features may require admin rights." -ForegroundColor Yellow
    Write-Host "   Right-click PowerShell -> Run as Administrator" -ForegroundColor Yellow
    Write-Host ""
}

# Check Python
try {
    python --version 2>&1 | Out-Null
} catch {
    Write-Host "❌ Python not found!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Activate virtual environment
if (Test-Path "rebellion_env\Scripts\Activate.ps1") {
    Write-Host "📦 Activating virtual environment..." -ForegroundColor Blue
    & .\rebellion_env\Scripts\Activate.ps1
} else {
    Write-Host "⚠️  Virtual environment not found. Run install.ps1 first." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "🔴 Starting REBELLION-BOT..." -ForegroundColor Red
Write-Host ""

python rebellion_bot.py $args