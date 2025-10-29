#!/bin/bash
# System Audit Script — collects CPU, memory, disk, and network info

cleanup() {
  rm -f /tmp/sysinfo.$$ /tmp/memoryinfo.$$ /tmp/cpuinfo.$$ 2>/dev/null
  echo "Cleanup complete."
  exit 0
}
trap cleanup INT

echo "Gathering system information..."
sudo lshw -class system > /tmp/sysinfo.$$ 2>/dev/null
sudo lshw -class memory > /tmp/memoryinfo.$$ 2>/dev/null
sudo lshw -class cpu > /tmp/cpuinfo.$$ 2>/dev/null

HOSTNAME=$(hostname)
OS=$(lsb_release -d | cut -f2)
CPU=$(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2)
MEM=$(free -h | awk '/Mem:/{print $2}')
DISK=$(df -h / | awk 'NR==2 {print $2 " total, " $4 " free"}')
IP=$(hostname -I | awk '{print $1}')

cat <<EOF

===== SYSTEM REPORT =====
Hostname:   $HOSTNAME
OS:         $OS
CPU:        $CPU
Memory:     $MEM
Disk:       $DISK
IP Address: $IP
==========================

EOF 

