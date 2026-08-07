#!/usr/bin/env bash

# ==========================================================
# Project : Linux Server Hardening
# Author  : Dhruvi Dhanani
# Version : 1.0
# ==========================================================

set -Eeuo pipefail

LOG_FILE="/var/log/server-hardening.log"

# ---------- Colors ----------
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

# ---------- Logging ----------
log() {
    echo -e "$1"
    echo "$(date '+%F %T') | $(echo -e "$1" | sed 's/\x1b\[[0-9;]*m//g')" >> "$LOG_FILE"
}

success() {
    log "${GREEN}[✔] $1${RESET}"
}

info() {
    log "${BLUE}[INFO] $1${RESET}"
}

warn() {
    log "${YELLOW}[WARN] $1${RESET}"
}

error() {
    log "${RED}[ERROR] $1${RESET}"
}

# ---------- Root Check ----------
if [[ $EUID -ne 0 ]]; then
    error "Run this script using sudo."
    exit 1
fi

clear

echo "=================================================="
echo "      Linux Server Hardening Script"
echo "=================================================="

# ==========================================================
# Update Packages
# ==========================================================

info "Updating package list..."

apt update -y
apt upgrade -y

success "Packages updated."

# ==========================================================
# Install UFW
# ==========================================================

info "Installing UFW..."

apt install ufw -y

success "UFW installed."

# ==========================================================
# Configure Firewall
# ==========================================================

info "Configuring firewall..."

ufw allow OpenSSH

ufw allow 80/tcp

ufw allow 443/tcp

ufw --force enable

success "Firewall configured."

# ==========================================================
# Install Fail2ban
# ==========================================================

info "Installing Fail2ban..."

apt install fail2ban -y

systemctl enable fail2ban

systemctl start fail2ban

success "Fail2ban installed."

# ==========================================================
# Backup SSH Config
# ==========================================================

SSH_CONFIG="/etc/ssh/sshd_config"

cp "$SSH_CONFIG" "${SSH_CONFIG}.bak"

success "SSH configuration backed up."

# ==========================================================
# Configure SSH
# ==========================================================

info "Applying SSH hardening..."

sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' "$SSH_CONFIG"

sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' "$SSH_CONFIG"

sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSH_CONFIG"

# Add lines if they don't exist

grep -q "^PasswordAuthentication" "$SSH_CONFIG" || echo "PasswordAuthentication no" >> "$SSH_CONFIG"

grep -q "^PermitRootLogin" "$SSH_CONFIG" || echo "PermitRootLogin no" >> "$SSH_CONFIG"

grep -q "^PubkeyAuthentication" "$SSH_CONFIG" || echo "PubkeyAuthentication yes" >> "$SSH_CONFIG"

success "SSH configuration updated."

# ==========================================================
# Validate SSH Configuration
# ==========================================================

info "Validating SSH configuration..."

if sshd -t
then
    success "SSH configuration is valid."
else
    error "SSH configuration invalid!"
    exit 1
fi

# ==========================================================
# Restart SSH
# ==========================================================

systemctl restart ssh

success "SSH restarted."

# ==========================================================
# Enable Services
# ==========================================================

systemctl enable ssh

systemctl enable fail2ban

success "Services enabled."

# ==========================================================
# Final Verification
# ==========================================================

echo
echo "=================================================="
echo "Verification"
echo "=================================================="

systemctl is-active ssh >/dev/null \
&& success "SSH Service Running" \
|| error "SSH Service Down"

systemctl is-active fail2ban >/dev/null \
&& success "Fail2ban Running" \
|| error "Fail2ban Down"

ufw status | grep -q "Status: active" \
&& success "Firewall Active" \
|| error "Firewall Disabled"

echo

echo "=================================================="
echo "SERVER HARDENING COMPLETE"
echo "=================================================="

echo

echo "Summary"

echo "------------------------------------"

echo "Firewall       : Enabled"

echo "SSH            : Hardened"

echo "Fail2ban       : Installed"

echo "Root Login     : Disabled"

echo "Password Login : Disabled"

echo

echo "Log File : $LOG_FILE"

echo

echo "Done."
