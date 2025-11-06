# Week 1

### System Architecture Diagram
This is the system architecture diagram for my chosen client-server relationship: 
<img src="/img/System Architecture Diagram.svg"/>

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

### Network configuration documentation