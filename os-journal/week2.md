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

### Threat Model