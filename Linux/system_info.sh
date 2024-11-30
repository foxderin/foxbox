#!/bin/bash

# 检查操作系统和内核信息
echo "=== 系统信息 ==="
echo "操作系统名称: $(uname -o)"
echo "发行版信息: $(cat /etc/*-release | grep -m 1 '^PRETTY_NAME' | cut -d= -f2 | tr -d '\"')"
echo "内核版本: $(uname -r)"
echo "架构: $(uname -m)"

# 检查 CPU 信息
echo
echo "=== CPU 信息 ==="
echo "CPU 型号: $(grep -m 1 'model name' /proc/cpuinfo | cut -d: -f2 | sed 's/^ //')"
echo "CPU 核心数: $(grep -c 'processor' /proc/cpuinfo)"

# 检查内存使用情况
echo
echo "=== 内存信息 ==="
free -h | awk 'NR==1{print $0} NR==2{print $0}'

# 检查磁盘使用情况
echo
echo "=== 磁盘信息 ==="
df -h --total | grep -E 'Filesystem|total'

# 检查网络信息
echo
echo "=== 网络信息 ==="
ip -brief link | awk '{print $1, $2, $3}' | column -t

# 检查运行时间
echo
echo "=== 系统运行时间 ==="
uptime -p

# 检查已登录用户
echo
echo "=== 当前登录用户 ==="
who

# 检查系统负载
echo
echo "=== 系统负载 ==="
uptime | awk -F 'load average:' '{print "当前负载: " $2}'

echo
echo "=== 脚本运行完成 ==="
