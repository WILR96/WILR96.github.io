#!/bin/bash

# variables for colour codes 
RED='\033[0;31m' 
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# -e tells bash to interpret escape sequences instead of printing them as they are.
echo -e "${BLUE} SECURITY BASELINE REPORT ${NC}" #${VAR} allows bash to expand the variable which allows us to use it.
echo # for the effect of a new line.


# SSH Status and Config
echo -e "${BLUE}-------SSH Service Status-------${NC}" 
 # we can call commands from the script as if we were in the terminal. We can also create variables to reuse later, and can run commands using $(...).
sshIsActive=$(systemctl is-active ssh) # we use systemctl to interact with the system manager, and can check if a spesific service is active using "is-active" with the service we want to check.
if [ "$sshIsActive" == "active" ]; # checking to see if the variable is equal to "active" string.
then
    echo -e "${GREEN} SSH is active ${NC}" # it matches, so we let the user know with a green colour to allow for quicker analysis.
else
    echo -e "${RED} SSH not running ${NC}" # it dosen't, so we let the user know with a red colour instead.
fi # fi lets bash know to end the loop.

echo
echo -e "${BLUE}-------SSH Configuration-------${NC}"

root_login=$(grep "PermitRootLogin" /etc/ssh/sshd_config | head -1 | awk '{print $2}') # grep searches for the string supplied, within the file specified. We use head -1 to get only the first line of output, then awk splits the input by spaces and we select and print the second element using "{'print $2'}".
if [ "$root_login" == "no" ]; # if the variable is equal to no.
then 
    echo -e "PermitRootLogin: ${GREEN} NOT ALLOWED ${NC}" # then show the user NOT ALLOWED in green as this is the expected result.
else 
    echo -e "PermitRootLogin: ${RED} ALLOWED ${NC}" # otherwise the server is misconfigured, show red.
fi # fi lets bash know to end the loop.

pass_auth=$(grep "PasswordAuthentication" /etc/ssh/sshd_config | head -1 | awk '{print $2}') # grep searches for the string supplied, within the file specified. We use head -1 to get only the first line of output, then awk splits the input by spaces and we select and print the second element using "{'print $2'}".
if [ "$pass_auth" == "no" ]; # if the variable is equal to no.
then 
    echo -e "PasswordAuthentication: ${GREEN} NOT ALLOWED ${NC}" # then show the user NOT ALLOWED in green as this is the expected result.
else 
    echo -e "PasswordAuthentication: ${RED} ALLOWED ${NC}" # otherwise the server is misconfigured, show red.
fi # fi lets bash know to end the loop.

echo


echo -e "${BLUE}-------SSH Authorized Keys-------${NC}"
if [ -f ~/.ssh/authorized_keys ]; # if the file (-f) authorized_keys from the users home directory (~) to /.shh exists 
then 
    echo -e "${GREEN} authorized_keys exist! ${NC}" # then they exist 
    echo -e "Name of Device:\n$(cat ~/.ssh/authorized_keys | awk '{print $3}')" # and we will list the device that uses it, allows us to see if there are any unrecognised devices.
else 
    echo -e "${RED} NO AUTHORIZED KEYS EXISTS ${NC}" # there should be keys otherwise we cannot get back into our device, as we have disabled password access over ssh. we would have to have physical access.
fi # fi lets bash know to end the loop.
echo

# UFW Firewall
echo -e "${BLUE}-------UFW Status and Rules-------${NC}"
ufwOut=$(sudo ufw status verbose) # here we get the status of the Uncomplicated Firewall, in verbose format for more detail 
ufwStatus=$(echo "$ufwOut" | grep "Status" | awk '{print $2}') # here we grep for status in the ufwOut variable, and select the second element.
if [ "$ufwStatus" == "active" ]; # if the variable is equal to the "active" string.
then
    echo -e "${GREEN} Firewall is active! ${NC}" # show that its active in green 
    sudo ufw status verbose # show the firewall status, for review. for some reason using the variable wont show \n so reuse the command.
else
    echo -e "${RED} Firewall is disabled! ${NC}" # otherwise its disabled, so we show the user it in red.
fi # fi lets bash know to end the loop.
echo


# Users

echo -e "${BLUE}-------Sudo Users-------${NC}"
whoSudo=$(getent group sudo) # here we get entries from the sudo group and store them in a variable.
usrSudo=$(echo $whoSudo | cut -d: -f4 | tr ',' '\n') # we use the variable, cut it using the denominator (-d) ":" and select field (-f) "4". then we replace any commas with newlines using "tr ',' '\n'".
numSudo=$(echo $usrSudo | wc -l) # wc -l will count the number of lines, this will tell us how many sudo users there are.
if [[ "$numSudo" -gt 1 ]];  # if the number of sudo users is greater (-gt) than 1.
then
    echo -e "${RED} More than 1 sudo user! ${NC}" # Tell the user that there is more than 1, as there should be no-one else using this server this should show up red.
else
    echo -e "${GREEN} Only one sudo user. ${NC}" # otherwise everything is fine.
fi # fi lets bash know to end the loop.
echo "$whoSudo" | cut -d: -f4 # but we still show the user, just in case. 
echo

echo -e "${BLUE}-------All Bash Users-------${NC}"
grep "bash" /etc/passwd | cut -d: -f1 # can see who has a user that can log in by checking the users shell for "bash".

echo -e "${BLUE}-------Logged-in Users-------${NC}"
w # the "w" command gives a list of currently logged in users, helpful to view.
echo

# AppArmor
echo -e "${BLUE}-------AppArmor Status-------${NC}"
apparmor=$(systemctl is-active apparmor) # here we get the status of apparmor and store it in a variable. 
if [ "$apparmor" == "active" ]; # if the variable is equal to "active"
then
    echo -e "${GREEN} AppArmor is active ${NC}" # then its active, and we show the user green.
    sudo apparmor_status | grep "profile" # we will also show the ammount of active profiles for review.
else
    echo -e "${RED} AppArmor is Disabled!${NC}" # otherwise its disabled so we show the user red.
fi # fi lets bash know to end the loop.
echo

# Security Updates
echo -e "${BLUE}-------Automatic Security Updates-------${NC}"
echo "Service status:"
upgrades=$(systemctl is-active unattended-upgrades) # here we get the status of unattended-upgrades and store it in a variable. 
if [ "$upgrades" == "active" ] # if the variable is equal to "active"
then
    echo -e "${GREEN} unattended-upgrades is active ${NC}" # then its active, and we show the user green.
else
    echo -e "${RED} unattended-upgrades is Disabled!${NC}" # otherwise its disabled so we show the user red.
fi # fi lets bash know to end the loop.
echo

# Fail2Ban
echo -e "${BLUE}-------Fail2Ban Status-------${NC}"
fail2banStatus=$(systemctl is-active fail2ban); # here we get the status of fail2ban and store it in a variable. 
if [ "$fail2banStatus" == "active" ] # if the variable is equal to "active"
then  
    echo -e "${GREEN} Fail2Ban is active ${NC}" # then its active, and we show the user green.
    sudo fail2ban-client status --all # we also show the current status to the user
else
    echo -e "${RED} Fail2Ban is Disabled!${NC}" # otherwise its disabled so we show the user red.
fi # fi lets bash know to end the loop.
echo

