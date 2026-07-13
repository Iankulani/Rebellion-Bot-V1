#!/bin/bash
# REBELLION-BOT Runner Script

echo "🔴 Starting REBELLION-BOT..."

# Activate virtual environment
if [ -d "rebellion_env" ]; then
    source rebellion_env/bin/activate
else
    echo "⚠️  Virtual environment not found. Run ./install.sh first."
    exit 1
fi

# Check for root/sudo
if [ "$EUID" -ne 0 ]; then 
    echo -e "\033[93m⚠️  Not running as root. Some features may be limited.\033[0m"
    echo -e "\033[93m   Run with: sudo ./run.sh\033[0m"
fi

# Start the bot
python3 rebellion_bot.py "$@"