#!/bin/bash

LOGFILE="5minTest.log"
SUMMARY="5minTest-Summary.log"


echo "------TEST RESULTS------" | tee -a "$SUMMARY"
echo
echo "-- Load Averages --" | tee -a "$SUMMARY"
echo "   1min  5min   15min" | tee -a "$SUMMARY"
grep "load average: " "$LOGFILE" | awk -F'load average: ' '{print NR ". " $2}' | tee -a "$SUMMARY"

echo
echo "-- CPU Usage (% idle) --" | tee -a "$SUMMARY"
grep "%Cpu" "$LOGFILE" | awk -F, '{print NR ". " $4}' | tee -a "$SUMMARY"

echo
echo "-- Memory Usage --" | tee -a "$SUMMARY"
grep "MiB Mem" "$LOGFILE" | awk '{print NR ". " $0}' | tee -a "$SUMMARY"

echo
echo "-- Swap Usage --" | tee -a "$SUMMARY"
grep "MiB Swap" "$LOGFILE" | awk '{print NR ". " $0}' | tee -a "$SUMMARY"

echo
echo "-- Disk Usage --" | tee -a "$SUMMARY"
grep "mmcblk0p2" "$LOGFILE"  | awk '{print NR ". " $0}' | tee -a "$SUMMARY"

echo
echo "-- Disk I/O Speeds --" | tee -a "$SUMMARY"
echo "--Write--" | tee -a "$SUMMARY" 
grep -A3 "Write--" "$LOGFILE" | grep copied | awk -F'copied,' '{print NR ". " $2}' | tee -a "$SUMMARY" 
echo
echo "--Read--" | tee -a "$SUMMARY" 
grep -A3 "Read--" "$LOGFILE" | grep copied | awk -F'copied,' '{print NR ". " $2}' | tee -a "$SUMMARY" 
echo
echo "-- Network Interfaces --" | tee -a "$SUMMARY"
echo "Iface             MTU    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OV" | tee -a "$SUMMARY" 
grep "wlan0" "$LOGFILE" | awk '{print NR ". " $0}' | tee -a "$SUMMARY" 

echo
echo "-- Temperature --" | tee -a "$SUMMARY"
grep "temp=" "$LOGFILE" | awk '{print NR ". " $0}' | tee -a "$SUMMARY"

echo
echo "-- Throttled Status --" | tee -a "$SUMMARY"
grep "throttled=" "$LOGFILE"  | awk '{print NR ". " $0}' | tee -a "$SUMMARY"


