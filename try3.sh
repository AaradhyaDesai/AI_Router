#!/bin/bash
#==================================================
INTERFACE="eth1"  # Change to your network interface
#===================================================

# DEFINING UNIVERSAL CONSTANTS
#========================================
OUTPUT_DIR="/home/aaradhya/AI_Router/outputdir"  # Change to your preferred output directory
ALL_LOG_DIR="/home/aaradhya/AI_Router/all_log"
DEFAULT_CSV="$ALL_LOG_DIR/default.csv"
FILE_COUNTER=1
HEADER="frame.time,ip.src,ip.dst,ip.ttl,tcp.srcport,tcp.dstport,tcp.flags,udp.srcport,udp.dstport,http.request.method,http.response.code,dns.qry.name,dns.a,_ws.col.Source,_ws.col.Destination,_ws.col.Protocol,_ws.col.Info,frame.len,frame.protocols,tcp.flags.syn,tcp.flags.ack,tcp.syn_no_ack"
#=========================================

# Ensure ALL_LOG_DIR exists
mkdir -p "$ALL_LOG_DIR"

# Add header to default.csv if it doesn't exist
if [ ! -f "$DEFAULT_CSV" ]; then
  echo "$HEADER" > "$DEFAULT_CSV"
fi

while true; do
  if [ $FILE_COUNTER -lt 121 ]; then
    OUTPUT_FILE="$OUTPUT_DIR/capture_srno_${FILE_COUNTER}.csv"

    # Capture packets for 30 seconds and save them to a CSV file
    sudo tshark -i $INTERFACE -a duration:30 -T fields -E separator=, \
    -e frame.time -e ip.src -e ip.dst -e ip.ttl \
    -e tcp.srcport -e tcp.dstport -e tcp.flags -e udp.srcport -e udp.dstport \
    -e http.request.method -e http.response.code \
    -e dns.qry.name -e dns.a \
    -e _ws.col.Source -e _ws.col.Destination -e _ws.col.Protocol -e _ws.col.Info \
    -e frame.len -e frame.protocols \
    -e tcp.flags.syn -e tcp.flags.ack \
    > "$OUTPUT_FILE"

    # Combine the SYN flag and ACK flag into a new column
    awk -F',' 'BEGIN {OFS=","} NR==1 {next} {$(NF+1)=($14==1 && $15==0 ? "1" : "0"); print}' "$OUTPUT_FILE" >> "$DEFAULT_CSV"

    echo "Captured data appended to $DEFAULT_CSV"

    sleep 2  # Wait for 2 seconds before capturing again (this can be adjusted)

    FILE_COUNTER=$((FILE_COUNTER + 1))
  elif [ $FILE_COUNTER -eq 121 ]; then
    echo "Resetting FILE_COUNTER"
    FILE_COUNTER=1
    rm -f "$OUTPUT_DIR"/*
  fi
done

