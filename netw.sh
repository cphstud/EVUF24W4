#!/bin/bash

# Define the network interface name, e.g., eth0, ens33, etc.
INTERFACE="eth0"

# Define the log file path
LOG_FILE="/var/log/network_traffic.log"

# Collect network traffic statistics
STATS=$(ip -s link show $INTERFACE)

# Extract received and transmitted bytes
# read rx_bytes tx_bytes <<< $(echo "$line"
read RX_BYTES TX_BYTES <<< $( echo $STATS | tr '\n' ' ' | sed -E 's/.*RX:[^0-9]*([0-9]+).*TX:[^0-9]*([0-9]+).*/RX:\1 TX:\2/')

# Get current date and time
DATE_TIME=$(date "+%Y-%m-%d %H:%M:%S")

# Log to file
echo "$DATE_TIME | Received: $RX_BYTES bytes, Sent: $TX_BYTES bytes" >> $LOG_FILE

# Also log to syslog
logger -t NetworkTrafficLogger "$DATE_TIME | Interface: $INTERFACE, Received: $RX_BYTES bytes, Sent: $TX_BYTES bytes"
