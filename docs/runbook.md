# Linux Server Hardening — Operational Runbook

> A step-by-step operational guide for hardening, verifying, troubleshooting, and recovering an Ubuntu Linux server.

---

## 1. Purpose

This runbook documents the standard procedure for securing an Ubuntu Linux server using the automation provided in this repository.

The project focuses on:

- SSH hardening
- SSH key-based authentication
- Firewall configuration with UFW
- Brute-force protection with Fail2ban
- Server security verification
- Basic system health checks
- Configuration validation and recovery

The goal is to make the server secure while maintaining a reliable recovery path.

---

# 2. Project Structure

```text
linux-server-hardening/
│
├── README.md
├── LICENSE
│
├── scripts/
│   ├── secure-server.sh
│   └── verify-server.sh
│
└── docs/
    ├── commands.md
    └── runbook.md
```

### Scripts

| Script | Purpose |
|---|---|
| `secure-server.sh` | Automates the main server-hardening tasks |
| `verify-server.sh` | Verifies the resulting server configuration and health |

---

# 3. Prerequisites

Before starting, make sure you have:

- An Ubuntu Linux server
- SSH access to the server
- A user with `sudo` privileges
- SSH key authentication configured
- Internet connectivity
- Git installed
- The project repository available on the server

Verify the current user:

```bash
whoami
```

Verify sudo access:

```bash
sudo -l
```

Check the operating system:

```bash
cat /etc/os-release
```

---

# 4. Connect to the Server

Connect using SSH:

```bash
ssh -i <private-key> <username>@<server-ip>
```

Example:

```bash
ssh -i ~/Downloads/server.pem ubuntu@<server-ip>
```

After connecting, verify the server:

```bash
hostname
```

```bash
uptime
```

```bash
whoami
```

---

# 5. Clone the Repository

Clone the project:

```bash
git clone git@github.com:<username>/linux-server-hardening.git
```

Move into the project:

```bash
cd linux-server-hardening
```

Verify the project structure:

```bash
ls -la
```

---

# 6. Prepare the Scripts

Make the scripts executable:

```bash
chmod +x scripts/*.sh
```

Verify:

```bash
ls -l scripts/
```

The scripts should have executable permissions.

---

# 7. Pre-Hardening Assessment

Before making security changes, record the current server state.

## Check SSH

```bash
sudo systemctl status ssh
```

## Check Firewall

```bash
sudo ufw status
```

## Check Fail2ban

```bash
sudo systemctl status fail2ban
```

If Fail2ban is not installed, this is expected before hardening.

## Check Listening Ports

```bash
sudo ss -tulpn
```

Record which ports are currently exposed.

## Check System Resources

```bash
free -h
```

```bash
df -h
```

```bash
uptime
```

This provides a baseline for comparison after hardening.

---

# 8. SSH Safety Procedure

SSH is the most important part of this process because an incorrect SSH configuration can lock you out of a remote server.

Before changing SSH configuration:

### Keep Your Current SSH Session Open

Do not close the current SSH session.

Open another terminal for testing after making the changes.

---

## Verify SSH Key Access

Before disabling password authentication, make sure SSH key authentication works.

From another terminal:

```bash
ssh -i <private-key> <username>@<server-ip>
```

Confirm that the new session works.

Only then proceed with SSH hardening.

---

# 9. Run the Hardening Script

From the repository root:

```bash
sudo ./scripts/secure-server.sh
```

The script is responsible for automating the main security configuration.

The hardening process includes the security controls implemented by the script, such as:

- Package updates
- Firewall configuration
- Fail2ban installation/configuration
- SSH security configuration
- SSH configuration validation
- Service management
- Logging

Follow the output of the script and check for errors.

---

# 10. SSH Configuration Validation

After the hardening script modifies SSH configuration, validate it:

```bash
sudo sshd -t
```

### Expected Result

No output normally means the configuration passed the syntax check.

If an error appears:

```text
sshd: /etc/ssh/sshd_config line X: ...
```

do **not** restart SSH.

