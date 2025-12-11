# Week 3
In this week, we will be selecting various applications in order to evaluate how well the Raspberri Pi's performance is under different stress tests. The goal of these tests are to simulate realistic server senarios, so ive chosen open-source projects that are commonly used in real deployments. I've selected applications based on different workload categories: CPU, RAM, Disk I/O, Network and Server Application.

### Application Selection Matrix

| Workload Type | Application | Justification |
|------|------|----------------|
| CPU-intensive | FFmpeg | FFmpeg is a multimedia app which can transcode, decode and encode files which is a CPU heavy process |
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

FFmpeg:

FFmpeg can be installed using:
```bash
sudo apt install ffmpeg
```
![install](/os-journal/img/week3/install.png)

After that, I will test that it has been installed correctly by testing the command 
```bash
ffmpeg -version
```
![install](/os-journal/img/week3/ffmpeg.png)

Memcached - 

Nextcloud -

iperf3 - 

Minetest Server - 


### Expected Resource Profiles 

### Monitoring Strategy
