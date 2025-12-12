# Week 4 - Initial System Configuration & Security Implementation 

### Configure SSH with key-based authentication
In order to allow only key-based authentication, we will first have to generate a new SSH key pair from our client, in my case im using windows so I will use:

https://www.ssh.com/academy/ssh/keygen

```powershell
ssh-keygen
```
![keygen](/os-journal/img/week4/sshkeygen.png)

This command will prompt us for the file in which to save the key, and a passphrase. Once they have been entered, our key is generated. We will then need to copy the public key to the server, theres also a command to do this:
```powershell
ssh-copy-id user@ipaddr
```
However, my client machine has not got this command installed. So I found a workaround from:
https://serverfault.com/questions/224810/is-there-an-equivalent-to-ssh-copy-id-for-windows
```powershell
cat ~/.ssh/PUBLICKEY | ssh user@IPADDR "cat >> ~/.ssh/authorized_keys"
```
![keytransfer](/os-journal/img/week4/keytransfer.png)

We will also need to make sure that the permissions are correct for the file, so we set the permissions to 600, this gives the owner of the file read and write access, and no-one else.
```bash
chmod 600 authorised_keys
```

![chmodauthkey](/os-journal/img/week4/chmodAuthKeys.png)

After this, we can test to see if we still get prompted with a password:
![sshnopass](/os-journal/img/week4/sshnopass.png)

Success! We can now disable password authentication by editing the sshd_config:
```bash
sudo nano /etc/ssh/sshd_config
```
Before:

![passwdrmv](/os-journal/img/week4/sshd_configChange.png)

After:

![passwdrmvcng](/os-journal/img/week4/sshd_configChangeafter.png)


And proof of it working:
![passwdsshno](/os-journal/img/week4/sshnopassroot.png)

Now we can set up the firewall to only allow my client machine.

### Configure a firewall permitting SSH from one specific workstation only

In order to only allow my client pc to access the server, I will need to install a firewall application. The most common is called UFW (Uncomplicated Firewall).

To install UFW:
```bash
sudo apt install ufw
```
![installUFW](/os-journal/img/week4/installUFW.png)

After, we will need to configure the firewall to block all incoming connections and allow outgoing connections.
![inoutUFW](/os-journal/img/week4/inoutUFW.png)

Then we will add my client PC IP address to the allow list, whilst specifying port 22 as this is the port that ssh is currently hosted on. 
![ipUFW](/os-journal/img/week4/ipUFW.png)

Then we can enable the service, and check that the rules have been added correctly:
![finalRules](/os-journal/img/week4/finalRules.png)



### Manage users and implement privilege management, creating a non-root administrative user.

First off, we will look at what users we have on our system. We can do this by using the passwd file.

```bash
cat /etc/passwd
```

This will give us a list of all the users on the server. There are a few that are system users such as daemon, but also users like root and reece that have login information:
![users](/os-journal/img/week4/users.png)

We can also see who belongs to the sudo group using:
```bash
getent group sudo
```
![rsudo](/os-journal/img/week4/reecesudo.png)

Which tells me that the "reece" user is already a member of the sudo group, which means we have already implemented a non-root admin user.

If we wanted to create another one, we can use these commands to create a user and add it to the sudo group:
```bash
sudo adduser USERTOADD
sudo usermod -aG sudo USERTOADD
```

