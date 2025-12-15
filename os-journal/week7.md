## Phase 7 - Security Audit and System Evaluation

This week focused on conducting a comprehensive security audit of the Raspberry Pi OS Lite server and evaluating the overall system configuration. The goal was to identify any remaining security risks, verify that all security measures from previous phases are effective, and justify the current system configuration.

The audit combined automated security scanning, network assessment, access control verification, service review, and configuration evaluation to produce a detailed security baseline and risk assessment.

### Security Scanning with Lynis

Lynis is a widely-used auditing tool for Unix-based systems. It scans for configuration issues, security risks, and compliance gaps.

#### Installation and Initial Scan
```bash
sudo apt install lynis
sudo lynis audit system
```

The initial scan produced a security report highlighting warnings and suggestions across authentication, user accounts, system software, network configuration, and logging.

[lynis-before.dat](logs/lynis-before.dat)

TODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODO

Observation: The initial hardening index indicated areas for improvement, including SSH configuration, firewall rules, and unused services.

#### Remediation and Rescan

After reviewing the recommendations, the following actions were applied:

SSH key-based authentication enforced, root login disabled.
UFW firewall rules restricted connections to the client workstation only.
AppArmor profiles enabled for all critical applications.
Removed unused packages and disabled unnecessary services.

Rescanning with Lynis confirmed an improved hardening score:

[lynis-after.dat](logs/lynis-after.dat)

![alt text](<img/week7/Screenshot 2025-12-15 215234.png>)

TODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODO

The security posture is significantly improved with no critical issues remaining.

### Network Security Assessment with nmap

nmap was used to assess network exposure and detect open ports:

```bash
nmap -sS -p- 192.168.1.64
nmap -A 192.168.1.64
```

#### Findings:


### Access Control Verification

User and sudo privileges were verified:
```bash
getent passwd
getent group sudo
```

Only trusted accounts have sudo rights.

AppArmor enforcement confirmed:

```bash
sudo apparmor_status
```

All profiles are in enforce mode, and no violations were reported.

Access control is correctly implemented, with separation of privileges and process confinement in place.

### Service Audit and Justification

Active services were reviewed using:
systemctl list-units --type=service --state=running

Service Inventory with Justifications:
TODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODO

### System Configuration Review
Key configuration checks:

### Remaining Risk Assessment
Risk	Likelihood	Impact	Mitigation

## Summary
