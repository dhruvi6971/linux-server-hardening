<div align="center">

# 🔒 Linux Server Hardening

### Production-ready Ubuntu Server Security for DevOps Engineers

Secure a fresh Ubuntu server using industry best practices including SSH key authentication, UFW Firewall, Fail2ban, least-privilege access, and automated verification.

[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Linux](https://img.shields.io/badge/Linux-Administration-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org/)
[![Bash](https://img.shields.io/badge/Bash-Scripting-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![GitHub](https://img.shields.io/badge/GitHub-Portfolio-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/)
</div>

---

# 📖 Table of Contents

- Overview
- Architecture
- Features
- Project Structure
- Technologies
- Server Hardening Steps
- Verification
- Screenshots
- Lessons Learned
- Future Improvements

---

# 🚀 Overview

This project demonstrates how to secure a freshly installed Ubuntu server following DevOps and system administration best practices.

Instead of manually configuring every server, this project documents the complete hardening process and provides reusable scripts for verification and automation.

---

# 🎯 Objectives

- Secure SSH access
- Disable password authentication
- Disable root login
- Configure UFW Firewall
- Install Fail2ban
- Create least-privilege users
- Verify server security
- Document every configuration

---

# 🏗 Architecture

```text
                 Local Machine
                      │
               SSH Key Authentication
                      │
         ─────────────────────────
                      │
              Ubuntu Server
                      │
     ┌──────────────────────────────┐
     │                              │
     │  SSH Service                 │
     │  UFW Firewall                │
     │  Fail2ban                    │
     │  Linux Users                 │
     │  Verification Script         │
     └──────────────────────────────┘
```

---

# ✨ Features

- SSH Key Authentication
- Password Login Disabled
- Root Login Disabled
- UFW Firewall Configured
- Fail2ban Protection
- Secure User Management
- Server Verification Script
- Documentation & Runbook

---

# 📂 Project Structure

```text
linux-server-hardening/

├── README.md
├── LICENSE
│
├── docs/
│   ├── commands.md
│   ├── runbook.md
|   ├── architecture.md
│   └── screenshots/
│
├── scripts/
    ├── secure-server.sh
    └── verify-server.sh
```

---

# 🛠 Technologies

- Ubuntu Server
- Linux
- Bash
- SSH
- UFW
- Fail2ban
- Git
- GitHub

---

# 🔐 Server Hardening Checklist

- [x] System Updated
- [x] New User Created
- [x] Sudo Access Configured
- [x] SSH Keys Configured
- [x] Password Authentication Disabled
- [x] Root Login Disabled
- [x] UFW Firewall Enabled
- [x] Fail2ban Installed
- [x] SSH Service Verified

---

# 🖥 Verification

```bash
systemctl status ssh

ufw status

fail2ban-client status

sudo -l

whoami
```

---

# 📸 Screenshots

## SSH Login

> Add screenshot here

---

## UFW Firewall

> Add screenshot here

---

## Fail2ban

> Add screenshot here

---

## Verification Script Output

> Add screenshot here

---

# 📚 Lessons Learned

- Linux user management
- SSH authentication
- Firewall configuration
- Service management
- Linux security best practices

---

# 🚀 Future Improvements

- Automated hardening script
- CIS Benchmark checks
- Security auditing
- Telegram alerts
- Ansible automation

---

# 👨‍💻 Author

**Dhruvi Dhanani**

Aspiring DevOps Engineer

Currently building real-world DevOps projects while mastering Linux, Cloud, Docker, Kubernetes, and Infrastructure as Code.

⭐ If you found this project helpful, consider giving it a star!
