# Week 3
In this week, we will be selecting various applications in order to evaluate how well the Raspberri Pi's performance is under different stress tests. The goal of these tests are to simulate realistic server senarios, so ive chosen open-source projects that are commonly used in real deployments. I've selected applications based on different workload categories: CPU, RAM, Disk I/O, Network and Server Application.

### Application Selection Matrix

| Workload Type | Application | Justification |
|------|------|----------------|
| CPU-intensive | BOINC | BOINC runs scientific workloads that place sustained load on the CPU. Designed to run on unprivileged account. |
| RAM-intensive | Memcached | Stores all data in memory / performance scales directly with RAM |
| Disk I/O-intensive | Nextcloud | Self-hosted cloud storage platform with constant filesystem reads/writes. |
| Network-intensive | iperf3 | Industry standard tool for testing network connections  |
| Server workload | Minetest Server | Voxel game server with CPU-intensive worldgen, RAM caching, disk writes, and real-time networking. |

### Installation Documentation with exact commands for SSH-based installation
Before anything, we will update the repos using 
```bash
sudo apt update
```
![update](/os-journal/img/week3/update.png)

then we can start installing our selected applications.

BOINC:

BOINC can be installed using:
```bash
sudo apt install boinc-client
```
![install](/os-journal/img/week3/install.png)

We then enable the service:
```bash
sudo systemctl enable --now boinc-client
```
![update](/os-journal/img/week3/enable.png)

Then confirm the service is running using:
```bash
sudo systemctl status boinc-client
```
![status](/os-journal/img/week3/status.png)

We then need to get an account key, in order to get the key we will need to register an account with https://boinc.berkeley.edu/central/ and then from "my account", you can view the account keys.
![acckey](/os-journal/img/week3/acckey.png)

When we want to run the application, we can attach to a project such as BOINC Central and let them use the Pi's resources using:
```bash
sudo boinccmd --project_attach http://boinc.berkeley.edu/ MYACCKEY
```
![attach](/os-journal/img/week3/attachtoproject.png)



Memcached - 

Nextcloud -

iperf3 - 

Minetest Server - 


### Expected Resource Profiles 

### Monitoring Strategy
