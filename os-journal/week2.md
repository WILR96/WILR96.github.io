# Week 2 - Security Planning and Testing Methodology 

## Performance Testing Plan
The goal of this week is to design a security baseline and performance testing methodology, I will outline how i will monitor the server remotely to understand the effect of diffrent workloads.

All testing will be done from the client (Windows Machine) over SSH to the server (Raspberry PI). I plan to make a script to automate collecting CPU, memory, disk, network and temperature readings into a human readable format that can be read from the windows client without having to run each command individually as this will avoid human error and ensure consistency . 

This script will be ran over SSH in the terminal and timestamped for logging and will be copied back to the client machine for analysis. I will use it to measure how the server handles different applications, as well as to see how I can learn to troubleshoot any bottlenecks or performance hurdles. 

I will test the server under no application load to get a baseline, then use various applications in order to simulate real activity. After collecting all the data, I will analyse the results to see any performance bottlenecks, focusing on CPU load, memory usage, I/O performance, and thermal behaviour.

These are the commands I’ll be using in order to test the performance of the server:

### **CPU Usage and Load** 
**top:**

 Display running processes, showing CPU and memory usage. Used to see which processes are using the most resources.
 
**uptime:** (no longer used, top shows uptime.)

Shows how long the system has been running and provides the system load average.

**mpstat:**

Displays CPU usage statistics, including idle time and percentage of time spent waiting on I/O.

### **RAM and Swap**
**free -h:**

Displays total, used, and available memory.

**vmstat:**

Reports memory, swap, and process statistics.

### **Storage / IO speeds**
**df -h:**

Shows total and available disk space on all mounted filesystems. Useful for checking capacity and monitoring growth over time.

**iotop:**

Monitors disk I/O activity in real time, showing which processes are reading or writing most heavily to the storage device.

**hdparm -tT:** (did not work in tests)

Performs a direct read speed test on the Raspberry Pi’s SD card, providing sequential and cached read performance metrics.

**dd:** 

Used to benchmark SD card read and write performance by creating test files and measuring raw I/O throughput, helping identify storage bottlenecks during performance testing.


### **Network Performance**
**iperf:**

Measures network bandwidth and throughput between the server and the client workstation.

**ss -tunap:**

Shows active and listening TCP/UDP connections with associated processes.

**ping:**

Tests basic network connectivity and latency between devices, helping to detect packet loss or network instability.

**netstat -i:**

Displays network interface statistics such as transmitted and received packets, errors, and drops.

### **System Temperatures**
**vcgencmd measure_temp:**

Check to see if the device is overheating or running too hot.

**vcgencmd get_throttled:**

Check to see if it has been throttled due to power or temperature

### Security Configuration Checklist 

| Area | How | Why |
|------|--------------|----------------|
| SSH Hardening | Turn off password login, only allow SSH keys | Stops anyone guessing passwords to get in |
||Disable direct root login | Reduces risk if someone tries to hack the root account |
||Change the SSH port to something other than 22 | Avoids random automated scans hitting default SSH port |
|| Install Fail2Ban | Blocks repeated login attempts automatically |
| Firewall Configuration | Turn on UFW, block everything except SSH | Limits who can even talk to the server |
| Mandatory Access Control | Enable AppArmor | Makes sure programs only do what they’re supposed to |
| Automatic Updates | Turn on automatic security updates | Keeps the server patched without me thinking about it |
| User Privilege Management | Make separate admin and normal user accounts | Keeps privileges limited, follows “least privilege” |
|| Restrict sudo usage | Stops users from accidentally or intentionally gaining root |
| Network Security | Turn off services I don’t need | Reduces potential attack points |
|| configure hosts.allow/hosts.deny | another layer of network filtering |
| Scheduled Tasks | Check cron jobs and fix permissions | Prevents unwanted scripts from running |
| Logging | Make sure logs exist and rotate them | Helps me spot issues and avoids logs filling up storage |

### Threat Model
| Threat | Impact | Mitigation |
|------|--------------|----------------|
| Brute-force SSH attacks | Could allow unauthorized access if passwords are weak | Disable password login, install Fail2Ban |
| Unauthorized local privilege escalation | Could allow users to read sensitive information or take over the server | restrict sudo, enable AppArmor, audit running services and cronjobs |
| man-in-the-middle | intercept sensitive data | Use SSH keys, avoid unsecured networks, enforce firewall restrictions |
| Installing unknown packages or scripts | Could introduce malware or backdoors | Only install from trusted repositories, review scripts before execution |
| Software vulnerabilities | Exploitation of known CVEs in outdated packages | Enable unattended-upgrades, keep system updated, monitor package versions |
| Physical access to device | SD card extraction, offline tampering | Controlled physical environment, risk accepted due to deployment context |
| Supply chain attacks | Compromised packages or updates | Package integrity checks, official repositories only |


[WEEK 3](/os-journal/week3.md)