Fix the configuration first.

---

# 11. Verify SSH Service

Check SSH:

```bash
sudo systemctl status ssh
```

Check whether it is active:

```bash
systemctl is-active ssh
```

Expected:

```text
active
```

---

# 12. Test a New SSH Connection

Open a **new terminal** on your local machine.

Connect again:

```bash
ssh -i <private-key> <username>@<server-ip>
```

Verify:

```bash
whoami
```

If the new connection works successfully, the SSH hardening process can be considered accessible.

Keep the original SSH session open until this test succeeds.

---

# 13. Verify Firewall

Check UFW:

```bash
sudo ufw status verbose
```

Expected:

```text
Status: active
```

Check numbered rules:

```bash
sudo ufw status numbered
```

Verify that SSH access is allowed.

For example:

```text
22/tcp
```

or:

```text
OpenSSH
```

Only expose ports that are actually required by the server.

---

# 14. Verify Fail2ban

Check the service:

```bash
sudo systemctl status fail2ban
```

Check the overall Fail2ban status:

```bash
sudo fail2ban-client status
```

Check the SSH jail:

```bash
sudo fail2ban-client status sshd
```

Review Fail2ban logs if required:

```bash
sudo journalctl -u fail2ban
```

---

# 15. Run Automated Verification

Once hardening is complete, run:

```bash
sudo ./scripts/verify-server.sh
```

The verification script checks the resulting server state.

Typical checks include:

- SSH service
- UFW firewall
- Fail2ban
- Password authentication
- Root SSH login
- Public-key authentication
- CPU usage
- Memory usage
- Disk usage
- Listening ports
- Security score

---

# 16. Expected Security State

The hardened server should have the following security characteristics:

```text
SSH Service                  Running
Password Authentication      Disabled
Root SSH Login               Disabled
Public Key Authentication    Enabled
UFW Firewall                 Enabled
Fail2ban                     Running
SSH Configuration            Valid
```

The exact verification output may vary depending on the server environment.

---

# 17. Review Listening Ports

Check all listening services:

```bash
sudo ss -tulpn
```

Review every exposed port.

For example:

```text
22/tcp
80/tcp
443/tcp
```

Only ports required by the server workload should remain accessible.

---

# 18. Review Hardening Logs

The hardening script writes its log to:

```text
/var/log/server-hardening.log
```

View the log:

```bash
sudo cat /var/log/server-hardening.log
```

View the latest entries:

```bash
sudo tail -n 50 /var/log/server-hardening.log
```

Follow the log in real time:

```bash
sudo tail -f /var/log/server-hardening.log
```

---

# 19. Troubleshooting SSH

## SSH Connection Fails

Do not immediately terminate the current SSH session.

Use the existing session to investigate.

Check SSH service:

```bash
sudo systemctl status ssh
```

Validate configuration:

```bash
sudo sshd -t
```

Check recent logs:

```bash
sudo journalctl -u ssh --no-pager -n 50
```

Check authentication logs:

```bash
sudo tail -n 50 /var/log/auth.log
```

---

# 20. SSH Configuration Recovery

If the SSH configuration is invalid or causes unexpected behavior, restore the backup created before the configuration change.

List available backups:

```bash
ls -lah /etc/ssh/sshd_config*.bak
```

Restore the appropriate backup:

```bash
sudo cp /etc/ssh/sshd_config.<backup> /etc/ssh/sshd_config
```

Validate:

```bash
sudo sshd -t
```

Restart SSH:

```bash
sudo systemctl restart ssh
```

Test a new connection before closing the existing session.

---

# 21. Firewall Troubleshooting

Check firewall status:

```bash
sudo ufw status verbose
```

List numbered rules:

```bash
sudo ufw status numbered
```

If SSH access is blocked, ensure SSH is allowed:

```bash
sudo ufw allow OpenSSH
```

Reload UFW:

```bash
sudo ufw reload
```

Then test SSH from another terminal.

---

# 22. Fail2ban Troubleshooting

Check service status:

