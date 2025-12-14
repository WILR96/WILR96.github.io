#!/bin/bash

if [ -z "$1" ]; then # if the script argument is null or empty (-z) ($1 represents the first argument supplied)
    MODE="normal" # no need to grep for specific process
    echo "No process supplied - running normal system scan"
else
    PROCESS="$1" # otherwise we assign the argument to a variable
    MODE="process" # change the script mode to process
    echo "Monitoring specific process: $PROCESS"
fi

# Colour codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

ssh reece@192.168.1.64 bash << SCRIPT # ssh into the server, "SCRIPT" acts as a heredoc limiter which allows us to feed multiple lines of input to a command. 

echo -e " ${BLUE} Performance Metrics ${NC} "  # -e tells bash to interpret escape sequences instead of printing them as they are. / ${VAR} allows bash to expand the variable which allows us to use it.
echo

echo -e "${BLUE}------ CPU Usage and Load ------${NC}"

echo --uptime--
uptime # calling uptime from the script
echo

echo --top--
top -bn1 | head -5 # calling top from the script, in batch mode (-b) with only 1 iteration (n1). Head prints the first 10 lines, but we supply -5 to only give us 5 lines.
echo

echo --mpstat--
mpstat # calling mpstat from the script
echo

echo -e "${BLUE}------ RAM and Swap ------${NC}"

echo --free--
free -h # calling free from the script, in human readable format (-h)
echo

echo --vmstat--
vmstat # calling vmstat from the script
echo

echo -e "${BLUE}------Storage / IO speeds------${NC}"

echo --df-- 
df -h # calling df from the script, in human readable format (-h)
echo 

echo --iotop-- 
sudo iotop -b -o -P -n 3 | grep WRITE: # iotop can only be ran as sudo. Ran in batch mode (-b) with only processes (-P) that are doing I/O (-o), ran for 3 iterations (-n 3)
echo 

echo -e "--R/W Speeds--"

echo --Write--
dd if=/dev/zero of=~/sd_test.img bs=1M count=256 conv=fsync # 256 MB write test with forced disk sync, ensuring the test measures real write speed rather than cached writes.
echo

echo --Read--
dd if=~/sd_test.img of=/dev/null bs=1M # Disk read performance test (discard output via /dev/null)

rm ~/sd_test.img # delete the file that has been created

echo

echo -e "${BLUE}------ Network ------${NC}"
ss -tunap
echo 
netstat -i
echo

if [ "$MODE" = "process" ]; # if we are in process mode
then
    echo -e "${BLUE}------ $PROCESS Metrics ------${NC}"

    echo -e "${BLUE}-- CPU --${NC}"
    ps | grep $PROCESS || echo "No CPU activity for $PROCESS" # run ps which shows active processes, and filter for the process supplied using grep. || runs the echo command only if grep returns no results.
    echo

    echo     "PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND" # formating
    top -bn1 | grep $PROCESS || echo "No CPU activity for $PROCESS" # run top in batch mode (-b) for 1 iteration (n1), and filter for the process supplied.

    echo -e "${BLUE}-- Disk I/O --${NC}"
    sudo iotop -b -o -n 1 | grep "$PROCESS" || echo "No active disk I/O for $PROCESS" # iotop can only be ran as sudo. Ran in batch mode (-b) that are doing I/O (-o), ran for 1 iteration (-n 1)
    echo

    echo -e "${BLUE}-- Network --${NC}"
    echo "Netid  State   Recv-Q   Send-Q                                              Local Address:Port      Peer Address:Port"
    ss -p | grep "$PROCESS" || echo "No network activity for $PROCESS" # checks current network connections with process info (-p) and filters for the process supplied
fi

echo
echo -e " ${GREEN}Metrics collection complete ${NC}"

SCRIPT

