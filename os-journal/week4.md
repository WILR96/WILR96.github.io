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

![passwdrmv](/os-journal/img/week4/sshd_configChange.png)

And proof of it working:
![passwdsshno](/os-journal/img/week4/sshnopassroot.png)

Now we can set up the firewall to only allow my client machine.

### Configure a firewall permitting SSH from one specific workstation only




### Manage users and implement privilege management, creating a non-root administrative user.

### SSH Access Evidence showing successful connection screenshots

### Configuration Files with before and after comparisons

### Firewall Documentation showing complete ruleset

### Remote Administration Evidence demonstrating commands executed via SSH

