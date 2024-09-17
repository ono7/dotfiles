#!/usr/bin/env bash
#  Author:  Jose Lima (jlima)
#  Date:    2024-09-17 13:32

sysctl net.inet.tcp.sack
sudo sysctl -w kern.ipc.maxsockbuf=12582912
sudo sysctl -w net.inet.tcp.sendspace=1048576
sudo sysctl -w net.inet.tcp.recvspace=1048576

# check window scaling (usually enabled by default)
sysctl net.inet.tcp.win_scale_factor

sudo sysctl -w net.inet.tcp.win_scale_factor=3

sudo sysctl -w net.inet.tcp.slowstart_flightsize=10
sudo sysctl -w net.inet.tcp.fastopen=3
