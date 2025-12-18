# Week 3
In this week, we will be selecting various applications in order to evaluate how well the Raspberry Pi's performance is under different stress tests. The goal of these tests are to simulate realistic server scenarios, so ive chosen open-source projects that are commonly used in real deployments. I've selected applications based on different workload categories: CPU, RAM, Disk I/O, Network and Server Workload.

### Application Selection Matrix

| Workload Type | Application | Justification |
|------|------|----------------|
| CPU-intensive | FFmpeg | FFmpeg is a multimedia app which can transcode, decode and encode files which is a CPU heavy process |
| RAM-intensive | Memcached | Stores all data in memory / performance scales directly with RAM |
| Disk I/O-intensive | SQlite | Database engine, can generate frequent disk reads and writes. |
| Network-intensive | iperf3 | Industry standard tool for testing network connections  |
| Server Workload | Luanti Server | Voxel game server with CPU-intensive worldgen, RAM caching, disk writes, and real-time networking. |

### Installation Documentation with exact commands for SSH-based installation
Before anything, we will update the repos using 
```bash
sudo apt update
```
![update](/os-journal/img/week3/update.png)

then we can start installing our selected applications.

**FFmpeg:** [1] [2]

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

**Memcached:** [3] [4]

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

**SQlite:** [5]

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

**iperf3:** [6] [7]

iperf3 can be installed using:
```bash
sudo apt-get install iperf3
```
![iperf3install](/os-journal/img/week3/iperf3install.png)

We can test that the application has been installed using:
```bash
iperf3 -v
```
![iperf3](/os-journal/img/week3/iperf3.png)

**Luanti Server:** [8]

luantiserver can be installed using:
```bash
sudo apt install luanti-server
```
![luanti](/os-journal/img/week3/luantiinstall.png)

We can test that the application has been installed using:
```bash
sudo ./luantiserver --version
```
![luantiinstall](/os-journal/img/week3/luanti.png)

### Expected Resource Profiles 

| Application | CPU | RAM | Disk I/O | Network | Temperature |
|------|--------|--------|--------|--------|--------|
| FFmpeg | High - CPU-heavy due to video encoding/decoding | Low - barely uses RAM beyond buffers | Low - temporary disk usage for reading/writing files | Low - no significant network activity | High - CPU usage generates heat, might trigger throttling if sustained |
| Memcached | Low - mainly waits for requests | High - stores all cached data in memory | Low - minimal disk writes  | Low - network usage minimal unless serving requests | Low to medium - memory usage generates minor heat |
| SQLite | Low - lightweight query processing | Medium - depends on database size in memory | High - frequent reads/writes to disk for queries | Low - local database, minimal network | Medium - disk-heavy operations may cause CPU to spike slightly, mild temperature rise |
| iperf3 | Medium - CPU used to process packets | Low - negligible memory usage | Low - almost no disk access | High - saturates network for throughput testing | Medium - CPU handles packet processing, some heat generated |
| Luanti Server | High - world generation and game logic processing | High - caches map, player, and entity data | Medium - saves world state, logs | High - sends/receives player updates in real time | High - combined CPU, RAM, and disk activity can raise temperatures substantially |

### Monitoring Strategy

To monitor the Raspberry Pi’s performance while each application is running, I will use a logging script (as outlined in Week 2). This script automates the collection of CPU, RAM/Swap, Disk I/O, Network, and temperature metrics, ensuring consistent and timestamped data for analysis. The goal is to identify potential bottlenecks and observe the system’s behavior under different workloads.

#### Logging Approach

- **CPU:** Measured using mpstat to capture overall CPU utilization.

- **RAM and Swap:** Monitored with free -m and vmstat to track memory usage and swap activity.

- **Disk I/O:** Tracked using iostat for read/write throughput and hdparm -tT for SD card speed.

- **Network:** Measured via iperf3 for bandwidth and ping for latency.

- **Temperature:** Collected using vcgencmd measure_temp.

#### Steps

- **Baseline Measurement:** Start the logging script with no applications running to record idle performance.

- **Application Testing:** For each application (FFmpeg, Memcached, SQLite, iperf3, Luanti Server), start the logging script and then launch the application and simulate load.

- **Data Collection:** The script records all metrics at regular intervals, storing the output in a timestamped CSV file.

- **Analysis:** Logs are copied back to the client machine for visualization and comparison of each workload’s impact on CPU, RAM, Disk, Network, and thermal behavior.

This approach ensures that all performance metrics are gathered consistently and automatically, making it easy to compare applications and identify any performance issues.

All logs will be timestamped and collected via SSH for analysis on the client machine. Continuous logging via cron will allow performance trends over time to be visualized and compared across applications.

### Sources
[1]
“Download FFmpeg,” Ffmpeg.org, 2019. https://www.ffmpeg.org/download.html (accessed Dec. 11, 2025).

[2] 
“Documentation,” www.ffmpeg.org. https://www.ffmpeg.org/documentation.html (accessed Dec. 11, 2025).

[3] 
“Server Guide,” Memcached.org, Sep. 02, 2024. https://docs.memcached.org/serverguide/ (accessed Dec. 11, 2025).

[4]
“Configuring,” Memcached.org, Sep. 04, 2024. https://docs.memcached.org/serverguide/configuring/ (accessed Dec. 11, 2025).

[5] 
“SQLite Download Page,” sqlite.org. https://sqlite.org/download.html (accessed Dec. 11, 2025).

[6]
“iPerf - Download iPerf3 and original iPerf pre-compiled binaries,” iperf.fr. https://iperf.fr/iperf-download.php (accessed Dec. 11, 2025).

[7]
“iPerf - iPerf3 and iPerf2 user documentation,” iperf.fr. https://iperf.fr/iperf-doc.php (accessed Dec. 11, 2025).

[8]
“Setting up a server,” Luanti Documentation, Sep. 08, 2025. https://docs.luanti.org/for-server-hosts/setup/ (accessed Dec. 11, 2025).

‌
