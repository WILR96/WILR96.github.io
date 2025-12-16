## Phase 7 - Security Audit Report

This week focused on conducting a comprehensive security audit of the Raspberry Pi server and evaluating the overall system configuration. The goal was to identify any remaining security risks, verify that all security measures from previous phases are effective and justify the current system configuration.

The audit combined automated security scanning with lynis, network assessment via nmap, access control verification with AppArmor, service review using systemctl and configuration evaluation to produce a detailed security baseline and risk assessment.

### Security Scanning with Lynis

Lynis is a widely-used auditing tool for Unix-based systems. It scans for configuration issues, security risks and compliance gaps.

#### Installation and Initial Scan
```bash
sudo apt install lynis
sudo lynis audit system
```

The initial scan produced a security report highlighting warnings and suggestions across authentication, user accounts, system software, network configuration and logging:

| Area | Finding | Risk |
|------|--------|--------|
| Firewall | Disabled at audit start | Unrestricted inbound access if services exposed |
| Auditing | auditd not enabled	| No audit trail of system activity |
| Process Accounting | Not enabled | No visibility of executed commands |
| Performance Monitoring | sysstat not installed | No historical resource usage data |
| IDS / IPS | None present | No intrusion detection capability |
| Malware Detection | Not installed | Potential persistence of malicious files |
| File Integrity Monitoring | Not configured | Unauthorized file changes undetectable |
| Password Policy |	No aging or complexity rules | Weak credentials possible |
| Automatic Updates | Disabled | Security patches not applied automatically |
| Logging |	Basic logging only | Limited forensic capability |
| Mandatory Access Control | Inactive |	No application-level confinement |
| SSH Hardening | Permissive defaults | Increased attack surface |
| Monitoring | No active alerting | Attacks could go unnoticed |
| Package Integrity | Not enabled | Tampered packages undetectable |

Lynis score before: 64

[lynis-before.dat](logs/lynis-before.dat)

Observation: The initial hardening index indicated areas for improvement, including SSH configuration, firewall rules and unused services.

#### Remediation and Rescan

Following the initial Lynis audit, targeted remediation steps were applied to address the most significant security findings. The focus was on strengthening access control, reducing the attack surface, and enforcing layered defensive controls, rather than attempting to enable every optional or enterprise-grade feature.

The following actions were implemented:

![alt text](<img/week7/Screenshot 2025-12-16 220615.png>)
SSH access was hardened by enforcing key-based authentication and disabling direct root login via /etc/ssh/sshd_config. This ensures that only authorised users in possession of valid private keys can access the system and eliminates password-based brute-force attacks against privileged accounts.


![alt text](<img/week7/Screenshot 2025-12-15 161248.png>)
The UFW firewall was re-enabled and configured with a ip whitelist with a port specified, restricting inbound SSH connections to the trusted client workstation IP only. The firewall now enforces a default-deny ruleset, significantly reducing network exposure.

![alt text](<img/week7/Screenshot 2025-12-16 213019.png>)
Mandatory Access Control was activated by enabling AppArmor at boot and setting all available and relevant profiles to enforce mode. Additional AppArmor profiles were installed to extend coverage to common system services, limiting the potential impact of service compromise.

![alt text](<img/week7/Screenshot 2025-12-15 161421.png>)
Host-based intrusion prevention was introduced by installing and configuring Fail2Ban. The SSH jail was enabled and tuned to automatically block repeated authentication failures, providing active protection against brute-force attempts on the SSH service.

![alt text](<img/week7/Screenshot 2025-12-16 220754.png>)
System accountability and monitoring were improved by enabling audit logging and process accounting. The auditd service was installed and activated to provide an audit trail of system events, while acct and sysstat were enabled to record process execution history and system activity metrics for later analysis.

![alt text](<img/week7/Screenshot 2025-12-16 220930.png>)
Malware detection capabilities were added by installing ClamAV, with virus definition databases present and scheduled scans configured. This introduces an additional defensive layer to detect potentially malicious files on the system.


File integrity monitoring was implemented using Tripwire, allowing detection of unauthorised changes to critical system files and configurations through scheduled integrity checks.

Automated security patching was enabled using unattended-upgrades, ensuring that security updates are applied automatically without requiring manual intervention, reducing exposure to known vulnerabilities.

Package integrity verification tools were installed, including debsums and apt-show-versions, to detect modified packages and assist with version tracking and update validation.

Finally, unused packages were removed and unnecessary services were disabled to further reduce the system’s attack surface and minimise potential vectors for exploitation.

After applying these changes, the system was rescanned using Lynis:

Lynis score after: 81

[lynis-after.dat](logs/lynis-after.dat)

![alt text](<img/week7/Screenshot 2025-12-15 215234.png>)

The rescan confirmed a clear improvement in the system’s security posture, reflected by an increased hardening index and a reduction in high-priority warnings. Remaining findings were primarily related to advanced kernel hardening, extended audit rule definitions and enterprise monitoring features.

These results demonstrate that targeted remediation based on audit feedback can measurably improve system security while maintaining system stability, usability, and performance.

### Network Security Assessment with nmap

nmap was used to assess network exposure and detect open ports:

```bash
nmap -sV -v -Pn 192.168.1.64
```
![alt text](img/week7/nmapscan.png)
#### Findings:

![alt text](img/week7/nmapscan.png)

All scanned TCP ports are filtered, meaning the firewall is actively dropping unsolicited packets.

No services are exposed to unauthorized hosts.

-Pn ensures that the host is treated as online, confirming that the lack of responses is due to filtering, not host unavailability.

If we specify the ssh port we are using then we get a result back:

