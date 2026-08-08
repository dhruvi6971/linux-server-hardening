# Linux Server Hardening — Command Reference

> A practical command reference for administering, securing, monitoring, and troubleshooting an Ubuntu Linux server.

This document contains the commands used throughout the **Linux Server Hardening** project.

---

## Table of Contents

- [System Information](#system-information)
- [Package Management](#package-management)
- [User Management](#user-management)
- [File Permissions](#file-permissions)
- [SSH Administration](#ssh-administration)
- [SSH Key Authentication](#ssh-key-authentication)
- [Service Management](#service-management)
- [UFW Firewall](#ufw-firewall)
- [Fail2ban](#fail2ban)
- [System Monitoring](#system-monitoring)
- [Network and Port Inspection](#network-and-port-inspection)
- [Logs and Troubleshooting](#logs-and-troubleshooting)
- [Project Scripts](#project-scripts)
- [Safe SSH Workflow](#safe-ssh-workflow)
- [Post-Hardening Verification](#post-hardening-verification)

---

# System Information

### Check Operating System

```bash
cat /etc/os-release
```

### Check Kernel Version

```bash
uname -r
```

### Display Complete System Information

```bash
uname -a
```

### Check Hostname

```bash
hostname
```

### Display Host Information

```bash
hostnamectl
```

### Check System Uptime

```bash
uptime -p
```

### Check Current User

```bash
whoami
```

### Display User ID and Groups

```bash
id
```

---

# Package Management

Ubuntu uses `apt` for package management.

### Update Package Index

```bash
sudo apt update
```

### Upgrade Installed Packages

```bash
sudo apt upgrade -y
```

### Install a Package

```bash
sudo apt install <package-name> -y
```

Example:

```bash
sudo apt install fail2ban -y
```

### Remove a Package

```bash
sudo apt remove <package-name>
```

### Search for a Package

```bash
apt search <package-name>
```

### Check Installed Packages

```bash
dpkg -l
```

### Remove Unused Dependencies

```bash
sudo apt autoremove
```

---

# User Management

A secure Linux server should avoid using the root account for routine administration.

### Create a User

```bash
sudo adduser <username>
```

### Add User to Sudo Group

```bash
sudo usermod -aG sudo <username>
```

### Check User Groups

```bash
groups <username>
```

### Display User Information

```bash
id <username>
```

### List Local Users

```bash
cut -d: -f1 /etc/passwd
```

### Check Sudo Permissions

```bash
sudo -l
```

---

# File Permissions

Linux permissions are important for protecting SSH keys, configuration files, and scripts.

### List Files With Permissions

```bash
ls -la
```

### Check Directory Permissions

```bash
ls -ld <directory>
```

### Change Ownership

```bash
sudo chown <user>:<group> <file>
```

### Change Ownership Recursively

```bash
sudo chown -R <user>:<group> <directory>
```

### Set Directory Permissions

```bash
sudo chmod 700 <directory>
```

### Set File Permissions

```bash
sudo chmod 600 <file>
```

### Make a Script Executable

```bash
chmod +x <script>
```

Example:

```bash
chmod +x scripts/secure-server.sh
```

---

# SSH Administration

SSH provides secure remote administration of the Linux server.

### Check SSH Service

```bash
sudo systemctl status ssh
```

### Start SSH

```bash
sudo systemctl start ssh
```

### Restart SSH

```bash
sudo systemctl restart ssh
```

### Enable SSH at Boot

```bash
sudo systemctl enable ssh
```

### Check Whether SSH Is Running

```bash
systemctl is-active ssh
```

### Validate SSH Configuration

Always validate the configuration before restarting SSH:

```bash
sudo sshd -t
```

If there is no output, the configuration passed the syntax check.

### View SSH Configuration

```bash
sudo less /etc/ssh/sshd_config
```

### Edit SSH Configuration

```bash
sudo nano /etc/ssh/sshd_config
```

### Check Password Authentication

```bash
sudo grep -R "PasswordAuthentication" /etc/ssh/
```

### Check Root Login

```bash
sudo grep -R "PermitRootLogin" /etc/ssh/
```

### Check Public-Key Authentication

```bash
sudo grep -R "PubkeyAuthentication" /etc/ssh/
```

### Recommended SSH Security Settings

```text
PasswordAuthentication no
PermitRootLogin no
PubkeyAuthentication yes
MaxAuthTries 3
LoginGraceTime 30
PermitEmptyPasswords no
X11Forwarding no
ClientAliveInterval 300
ClientAliveCountMax 2
```

---

# SSH Key Authentication

SSH keys provide secure authentication without relying on passwords.

### Generate an Ed25519 Key

Run on your local machine:

```bash
ssh-keygen -t ed25519
```

### Display Public Key

```bash
cat ~/.ssh/id_ed25519.pub
```

> Never share your private key.

```text
id_ed25519       → Private key
id_ed25519.pub   → Public key
```

### Copy Public Key to Server

```bash
ssh-copy-id <username>@<server-ip>
```

### Connect Using an SSH Key

```bash
ssh -i <private-key> <username>@<server-ip>
```

Example:

```bash
ssh -i ~/Downloads/server1.pem ubuntu@<server-ip>
```

### Check SSH Directory

```bash
ls -la ~/.ssh
```

### Check Authorized Keys

```bash
cat ~/.ssh/authorized_keys
```

### Secure SSH Directory

```bash
chmod 700 ~/.ssh
```

### Secure Authorized Keys

```bash
chmod 600 ~/.ssh/authorized_keys
```

---

# Service Management

Ubuntu uses `systemd` to manage services.

### Check Service Status

```bash
sudo systemctl status <service>
```

### Start a Service

```bash
sudo systemctl start <service>
```

### Stop a Service

```bash
sudo systemctl stop <service>
```

### Restart a Service

```bash
sudo systemctl restart <service>
```

### Enable Service at Boot

```bash
sudo systemctl enable <service>
```

### Disable Service at Boot

```bash
sudo systemctl disable <service>
```

### Check Whether Service Is Running

```bash
systemctl is-active <service>
```

### Check Whether Service Starts at Boot

```bash
systemctl is-enabled <service>
```

### View Service Logs

```bash
sudo journalctl -u <service>
```

Example:

```bash
sudo journalctl -u ssh
```

---

# UFW Firewall

UFW (Uncomplicated Firewall) provides a simple interface for managing firewall rules.

### Check Firewall Status

```bash
sudo ufw status
```

### Detailed Firewall Status

```bash
sudo ufw status verbose
```

### Display Numbered Rules

```bash
sudo ufw status numbered
```

### Allow SSH

```bash
sudo ufw allow OpenSSH
```

Or:

```bash
sudo ufw allow 22/tcp
```

### Allow HTTP

```bash
sudo ufw allow 80/tcp
```

### Allow HTTPS

```bash
sudo ufw allow 443/tcp
```

### Enable Firewall

```bash
sudo ufw enable
```

> Make sure SSH is allowed before enabling the firewall on a remote server.

### Disable Firewall

```bash
sudo ufw disable
```

### Delete a Firewall Rule

```bash
sudo ufw status numbered
sudo ufw delete <rule-number>
```

### Reset UFW

```bash
sudo ufw reset
```

> Use carefully. This removes existing firewall rules.

---

# Fail2ban

Fail2ban helps protect services from repeated authentication failures.

### Check Fail2ban

```bash
sudo systemctl status fail2ban
```

### Start Fail2ban

```bash
sudo systemctl start fail2ban
```

### Restart Fail2ban

```bash
sudo systemctl restart fail2ban
```

### Enable Fail2ban at Boot

```bash
sudo systemctl enable fail2ban
```

### Check Fail2ban Status

```bash
sudo fail2ban-client status
```

### Check SSH Jail

```bash
sudo fail2ban-client status sshd
```

### View Fail2ban Logs

```bash
sudo journalctl -u fail2ban
```

---

# System Monitoring

These commands help monitor server health.

### Monitor CPU and Processes

```bash
top
```

### Check Memory Usage

```bash
free -h
```

### Check Disk Usage

```bash
df -h
```

### Check Root Filesystem

```bash
df -h /
```

### List Running Processes

```bash
ps aux
```

### Display Process Tree

```bash
ps aux --forest
```

### Check System Load

```bash
uptime
```

---

# Network and Port Inspection

These commands help identify network interfaces, routes, and exposed services.

### Display Network Interfaces

```bash
ip addr
```

### Display Routing Table

```bash
ip route
```

### Display Listening Ports

```bash
sudo ss -tuln
```

### Display Listening Ports and Processes

```bash
sudo ss -tulpn
```

### Check a Specific Port

```bash
sudo ss -tulpn | grep :22
```

### Test Network Connectivity

```bash
ping -c 4 <host>
```

### Test a TCP Port

```bash
nc -zv <host> <port>
```

Example:

```bash
nc -zv <server-ip> 22
```

---

# Logs and Troubleshooting

Logs are essential for diagnosing Linux server problems.

### View SSH Logs

```bash
sudo journalctl -u ssh
```

### View Recent SSH Logs

```bash
sudo journalctl -u ssh --no-pager -n 50
```

### Follow SSH Logs in Real Time

```bash
sudo journalctl -u ssh -f
```

### View Fail2ban Logs

```bash
sudo journalctl -u fail2ban
```

### View Authentication Logs

```bash
sudo tail -f /var/log/auth.log
```

### Search Authentication Logs

```bash
sudo grep "Failed password" /var/log/auth.log
```

### View Server Hardening Log

```bash
sudo cat /var/log/server-hardening.log
```

### Follow Server Hardening Log

```bash
sudo tail -f /var/log/server-hardening.log
```

### Search a Log

```bash
grep "<pattern>" <file>
```

Example:

```bash
grep "error" /var/log/server-hardening.log
```

---

# Project Scripts

The project contains two main automation scripts:

```text
scripts/
├── secure-server.sh
└── verify-server.sh
```

### Make Scripts Executable

From the project root:

```bash
chmod +x scripts/*.sh
```

### Run Server Hardening

```bash
sudo ./scripts/secure-server.sh
```

### Run Server Verification

```bash
sudo ./scripts/verify-server.sh
```

The verification script checks:

- SSH service
- UFW firewall
- Fail2ban
- Password authentication
- Root login
- Public-key authentication
- CPU usage
- Memory usage
- Disk usage
- Listening ports
- Security score

---

# Safe SSH Workflow

SSH configuration changes must be performed carefully because an invalid configuration can prevent remote access.

Use this workflow:

```text
Backup
  ↓
Modify
  ↓
Validate
  ↓
Restart
  ↓
Test
```

### 1. Keep Current SSH Session Open

Do not immediately close your existing SSH connection after modifying SSH configuration.

### 2. Back Up Configuration

```bash
sudo cp /etc/ssh/sshd_config \
/etc/ssh/sshd_config.$(date +%F-%H%M%S).bak
```

### 3. Modify Configuration

```bash
sudo nano /etc/ssh/sshd_config
```

### 4. Validate Configuration

```bash
sudo sshd -t
```

Only continue if validation succeeds.

### 5. Restart SSH

```bash
sudo systemctl restart ssh
```

### 6. Test a New Connection

From another terminal:

```bash
ssh -i <private-key> <username>@<server-ip>
```

Confirm the new connection works before closing the original session.

---

# Post-Hardening Verification

After running the hardening script, verify the server state.

### SSH Service

```bash
sudo systemctl status ssh
```

Expected:

```text
active (running)
```

### SSH Configuration

```bash
sudo sshd -t
```

Expected:

```text
No output
```

### Password Authentication

```bash
sudo grep -R "PasswordAuthentication" /etc/ssh/
```

Expected security configuration:

```text
PasswordAuthentication no
```

### Root SSH Login

```bash
sudo grep -R "PermitRootLogin" /etc/ssh/
```

Expected:

```text
PermitRootLogin no
```

### Public-Key Authentication

```bash
sudo grep -R "PubkeyAuthentication" /etc/ssh/
```

Expected:

```text
PubkeyAuthentication yes
```

### Firewall

```bash
sudo ufw status verbose
```

Expected:

```text
Status: active
```

### Fail2ban

```bash
sudo systemctl status fail2ban
```

Expected:

```text
active (running)
```

### Listening Ports

```bash
sudo ss -tulpn
```

Review the output and confirm that only required services are exposed.

### Automated Verification

```bash
sudo ./scripts/verify-server.sh
```

---

# Quick Reference

| Task | Command |
|---|---|
| Check OS | `cat /etc/os-release` |
| Check kernel | `uname -r` |
| Check uptime | `uptime -p` |
| Current user | `whoami` |
| Update packages | `sudo apt update` |
| Upgrade packages | `sudo apt upgrade -y` |
| Create user | `sudo adduser <user>` |
| Add sudo access | `sudo usermod -aG sudo <user>` |
| Check SSH | `sudo systemctl status ssh` |
| Validate SSH | `sudo sshd -t` |
| Restart SSH | `sudo systemctl restart ssh` |
| Check firewall | `sudo ufw status verbose` |
| Enable firewall | `sudo ufw enable` |
| Check Fail2ban | `sudo fail2ban-client status` |
| Check processes | `ps aux` |
| Check memory | `free -h` |
| Check disk | `df -h` |
| Check ports | `sudo ss -tulpn` |
| Check SSH logs | `sudo journalctl -u ssh` |
| Run hardening | `sudo ./scripts/secure-server.sh` |
| Run verification | `sudo ./scripts/verify-server.sh` |

---

# Security Principles

This project follows these core Linux server security principles:

1. Use a non-root administrative account.
2. Prefer SSH key authentication over passwords.
3. Disable direct root SSH access.
4. Disable password-based SSH authentication after key access has been verified.
5. Enable a host-based firewall.
6. Use Fail2ban to protect against repeated authentication attempts.
7. Keep system packages updated.
8. Apply least-privilege permissions.
9. Validate configuration changes before restarting services.
10. Monitor logs and verify the resulting server state.

---

## Related Documentation

- [Project README](../README.md)
- [Operational Runbook](runbook.md)
- [Server Hardening Script](../scripts/secure-server.sh)
- [Server Verification Script](../scripts/verify-server.sh)

---

> **Security Reminder:** Never make remote SSH configuration changes without maintaining a working recovery path. Always back up the configuration, validate it with `sshd -t`, and test a new SSH connection before closing your existing session.
