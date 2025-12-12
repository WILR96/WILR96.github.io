# Week 5 - Advanced Security and Monitoring Infrastructure 

### Implement Access Control using SELinux or AppArmor, with documentation showing how to track and report on access control settings.

AppArmor 
https://gitlab.com/apparmor/apparmor/-/wikis/Documentation
https://wiki.debian.org/AppArmor/HowToUse


As the distro im using (Debian 13) comes with AppArmor, I will check to see the status using:

```bash
 apparmor_status
```

This comes back with a message stating that the apparmor module is loaded, but the filesystem is not mounted.

![aanotload](/os-journal/img/week5/aafsnotload.png)

 According to the AppArmor documentation, Debian systems require these two kernel parameters to enable full AppArmor support: 

```bash
apparmor=1 security=apparmor
```


However, Raspberry Pi devices store their boot configuration differently from standard Debian installations. The usual location (/etc/default/grub) does not exist on ARM systems. After checking the Raspberry Pi documentation, I found that kernel parameters must be added to /boot/firmware/cmdline.txt

I opened the file using:
```bash
sudo nano /boot/firmware/cmdline.txt
```

![cmdline1](/os-journal/img/week5/cmdline1.png)

and made the nessesary changes, ensuring that the changes i make are on the same line as the rest of the text otherwise this will break the file.

![cmdline2](/os-journal/img/week5/cmdline2.png)

then rebooted the system using 

```bash
sudo reboot 
```

so the changes could take effect.

I then verified that AppArmor was active by running:

```bash
sudo apparmor_status
```


This showed that AppAmor was running correctly, and the filesystem was mounted. 

![aasetup](/os-journal/img/week5/aasetup.png)

By default, AppArmor only includes a minimal set of profiles. To expand coverage to more common applications, I installed the recommended profiles using:

```bash
sudo apt install apparmor-profiles apparmor-profiles-extra
```


and then enabled them using:

```bash
sudo aa-enable etc/apparmor.d/*
```

which selects all files inside apparmor.d and puts them into enforce mode.

I verified the status again and saw that the profiles had been enabled and access control restrictions were applied to all programs with profiles.

![aafinal](/os-journal/img/week5/aafinal.png)

### Configure automatic security updates with evidence of implementation

On Debian 13, the recommended tool for automatic security updates is unattended-upgrades. This service automatically checks for security patches and installs them without user intervention, we can install it using: 

```bash
sudo apt install unattended-upgrades
```

![upgrades](/os-journal/img/week5/upgrades.png)

Once installed, I enabled automatic security updates using the Debian configuration helper:

```bash
sudo dpkg-reconfigure unattended-upgrades
```

I then checked that the unattended-upgrades services and timers were active by running:

```bash
systemctl status unattended-upgrades
systemctl status apt-daily.timer
systemctl status apt-daily-upgrade.timer
```
![uu](/os-journal/img/week5/uu.png)


To test that the service was working correctly, I performed a simulated upgrade using:
```bash
sudo unattended-upgrade --dry-run --debug
```

![dry run](/os-journal/img/week5/dryrun.png)

This command outputs detailed debug information showing which packages would be upgraded if updates were available.

Finally, I checked the unattended-upgrades log file to confirm the service had already performed routine update checks:

```bash
cat /var/log/unattended-upgrades/unattended-upgrades.log
```


### Configure fail2ban for enhanced intrusion detection

### Create a security baseline verification script (`security-baseline.sh`) that runs on the server (executed via SSH) and verifies all security configurations from Phases 4 and 5

### Create a remote monitoring script (`monitor-server.sh`) that runs on your workstation, connects via SSH, and collects performance metrics from the server.

