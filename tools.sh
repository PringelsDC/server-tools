#!/bin/bash

# check energy usage using ipmitool
energy_usage() {
    echo "Checking energy usage..."
    
    # Look for power sensors related to PSU
    sudo ipmitool sensor | grep -Ei 'PSU|Power|Watt|Current'
}

# check CPU usage and temperatures using mpstat and sensors
cpu_usage_and_temp() {
    echo "Checking CPU usage and temperatures..."
    
    # Check if mpstat is available
    if ! command -v mpstat &> /dev/null; then
        echo "mpstat is not installed. Please install sysstat package."
    else
        # CPU usage all cores & threads
        echo "CPU usage:"
        mpstat -P ALL 1 1
    fi
    
    # CPU temps
    echo "CPU Temperatures:"
    sensors | grep -i 'core'
}

# check network in and out
network_usage() {
    echo "Checking network usage..."

    # Display RX and TX stats of enp2s0f1 and enp2s0f0
    ip -s link show enp2s0f1 | awk '/RX:/ {getline; print "RX: " $1 " packets, " $2 " bytes"}; /TX:/ {getline; print "TX: " $1 " packets, " $2 " bytes"}'
    ip -s link show enp2s0f0 | awk '/RX:/ {getline; print "RX: " $1 " packets, " $2 " bytes"}; /TX:/ {getline; print "TX: " $1 " packets, " $2 " bytes"}'

}

# how all IP addresses
show_ips() {
    echo "Showing all IP addresses..."
    ip -br addr
}

# properly shut down the server
shutdown_server() {
    echo "Shutting down the server..."
    sudo shutdown -h now
}

# Main menu
while true; do
    echo "=================="
    echo "Server Multi-Tool"
    echo "=================="
    echo "1. Energy Usage (PSU 1 and 2)"
    echo "2. CPU Usage and Temps"
    echo "3. Network In and Out (enp2s0f1)"
    echo "4. Show All IPs"
    echo "5. Shutdown Server"
    echo "6. Exit"
    echo "=================="
    read -p "Select an option (1-6): " choice

    case $choice in
        1) energy_usage ;;
        2) cpu_usage_and_temp ;;
        3) network_usage ;;
        4) show_ips ;;
        5) shutdown_server ;;
        6) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option, please select a valid number." ;;
    esac

    echo ""
done
