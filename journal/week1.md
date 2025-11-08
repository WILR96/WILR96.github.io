# Week 1 - System Planning and Distribution Selection 

### System Architecture Diagram
This is the system architecture diagram for my chosen client-server relationship:
![System Architecture Diagram](/img/week1/SystemArcDiagram.svg)

### Distribution Selection Justification

For my server distribution, I selected Raspberry Pi OS Lite (64bit) to run on a Raspberry Pi 4 due to the operating system being specifically optimised for Raspberry Pi hardware, as such, it provides the best environment to test on. It also has large community support, documentation, and maintenance by the Raspberry Pi Foundation, meaning that this distro has long-term stability and compatibility.

I considered two main alternatives:
##### Ubuntu Server (ARM) 
Ubuntu offers modern features, a large support community, and official ARM builds. However, it is more resource-intensive than Raspberry Pi OS Lite, which could impact performance.
##### Fedora Server (ARM): 
Fedora includes a newer kernel and SELinux enabled by default which offers advanced security features. However, its shorter release cycle and smaller Raspberry Pi community make it less suitable for long-term stability and support.

**Conclusion**

Raspberry Pi OS Lite provides the best balance between performance, simplicity, and official hardware support. Its Debian foundation ensures reliability and access to a large repository of packages as well as being optimised to run on a Raspberry Pi.


### Workstation Configuration Decision

For this project, I’m using my Windows 11 host machine, which I will use to control the headless Raspberry Pi OS Lite server via SSH. Windows already includes a SSH client, which means I can connect directly to the Pi through PowerShell or Windows Terminal without installing extra software. 

Using Windows also makes it easier to document my progress since I can record demonstrations, take screenshots, and manage my GitHub Pages journal all from one place. It’s a realistic setup, since many system administrators manage Linux servers remotely from non-Linux machines. When I need a more Linux-like environment, I can use Windows Subsystem for Linux. I can also connect through VS Code Remote SSH if I need to edit files, which gives me flexibility for running scripts and editing configuration files without a terminal.

Overall, using Windows 11 as the workstation gives me a stable, well-supported environment with all the tools I need for both server management and coursework documentation.

### Network Configuration Documentation
The Raspberry Pi OS Lite server connects to the same local Wi-Fi network as the Windows 11 workstation.  

All administration and access is performed remotely using SSH over port 22.

#### Network Overview:
- Router network: "192.168.1.0/24"
- Router gateway: "192.168.1.254"
- Workstation (Windows 11): "192.168.1.94" (DHCP)
- Raspberry Pi (Server): "192.168.1.64" (Static)
- Connection type: Wireless (wlan0)
- DNS: "8.8.8.8" (Google's Public DNS service)

![Image showing the use of "ip addr" and "ip route" on the Raspberry Pi Server](/img/week1/ipaddrServer.png)


I was able to establish an SSH connection to the Raspberry Pi, but using ping from the Pi to the workstation failed.

![Ping failed Server to client](/img/week1/pingFailServer.png)

This was because of the Windows Defender Firewall blocking pings by default. To allow pinging, I temporarily enabled "ICMPv4 echo requests" using the following PowerShell command:

<code>New-NetFirewallRule -DisplayName "Allow pings" -Protocol ICMPv4 IcmpType 8 -Action Allow</code>

And then removed it with:

<code>Remove-NetFirewallRule -DisplayName "Allow pings"</code>

![Image showing me pinging the server from my client PC](/img/week1/pingingServerFromClient.png)

![Image showing me pinging the client PC from the server](/img/week1/pingingClientFromServer.png)

The IP address was made static using 'sudo nmtui' and changing the ipv4 configuration to a manual connection, where i could insert the desired ip, gateway, DNS provider.

Although the coursework brief references VirtualBox network settings, in my case the system is deployed on physical hardware rather than a virtual machine. The equivalent network configuration principles still apply, like static IP addressing, gateway definition, and SSH access from the workstation.

### Document System Specifications
All commands have been run over ssh from my client machine to the server using the command line:

![Running uname -a on the server over ssh](/img/week1/unameServer.png)
![Running free -h on the server over ssh](/img/week1/freeServer.png)
![Running df -h on the server over ssh](/img/week1/dfServer.png)
![Running lsb_release -a on the server over ssh](/img/week1/lsb_releaseServer.png)