# Linux Server Hardening — Architecture

> High-level architecture of the Linux server hardening and verification workflow.

---

## System Architecture

```mermaid
flowchart LR

    A["👩‍💻 Developer<br/>Local Machine"]

    B["🔑 SSH Key<br/>Authentication"]

    C["☁️ Ubuntu Linux Server"]

    D["🔐 SSH Hardening<br/><br/>• Password Auth OFF<br/>• Root Login OFF<br/>• Public Key ON"]

    E["🛡️ UFW Firewall<br/><br/>Controls Network Access"]

    F["🚫 Fail2ban<br/><br/>Protects SSH<br/>Against Repeated Attacks"]

    G["🔎 Server Verification<br/><br/>Security & Health Checks"]

    H["📊 Verification Report"]

    I["⚙️ secure-server.sh<br/><br/>Hardening Automation"]

    J["🧪 verify-server.sh<br/><br/>Verification Automation"]


    A --> B
    B --> C

    I --> D
    D --> E
    E --> F
    F --> G

    J --> G
    G --> H
```

---

## Security Flow

The server follows a layered security model:

```mermaid
flowchart TD

    A["Ubuntu Linux Server"]

    A --> B["Layer 1<br/>SSH Authentication"]
    B --> C["Layer 2<br/>SSH Configuration Hardening"]
    C --> D["Layer 3<br/>UFW Firewall"]
    D --> E["Layer 4<br/>Fail2ban"]
    E --> F["Layer 5<br/>Verification & Monitoring"]

    F --> G["Hardened Server"]
```

---

## Automation Workflow

The hardening process is automated through `secure-server.sh`.

```mermaid
flowchart TD

    A["Start"] --> B["Update System"]
    B --> C["Configure UFW"]
    C --> D["Install & Configure Fail2ban"]
    D --> E["Backup SSH Configuration"]
    E --> F["Apply SSH Hardening"]
    F --> G["Validate SSH Configuration"]
    G --> H{"Configuration Valid?"}

    H -->|Yes| I["Restart SSH"]
    H -->|No| J["Stop & Report Error"]

    I --> K["Enable Services"]
    K --> L["Verify Services"]
    L --> M["Hardening Complete"]
```

---

## Verification Workflow

The `verify-server.sh` script audits the final server state.

```mermaid
flowchart TD

    A["Start Verification"] --> B["Check SSH Service"]
    B --> C["Check UFW"]
    C --> D["Check Fail2ban"]
    D --> E["Check SSH Security"]
    E --> F["Check System Health"]
    F --> G["Check Listening Ports"]
    G --> H["Calculate Security Status"]
    H --> I["Generate Verification Report"]
```

---

## Security Controls

| Component | Responsibility |
|---|---|
| SSH Keys | Secure remote authentication |
| SSH Hardening | Restricts insecure SSH access |
| UFW | Controls inbound network traffic |
| Fail2ban | Mitigates repeated authentication attempts |
| `secure-server.sh` | Automates hardening |
| `verify-server.sh` | Audits the final server state |

---

## Operational Flow

```text
Connect
   ↓
Assess
   ↓
Backup
   ↓
Harden
   ↓
Validate
   ↓
Restart
   ↓
Test
   ↓
Verify
   ↓
Report
```

---

## Design Principle

The project follows a simple DevOps security principle:

> **Automate the configuration, validate the changes, and verify the resulting state.**
