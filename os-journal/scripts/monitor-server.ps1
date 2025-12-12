# Remote server details
$Server = "192.168.1.64" # the servers local ip
$User = "reece" # the user for ssh 

Write-Host "Connecting to $User@$Server and collecting performance metrics..." -ForegroundColor Cyan
Write-Host ""

# Define the commands to run on the server in a variable
$commands = @"
echo '------Uptime------'
uptime 
echo ''
echo '------Memory Usage------'
free -h
echo ''
echo '------Disk Usage------'
df -h
echo ''
echo '------CPU Load (top 5 processes)------'
top -bn1 | head -10
echo ''
echo '------Logged-in Users------'
w -h
echo ''
echo '------SSH Status------'
systemctl is-active ssh
echo ''
echo '------UFW Status------'
sudo ufw status verbose
echo ''
echo '------AppArmor Status------'
systemctl is-active apparmor
sudo apparmor_status | grep profile
echo ''
echo '------Fail2Ban Status------'
systemctl is-active fail2ban
sudo fail2ban-client status --all
echo ''
echo '------Security Updates Status------'
systemctl is-active unattended-upgrades

"@

# Run commands remotely via SSH
ssh "$User@$Server" $commands

Write-Host ""
Write-Host "Performance metrics collected successfully." -ForegroundColor Green