![alt text](<img/week7/Screenshot 2025-12-16 204115.png>)

### SSH security verification

```bash
sudo sshd -T | grep -E "password|rootlogin|keyauthe"
```
Result
![alt text](<img/week7/Screenshot 2025-12-16 210649.png>)


```bash
ssh root@192.168.1.64
```
Result
![alt text](<img/week7/Screenshot 2025-12-16 210735.png>)


```bash
ssh reece@192.168.1.64
```
Result
![alt text](<img/week7/Screenshot 2025-12-16 211429.png>)

```bash
ssh -p 8239 root@192.168.1.64
```
![alt text](<img/week7/Screenshot 2025-12-16 210842.png>)


```bash
ssh -p 8239 reece@192.168.1.64
```
![alt text](<img/week7/Screenshot 2025-12-16 210906.png>)

### Access Control Verification

User and sudo privileges were verified using the security-baseline script:

![alt text](<img/week7/Screenshot 2025-12-16 212453.png>)

Only trusted accounts have sudo rights.

AppArmor enforcement confirmed:

```bash
sudo apparmor_status
```
![alt text](<img/week7/Screenshot 2025-12-16 213019.png>)


All profiles are in enforce mode, and no violations were reported.

Access control is correctly implemented, with separation of privileges and process confinement in place.

### Service Audit and Justification

Active services were reviewed using:
systemctl list-units --type=service --state=running

![alt text](<img/week7/Screenshot 2025-12-16 213751.png>)

Service Inventory with Justifications:
| Service | Justification |
|------|-----------------|
| auditd | Provides system-level security auditing and accountability by recording security-relevant events. |
| cron |	Required for scheduled scans, updates, logs |
| dbus |	Core OS dependency, Required for stable system operation. |
| fail2ban | Intrusion prevention system used to detect and block repeated authentication failures. |
| ssh | Required for secure remote administration of the headless Raspberry Pi. |
| systemd-journald | Centralised logging service required for system diagnostics, auditing, and forensic analysis. |
| systemd-logind | User session handling |
| systemd-timesyncd | Time sync (important for logs & TLS) |
| systemd-udevd | Handles device events and hardware management. Required for correct operation of system hardware. |
| unattended-upgrades | Automatically installs security updates to reduce exposure to known vulnerabilities without manual intervention. |
| user@1000 | Normal user session |
| wpa_supplicant | Required for wireless network authentication. Retained as the system uses Wi-Fi connectivity. |
| NetworkManager | Manages network configuration and connectivity. Required to maintain reliable network access on the Raspberry Pi deployment. |

### System Configuration Review
Key configuration checks:

A final configuration review was conducted to ensure that security controls were consistently enforced across the system and aligned with the intended threat model of a single-node, headless Raspberry Pi server.

Key configuration checks included:

- SSH configuration
- PasswordAuthentication disabled
- PermitRootLogin disabled
- Non-standard SSH port in use
- Access restricted by firewall and Fail2Ban

These measures collectively reduce brute-force and credential-based attack risk.

## Firewall configuration
- UFW enabled at boot
- Default deny policy applied
- Explicit allow rules limited to a single trusted client IP and SSH port

This ensures that no unintended network services are reachable.

## Mandatory Access Control
- AppArmor enabled and enforcing at boot
- All available profiles loaded in enforce mode
- No profiles in complain or disabled state

This limits the potential impact of service compromise by constraining process behaviour.

## User and privilege management
- Only one non-root administrative user present
- sudo access restricted to trusted account
- No shared or unused accounts detected

This enforces separation of privileges and reduces insider risk.

## Logging and auditing
- systemd-journald active
- auditd enabled and running
- Log rotation configured

Logs are retained locally to support accountability and post-incident analysis.

## Update and integrity mechanisms
- unattended-upgrades enabled
- debsums used for package integrity verification
- apt-show-versions installed for version tracking

This reduces exposure to known vulnerabilities and supply-chain risks.

Overall, the system configuration reflects a hardened baseline appropriate for a small-scale, educational deployment, balancing security with maintainability and performance.

### Remaining Risk Assessment
| Risk | Likelihood | Impact | Mitigation |
|------|---|---|------------------|
| Administrator lockout | Low | High  | SSH key-only access improves security but increases risk of lockout if keys are lost. Mitigated by secure key backups. | 
| USB and removable media enabled | Low | Low | Physical access to device is controlled. Risk accepted given deployment environment. | 
| SSH private key compromise (client-side) | Medium | High | This is the most realistic attack path. If the client workstation is compromised, SSH access could be gained. Risk is partially mitigated by sudo logging, auditd, and AppArmor confinement. Risk accepted as endpoint security is outside server control. | 
| Physical access attacks | Very Low | High | Physical access could allow SD card extraction or boot manipulation. Risk accepted due to controlled physical environment and educational scope. | 

## Summary
This phase delivered a comprehensive security audit and system evaluation of the Raspberry Pi server. Automated scanning with Lynis identified multiple weaknesses in the initial configuration, which were systematically addressed through targeted remediation.

Improvements included firewall enforcement, SSH hardening, intrusion prevention, malware detection, file integrity monitoring, audit logging, automated patching, and mandatory access control. Network scanning with nmap confirmed that the system does not expose unintended services, and access control verification demonstrated correct privilege separation and AppArmor enforcement.

The final Lynis hardening score increased from 64 to 81, reflecting a significant improvement in the system’s security posture. Remaining findings were primarily related to advanced or enterprise-focused controls and were formally documented as residual risks.

Overall, the system now demonstrates defence-in-depth, principle of least privilege, and secure-by-default configuration, while maintaining operational stability and usability.