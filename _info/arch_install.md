#

- configure all options and reboot
  - for extra packages choose add: git neovim
    `pacman-key --init`
    `pacman-key --populate`
    `archinstall`
    `cd /opt, git clone https://aur.archlinux.org/yay.git.git`
    `chown -R jlima:jlima yay.git`
    `cd yay-git; makepkg -si`

## themes

(darcula)
`xfce4-appearance-settings`
`lxappearance`

## network

Example network config multiple IPs

`/etc/systemd/network/20-ethernet.network`

```config
[Match]
# Matching with "Type=ether" causes issues with containers because it also matches virtual Ethernet interfaces (veth*).
# See https://bugs.archlinux.org/task/70892
# Instead match by globbing the network interface name.
# Name=en*
# Name=eth*
Name=enp0s13f0u3

[Link]
RequiredForOnline=routable

[Network]
Address=100.64.0.50/24
Address=100.64.0.51/24
Address=100.64.0.52/24
Address=100.64.0.53/24
Address=100.64.0.54/24
Address=100.64.0.55/24

Gateway=100.64.0.1

# ~ = makes is a search domain
# Domains=~homenet.local
Domains=homenet.local

DNS=100.64.0.1
MulticastDNS=yes

[DHCPv4]
RteMetric=100
```

## DNS (resolve.conf)

Example dns configuration

/etc/systemd/resolved.conf

```config
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it under the
#  terms of the GNU Lesser General Public License as published by the Free
#  Software Foundation; either version 2.1 of the License, or (at your option)
#  any later version.
#
# Entries in this file show the compile time defaults. Local configuration
# should be created by either modifying this file (or a copy of it placed in
# /etc/ if the original file is shipped in /usr/), or by creating "drop-ins" in
# the /etc/systemd/resolved.conf.d/ directory. The latter is generally
# recommended. Defaults can be restored by simply deleting the main
# configuration file and all drop-ins located in /etc/.
#
# Use 'systemd-analyze cat-config systemd/resolved.conf' to display the full config.
#
# See resolved.conf(5) for details.

[Resolve]
# Some examples of DNS servers which may be used for DNS= and FallbackDNS=:
# Cloudflare: 1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com 2606:4700:4700::1111#cloudflare-dns.com 2606:4700:4700::1001#cloudflare-dns.com
# Google:     8.8.8.8#dns.google 8.8.4.4#dns.google 2001:4860:4860::8888#dns.google 2001:4860:4860::8844#dns.google
# Quad9:      9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
#DNS=
#FallbackDNS=1.1.1.1#cloudflare-dns.com 9.9.9.9#dns.quad9.net 8.8.8.8#dns.google 2606:4700:4700::1111#cloudflare-dns.com 2620:fe::9#dns.quad9.net 2001:4860:4860::8888#dns.google
Domains=homenet.local
#DNSSEC=no
#DNSOverTLS=no
#MulticastDNS=yes
#LLMNR=yes
#Cache=yes
#CacheFromLocalhost=no
#DNSStubListener=yes
#DNSStubListenerExtra=
#ReadEtcHosts=yes
#ResolveUnicastSingleLabel=no
#StaleRetentionSec=0
FallbackDNS=100.64.0.1
DNS=100.64.0.1
```
