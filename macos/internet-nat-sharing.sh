#!/bin/sh
#
# mikrotik(dhcp server) -> mac usbEth(dhcp client)
# set default route on mikrotik to point to Mac dhcp client IP
#
sudo sysctl -w net.inet.ip.forwarding=1
# sudo sysctl -w net.inet6.ip6.forwarding=1
sudo pfctl -d
sudo pfctl -F all
sudo pfctl -f /Users/jlima/.dotfiles/_code/macos/internet-sharing/nat-rules.txt -e

# check status
# sudo pfctl -s all
# sudo pfctl -s nat
# sudo pfctl -s rules

echo "Please check the utun interface used by vpn"
