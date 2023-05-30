#!/bin/bash

architecture="#Architecture: "$(uname -a)

physical_cpu="#CPU physical: "$(grep "physical id" /proc/cpuinfo | wc -l)
virtual_cpu="#vCPU: "$(grep "processor" /proc/cpuinfo | wc -l)

ram_used=$(free --mega | awk '$1=="Mem:" {print $3}')
ram_total=$(free --mega | awk '$1=="Mem:" {print $2}')
ram_ratio=$(free --mega | awk '$1=="Mem:" {printf("(%0.2f%%)"), $3/$2*100}')
ram_usage="#Memory Usage: ${ram_used}/${ram_total}MB ${ram_ratio}"

disk_used=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{used_disk+=$3} END {print used_disk}')
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{total_disk+=$2} END {printf("%0.0f"), total_disk/1024}')"Gb"
disk_ratio=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{used+=$3} {total+=$2} END {printf("(%d%%)"), used/total*100}')
disk_usage="#Disk Usage: ${disk_used}/${disk_total} ${disk_ratio}"

cpu_load="#CPU load: "$(mpstat | tail -1 | awk '{printf("%0.1f%%"), 100 - $13}')

last_boot="#Last boot: "$(who -b | awk  '$1=="system" {print $3 " " $4}')

lvm_count=$(lsblk | grep "lvm" | wc -l)
if [ $lvm_count -gt 0 ]; then lvm="#LVM use: yes"; else lvm="#LVM use: no"; fi

tcp_connections="#Connections TCP: "$(ss -ta | grep "ESTAB" | wc -l)" ESTABLISHED"

users_num="#User log: "$(users | wc -w)

ip=$(hostname -I)
mac_address=$(ip link | awk '$1=="link/ether" {print $2}')
network="#Network: IP "$ip"($mac_address)"

sudo_num="#Sudo: "$(journalctl _COMM=sudo | grep "COMMAND" | wc -l)" cmd"

wall "	$architecture
	$physical_cpu
	$virtual_cpu
	$ram_usage
	$disk_usage
	$cpu_load
	$last_boot
	$lvm
	$tcp_connections
	$users_num
	$network
	$sudo_num"
