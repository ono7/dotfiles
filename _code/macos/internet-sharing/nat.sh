#!/bin/sh
sysctl -w net.inet.ip.forwarding=1
# sysctl -w net.inet6.ip6.forwarding=1
pfctl -d
pfctl -F all
pfctl -f /Users/jlima/.dotfiles/_code/macos/internet-sharing/nat-rules.txt -e

# sudo pfctl -s all
# sudo pfctl -s nat
# sudo pfctl -s rules
