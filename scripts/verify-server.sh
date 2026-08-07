#!/usr/bin/env bash

# ==========================================================
# Project : Linux Server Hardening
# Script  : verify-server.sh
# Author  : Dhruvi Dhanani
# Version : 1.0
# ==========================================================

set -Eeuo pipefail

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

REPORT_DIR="../reports"
mkdir -p "$REPORT_DIR"

REPORT_FILE="$REPORT_DIR/server-report-$(date +%F_%H-%M-%S).txt"

SCORE=100

print_line() {
    echo "------------------------------------------------------------"
}

ok() {
    printf "${GREEN}✔ %-35s${RESET}\n" "$1"
}

fail() {
    printf "${RED}✘ %-35s${RESET}\n" "$1"
    SCORE=$((SCORE-10))
}

echo
echo "============================================================"
echo "          LINUX SERVER VERIFICATION REPORT"
echo "============================================================"
echo

HOSTNAME=$(hostname)
OS=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
KERNEL=$(uname -r)
UPTIME=$(uptime -p)

echo "Hostname      : $HOSTNAME"
echo "Operating Sys : $OS"
echo "Kernel        : $KERNEL"
echo "Uptime        : $UPTIME"

print_line

echo
echo "SERVICE STATUS"
echo

if systemctl is-active --quiet ssh
then
    ok "SSH Service Running"
else
    fail "SSH Service"
fi

if systemctl is-active --quiet fail2ban
then
    ok "Fail2ban Running"
else
    fail "Fail2ban"
fi

if ufw status | grep -q "Status: active"
then
    ok "Firewall Enabled"
else
    fail "Firewall"
fi

print_line

echo
echo "SSH SECURITY"
echo

if grep -Rq "^PasswordAuthentication no" /etc/ssh/
then
    ok "Password Authentication Disabled"
else
    fail "Password Authentication"
fi

if grep -Rq "^PermitRootLogin no" /etc/ssh/
then
    ok "Root Login Disabled"
else
    fail "Root Login"
fi

if grep -Rq "^PubkeyAuthentication yes" /etc/ssh/
then
    ok "Public Key Authentication Enabled"
else
    fail "Public Key Authentication"
fi

print_line

CPU=$(top -bn1 | awk '/Cpu\(s\)/ {print 100-$8"%"}')
RAM=$(free -h | awk '/Mem:/ {print $3 "/" $2}')
DISK=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')

echo
echo "SYSTEM HEALTH"
echo

echo "CPU Usage     : $CPU"
echo "Memory Usage  : $RAM"
echo "Disk Usage    : $DISK"

print_line

echo
echo "OPEN PORTS"
echo

ss -tuln | awk 'NR>1 {print $5}' | cut -d: -f2 | sort -u

print_line

echo
echo "Original User : ${SUDO_USER:-$(whoami)}"
echo "Current User  : $(whoami)"

print_line

echo
echo "LAST LOGIN"

last -n 3

print_line

echo
echo "SECURITY SCORE"

if (( SCORE >= 90 ))
then
    RATING="★★★★★ Excellent"
elif (( SCORE >= 70 ))
then
    RATING="★★★★ Good"
elif (( SCORE >= 50 ))
then
    RATING="★★★ Fair"
else
    RATING="Needs Improvement"
fi

echo

echo "Score : $SCORE / 100"

echo "Rating: $RATING"

echo

{
echo "=============================="
echo "Linux Server Verification"
echo "=============================="
echo "Date: $(date)"
echo
echo "Hostname: $HOSTNAME"
echo "OS: $OS"
echo "Kernel: $KERNEL"
echo "Uptime: $UPTIME"
echo
echo "CPU: $CPU"
echo "RAM: $RAM"
echo "Disk: $DISK"
echo
echo "Security Score: $SCORE"
echo "Rating: $RATING"
} > "$REPORT_FILE"

echo
echo "Report saved to:"
echo "$REPORT_FILE"

echo
echo "Verification Complete."
