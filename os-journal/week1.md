# Week 1 - System Planning and Distribution Selection 

## System Architecture Diagram
This is the system architecture diagram for my chosen client-server relationship:
![System Architecture Diagram](/os-journal/img/week1/SystemArcDiagram.svg)
The architecture diagram shows a remote administration model. The workstation connects to the server over SSH, allowing secure headless management and enforcing command line proficiency.

### Distribution Selection Justification

For my server distribution, I selected Raspberry Pi OS Lite (64bit) to run on a Raspberry Pi 4 due to the operating system being specifically optimised for Raspberry Pi hardware, as such, it provides the best environment to test on. It also has large community support as well as extensive documentation, and maintenance by the Raspberry Pi Foundation, meaning that this distro has long-term stability and compatibility.

I considered three different operating systems:

| Distro | Strengths | Weaknesses |
|------|--------------|----------------|
| Raspberry Pi OS Lite | Optimised for Pi, Lightweight | Fewer enterprise features |
| Ubuntu Server ARM | Large community, Modern features | More resource-intensive |
| Fedora ARM | SELinux on by default, Newer kernel | Smaller Pi community, Shorter release cycle/support|

**Conclusion**
Raspberry Pi OS Lite provides the best balance between performance, simplicity, and official hardware support. Its Debian foundation ensures reliability and access to a large repository of packages, as well as being optimised to run on a Raspberry Pi makes it the best choice for this project.

### Setting up Raspberry Pi

To install the OS onto the SD card, it first needs to be properly formatted. The easiest and most reliable way to do this is by using Raspberry Pi Imager. This tool automatically handles formatting and writes the OS image to the SD card, ensuring it’s bootable and correctly configured for the Raspberry Pi [1]

First we download and install Raspberry Pi Imager from the official Raspberry Pi website [2].

Insert the SD card into your computer.

Open Raspberry Pi Imager, select the desired OS, and choose your SD card as the target.
![alt text](<img/week1/pi setup.png>)

Change the settings to configure wifi startup:
![alt text](<img/week1/pi setup2.png>)

and ssh:

![alt text](<img/week1/pi setup3.png>)

Click Write. The tool will format the card and install the OS.

Then all we have to do is insert it into the raspberry pi and turn it on.

### Workstation Configuration Decision

For this project, I’m using my Windows 11 host machine, which I will use to control the headless Raspberry Pi OS Lite server via SSH. Windows already includes a SSH client, which means I can connect directly to the Pi through PowerShell or Windows Terminal without installing extra software. 

Using Windows also makes it easier to document my progress since I can record demonstrations, take screenshots, and manage my GitHub Pages journal all from one place. It’s a realistic setup, since many system administrators manage Linux servers remotely from non-Linux machines. When I need a more Linux-like environment, I can use Windows Subsystem for Linux. I can also connect through VS Code Remote SSH if I need to edit files, which gives me flexibility for running scripts and editing configuration files without a terminal.

Overall, using Windows 11 as the workstation gives me a stable, well-supported environment with all the tools I need for both server management and coursework documentation.

A Linux desktop virtual machine could have been used as the workstation to provide full environmental isolation. However, using the host machine reduced resource overhead and more closely reflects real-world remote administration practices.

### Network Configuration Documentation
The Raspberry Pi OS Lite server connects to the same local Wi-Fi network as the Windows 11 workstation.  

All administration and access is performed remotely using SSH over port 22 (changed later in the journal).

#### Network Overview:
- Router network: "192.168.1.0/24"
- Router gateway: "192.168.1.254"
- Workstation (Windows 11): "192.168.1.94" (DHCP)
- Raspberry Pi (Server): "192.168.1.64" (Static)
- Connection type: Wireless (wlan0)
- DNS: "8.8.8.8" (Google's Public DNS service)

![Image showing the use of "ip addr" and "ip route" on the Raspberry Pi Server](/os-journal/img/week1/ipaddrServer.png)


I was able to establish an SSH connection to the Raspberry Pi, but using ping from the Pi to the workstation failed.

![Ping failed Server to client](/os-journal/img/week1/pingFailServer.png)

This was because of the Windows Defender Firewall blocking pings by default. To allow pinging, I temporarily enabled "ICMPv4 echo requests" using the following PowerShell command [2]:

```powershell
New-NetFirewallRule -DisplayName "Allow pings" -Protocol ICMPv4 IcmpType 8 -Action Allow
```

And then removed it with:
```powershell
Remove-NetFirewallRule -DisplayName "Allow pings"
```

![Image showing me pinging the server from my client PC](/os-journal/img/week1/pingingServerFromClient.png)

![Image showing me pinging the client PC from the server](/os-journal/img/week1/pingingClientFromServer.png)

The IP address was made static using 'sudo nmtui' and changing the ipv4 configuration to a manual connection, where i could insert the desired ip, gateway, DNS provider. A static IP ensures consistent SSH access without needing to rediscover the device.

Although the coursework brief references VirtualBox network settings, in my case the system is deployed on physical hardware rather than a virtual machine. The equivalent network configuration principles still apply, like static IP addressing, gateway definition, and SSH access from the workstation.

### Document System Specifications
All commands have been run over ssh from my client machine to the server using the command line:

Running uname -a on the server over SSH, this shows the kernel version and system architecture.
![Running uname -a on the server over ssh](/os-journal/img/week1/unameServer.png)
Running free -h on the server over ssh, this shows total, used, and available RAM.
![Running free -h on the server over ssh](/os-journal/img/week1/freeServer.png)
Running df -h on the server over ssh. This shows the available and used storage across mounted filesystems.
![Running df -h on the server over ssh](/os-journal/img/week1/dfServer.png)
Running lsb_release -a on the server over ssh. This outputs the distribution name and release information.
![Running lsb_release -a on the server over ssh](/os-journal/img/week1/lsb_releaseServer.png)

This week helped me understand that even something as basic as ping relies on security policies. I thought that there was a problem with the connection or a routing problem, but it was just a firewall filter on my windows machine. This helped my reinforce the need for good troubleshooting steps rather than making assumptions about the cause of a problem.


[WEEK 2](/os-journal/week2.md)

### Sources
[1]
Raspberry Pi, “Raspberry Pi Documentation - Getting Started,” Raspberry Pi, 2025. https://www.raspberrypi.com/documentation/computers/getting-started.html

[2]
Raspberry Pi, “Raspberry Pi OS,” Raspberry Pi, 2025. https://www.raspberrypi.com/software/

[3] JasonGerend, “New-NetFirewallRule (NetSecurity),” Microsoft.com, 2025. https://learn.microsoft.com/en-us/powershell/module/netsecurity/new-netfirewallrule?view=windowsserver2025-ps
