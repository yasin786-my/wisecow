#!/bin/sh

CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

check_cpu() {
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    echo "CPU Usage: ${cpu_usage}%"
    if [ $(echo "$cpu_usage > $CPU_THRESHOLD" | awk '{print ($1 > $3)}') -eq 1 ]; then
        echo "ALERT: CPU usage ${cpu_usage}% exceeds threshold ${CPU_THRESHOLD}%"
    fi
}

check_memory() {
    mem_total=$(free -m | awk '/^Mem:/{print $2}')
    mem_used=$(free -m | awk '/^Mem:/{print $3}')
    mem_usage=$(awk "BEGIN {printf \"%.1f\", ($mem_used/$mem_total)*100}")
    echo "Memory Usage: ${mem_usage}%"
    if [ $(awk "BEGIN {print ($mem_usage > $MEM_THRESHOLD)}") -eq 1 ]; then
        echo "ALERT: Memory usage ${mem_usage}% exceeds threshold ${MEM_THRESHOLD}%"
    fi
}

check_disk() {
    disk_usage=$(df / | awk 'NR==2{print $5}' | tr -d '%')
    echo "Disk Usage: ${disk_usage}%"
    if [ "$disk_usage" -gt "$DISK_THRESHOLD" ]; then
        echo "ALERT: Disk usage ${disk_usage}% exceeds threshold ${DISK_THRESHOLD}%"
    fi
}

check_processes() {
    proc_count=$(ps | wc -l)
    echo "Running Processes: $proc_count"
    if [ "$proc_count" -gt 500 ]; then
        echo "ALERT: High process count: $proc_count"
    fi
}

echo "---- System Health Check ----"
check_cpu
check_memory
check_disk
check_processes
echo "---- Check Complete ----"