```bash
sudo systemctl status fail2ban
```

Check Fail2ban:

```bash
sudo fail2ban-client status
```

Check the SSH jail:

```bash
sudo fail2ban-client status sshd
```

View logs:

```bash
sudo journalctl -u fail2ban --no-pager -n 50
```

Restart if necessary:

```bash
sudo systemctl restart fail2ban
```

---

# 23. System Health Check

After hardening, check basic system health.

## CPU

```bash
top
```

## Memory

```bash
free -h
```

## Disk

```bash
df -h
```

## Processes

```bash
ps aux
```

## Uptime and Load

```bash
uptime
```

## Network Ports

```bash
sudo ss -tulpn
```

---

# 24. Rollback Procedure

If the hardening process causes unexpected behavior:

### Step 1

Keep the current SSH session open.

### Step 2

Identify the failing component.

### Step 3

For SSH issues, restore the backed-up configuration.

### Step 4

Validate the restored configuration:

```bash
sudo sshd -t
```

### Step 5

Restart the affected service:

```bash
sudo systemctl restart ssh
```

### Step 6

Test a new SSH connection.

### Step 7

Run the verification script again:

```bash
sudo ./scripts/verify-server.sh
```

---

# 25. Operational Checklist

Use this checklist when completing the hardening process.

## Access

- [ ] SSH access confirmed
- [ ] SSH key authentication confirmed
- [ ] Non-root administrative user available
- [ ] Sudo access confirmed

## SSH Security

- [ ] SSH configuration backed up
- [ ] Password authentication disabled
- [ ] Root SSH login disabled
- [ ] Public-key authentication enabled
- [ ] SSH configuration validated
- [ ] New SSH connection tested

## Firewall

- [ ] UFW installed
- [ ] UFW enabled
- [ ] SSH access allowed
- [ ] Only required ports exposed
- [ ] Firewall rules reviewed

## Fail2ban

- [ ] Fail2ban installed
- [ ] Fail2ban service running
- [ ] SSH jail available
- [ ] Fail2ban status checked

## Verification

- [ ] Verification script executed
- [ ] Security score reviewed
- [ ] Listening ports reviewed
- [ ] System resources checked
- [ ] Logs reviewed

---

# 26. Standard Operating Procedure

The complete workflow can be summarized as:

```text
┌──────────────────────────┐
│  1. Connect to Server    │
└────────────┬─────────────┘
             ↓
┌──────────────────────────┐
│  2. Check Current State  │
└────────────┬─────────────┘
             ↓
┌──────────────────────────┐
│  3. Verify SSH Key       │
└────────────┬─────────────┘
             ↓
┌──────────────────────────┐
│  4. Run Hardening Script │
└────────────┬─────────────┘
             ↓
┌──────────────────────────┐
│  5. Validate SSH Config  │
└────────────┬─────────────┘
             ↓
┌──────────────────────────┐
│  6. Test New SSH Session │
└────────────┬─────────────┘
             ↓
┌──────────────────────────┐
│  7. Verify Firewall      │
└────────────┬─────────────┘
             ↓
┌──────────────────────────┐
│  8. Verify Fail2ban      │
└────────────┬─────────────┘
             ↓
┌──────────────────────────┐
│  9. Run Verification     │
└────────────┬─────────────┘
             ↓
┌──────────────────────────┐
│ 10. Review Logs & Ports  │
└──────────────────────────┘
```

---

# 27. Recovery Principle

The most important operational principle in this project is:

```text
Backup
   ↓
Change
   ↓
Validate
   ↓
Restart
   ↓
Test
   ↓
Verify
```

Never make a remote security change without a recovery path.

---

## Related Documentation

- [Project README](../README.md)
- [Command Reference](commands.md)
- [Server Hardening Script](../scripts/secure-server.sh)
- [Server Verification Script](../scripts/verify-server.sh)

---

> **Security Reminder:** Always keep an active SSH session while modifying remote SSH configuration. Validate changes with `sshd -t` before restarting SSH, and test a new connection before closing your existing session.
