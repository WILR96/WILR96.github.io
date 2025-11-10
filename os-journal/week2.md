# Week 2 - Security Planning and Testing Methodology 

## performance testing plan

These are the commands I’ll be using in order to test the performance of the server, and also to see how effective the network is between the client and server. I will use them to measure how the server handles different applications, as well as to see how I can learn to troubleshoot any bottlenecks or performance hurdles.

### **CPU Usage and Load** 
- top: Display running processes, showing CPU and memory usage. Used to see which processes are using the most resources.
- uptime: Shows how long the system has been running and provides the system load average.
- mpstat: Displays CPU usage statistics, including idle time and percentage of time spent waiting on I/O.

### **RAM and Swap**
-  free -h: Displays total, used, and available memory.
- vmstat: Reports memory, swap, and process statistics.

### **Storage / IO speeds**
- -df -h: Shows total and available disk space on all mounted filesystems. Useful for checking capacity and monitoring growth over time.
- iotop: Monitors disk I/O activity in real time, showing which processes are reading or writing most heavily to the storage device.
- hdparm -tT: Performs a direct read speed test on the Raspberry Pi’s SD card, providing sequential and cached read performance metrics.

### **Network Performance**
- iperf: Measures network bandwidth and throughput between the server and the client workstation.
- ping: Tests basic network connectivity and latency between devices, helping to detect packet loss or network instability.
- netstat -i: Displays network interface statistics such as transmitted and received packets, errors, and drops.

### **System Temperatures**
- vcgenmd measure_temp: Check to see if the device is overheating or running too hot.
- vcgenmd get_throttled: Check to see if it has been throttled due to power or temperature

All testing will be done from the client (Windows Machine) over SSH to the server (Raspberry PI). I plan to make a script to automate collecting all of this data into a human readable format that can be read from the windows client without having to run each command individually, as this will ensure consistency. This script will be ran over SSH in the terminal and timestamped for logging and will be copied back to the client machine for analysis.

I will test the server under no application load to get a baseline, then use various applications in order to simulate real activity. I will also use the Linux task scheduler (cron) in order to run continuous logging to see how the performance changes over time.

After collecting all the data, I will analyse the results to see any performance bottlenecks, focusing on CPU load, memory usage, I/O performance, and thermal behaviour.

### Security Configuration Checklist 

| Area | How | Why |
|------|--------------|----------------|
| SSH Hardening | Turn off password login, only allow SSH keys | Stops anyone guessing passwords to get in |
| User Accounts | Make separate admin and normal user accounts | Keeps privileges limited, follows “least privilege” |
| Root Login | Disable direct root login | Reduces risk if someone tries to hack the root account |
| SSH Port | Change the SSH port to something other than 22 | Avoids random automated scans hitting default SSH port |
| Intrusion Protection | Install Fail2Ban | Blocks repeated login attempts automatically |
| Firewall | Turn on UFW, block everything except SSH | Limits who can even talk to the server |
| Mandatory Access Control | Enable AppArmor | Makes sure programs only do what they’re supposed to |
| Updates | Turn on automatic security updates | Keeps the server patched without me thinking about it |
| Privilege Management | Restrict sudo usage | Stops users from accidentally or intentionally gaining root |
| Scheduled Tasks | Check cron jobs and fix permissions | Prevents unwanted scripts from running |
| Logging | Make sure logs exist and rotate them | Helps me spot issues and avoids logs filling up storage |
| Service Management | Turn off services I don’t need | Reduces potential attack points |


### Threat Model
Brute-force SSH attacks
Threat:
Impact:
Mitigation:

Unauthorized local privilege escalation
Threat:
Impact:
Mitigation:

man-in-the-middle
Threat:
Impact:
Mitigation: