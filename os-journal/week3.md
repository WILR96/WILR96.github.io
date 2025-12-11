# Week 3
In this week, we will be selecting various applications in order to evaluate how well the Raspberry Pi's performance is under different stress tests. The goal of these tests are to simulate realistic server scenarios, so ive chosen open-source projects that are commonly used in real deployments. I've selected applications based on different workload categories: CPU, RAM, Disk I/O, Network and Server Workload.

### Application Selection Matrix

| Workload Type | Application | Justification |
|------|------|----------------|
| CPU-intensive | FFmpeg | FFmpeg is a multimedia app which can transcode, decode and encode files which is a CPU heavy process |
| RAM-intensive | Memcached | Stores all data in memory / performance scales directly with RAM |
| Disk I/O-intensive | SQlite | Database engine, can generate frequent disk reads and writes. |
| Network-intensive | iperf3 | Industry standard tool for testing network connections  |
| Server Workload | Minetest Server | Voxel game server with CPU-intensive worldgen, RAM caching, disk writes, and real-time networking. |

### Installation Documentation with exact commands for SSH-based installation
Before anything, we will update the repos using 
```bash
sudo apt update
```
![update](/os-journal/img/week3/update.png)

then we can start installing our selected applications.

#### FFmpeg:
Installation guide:
https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

FFmpeg can be installed using:
```bash
sudo apt install ffmpeg
```
![ffmpegins](/os-journal/img/week3/ffmpeginstall.png)

After that, I will test that it has been installed correctly by testing the command 
```bash
ffmpeg -version
```
![ffmpeg](/os-journal/img/week3/ffmpeg.png)

#### Memcached:
Installation guide:
https://docs.memcached.org/serverguide/

Memcached can be installed using:
```bash
sudo apt-get install memcached
```
![Memcachedins](/os-journal/img/week3/memcachedInstall.png)

We can test that the application has been installed using:
```bash
memcached -V
```
![Memcached](/os-journal/img/week3/memcached.png)

#### SQlite:
Installation guide:
https://packages.debian.org/search?keywords=sqlite3
sqlite can be installed using:
```bash
sudo apt install sqlite3
```
![SQliteins](/os-journal/img/week3/sqliteinstall.png)

We can test that the application has been installed using:
```bash
sqlite3 -version
```
![SQliteins](/os-journal/img/week3/sqlite.png)

#### iperf3:
Installation guide:

#### Minetest Server:
Installation guide:


### Expected Resource Profiles 

### Monitoring Strategy
