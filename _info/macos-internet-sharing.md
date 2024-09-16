```
#!/bin/sh
sysctl -w net.inet.ip.forwarding=1
sysctl -w net.inet6.ip6.forwarding=1
pfctl -d
pfctl -F all
pfctl -f /Users/me/vpn/nat-rules.txt -e

# this should be wireguard tunnel int
ext_if = "utun0"
nat on $ext_if inet from ! ($ext_if) to any -> ($ext_if)
nat on $ext_if inet6 from ! ($ext_if) to any -> ($ext_if)
```
