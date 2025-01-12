#!/bin/bash
#==================================================
INTERFACE="eth1"  # Change to your network interface
#===================================================

# DEFINING UNIVERSAL CONSTANTS
#========================================
OUTPUT_DIR="/home/aaradhya/AI_Router/outputdir"  # Change to your preferred output directory
ALL_LOG_DIR="/home/aaradhya/AI_Router/all_log"
DEFAULT_CSV="${ALL_LOG_DIR}/default.csv"
FILE_COUNTER=1
#=========================================

# Initialize the default.csv with column titles only once
if [ ! -f "$DEFAULT_CSV" ]; then
    echo "frame.number,frame.time,ip.src,ip.dst,ip.ttl,tcp.srcport,tcp.dstport,tcp.flags,udp.srcport,udp.dstport,http.request.method,http.response.code,dns.qry.name,dns.a,_ws.col.Source,_ws.col.Destination,_ws.col.Protocol,_ws.col.Info" > "$DEFAULT_CSV"
fi

while true; do
    if [ $FILE_COUNTER -lt 121 ]; then
        OUTPUT_FILE="$OUTPUT_DIR/capture_srno_${FILE_COUNTER}.csv"
        
        # Add field titles to the individual CSV files
        echo "frame.number,frame.time,ip.src,ip.dst,ip.ttl,tcp.srcport,tcp.dstport,tcp.flags,udp.srcport,udp.dstport,http.request.method,http.response.code,dns.qry.name,dns.a,_ws.col.Source,_ws.col.Destination,_ws.col.Protocol,_ws.col.Info" > "$OUTPUT_FILE"
        
        # Capture packets for 30 seconds and save them to the CSV file
        sudo tshark -i $INTERFACE -a duration:30 -T fields -E separator=, \
            -e frame.number -e frame.time -e ip.src -e ip.dst -e ip.ttl \
            -e tcp.srcport -e tcp.dstport -e tcp.flags -e udp.srcport -e udp.dstport \
            -e http.request.method -e http.response.code -e dns.qry.name -e dns.a \
            -e _ws.col.Source -e _ws.col.Destination -e _ws.col.Protocol -e _ws.col.Info \
            >> "$OUTPUT_FILE"
        
        # Append captured data to default.csv (without duplicating headers)
        tail -n +2 "$OUTPUT_FILE" >> "$DEFAULT_CSV"
        echo "Appended data to default.csv"
        
        # Clean up the individual file
        rm -f "$OUTPUT_FILE"
        echo "Deleted temporary file $OUTPUT_FILE"
        
        FILE_COUNTER=$((FILE_COUNTER + 1))
    elif [ $FILE_COUNTER -eq 121 ]; then
        FILE_COUNTER=1
        rm -f "$OUTPUT_DIR"/*
        echo "Cleared output directory"
    fi

    sleep 2 # Wait before the next capture
done
