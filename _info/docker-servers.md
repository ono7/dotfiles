### mumble voice server

```
services:
    mumble-server:
        image: mumblevoip/mumble-server:latest
        container_name: mumble-voip-server
        hostname: lan55.homenet.local
        # restart: on-failure
        restart: unless-stopped
        ports:
            - "100.64.0.55:64738:64738"
            - "100.64.0.55:64738:64738/udp"
```

### pihole server

```
# More info at https://github.com/pi-hole/docker-pi-hole/ and https://docs.pi-hole.net/
services:
  pihole:
    container_name: pihole-adults
    image: pihole/pihole:latest
    # For DHCP it is recommended to remove these ports and instead add: network_mode: "host"
    ports:
      - "100.64.0.51:53:53/tcp"
      - "100.64.0.51:53:53/udp"
      - "100.64.0.51:80:80/tcp"
      - "100.64.0.55:53:53/tcp"
      - "100.64.0.55:53:53/udp"
      - "100.64.0.55:80:80/tcp"
    environment:
      TZ: 'America/Chicago'
      WEBPASSWORD: <passdoeshere>
    volumes:
      - './etc-pihole:/etc/pihole'
      - './etc-dnsmasq.d:/etc/dnsmasq.d'
    cap_add:
      - NET_ADMIN # Required if you are using Pi-hole as your DHCP server, else not needed
      - SYS_TIME
      - CAP_SYS_NICE
    restart: unless-stopped
```

### wireguard

```
services:
  wireguard:
    image: lscr.io/linuxserver/wireguard:latest
    container_name: wireguard-4500
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Chicago
      - SERVERURL=<server_url>
      - SERVERPORT=4500
      - PEERS=<peer1>,<peer2>,<peer3>
      - PEERDNS=100.64.0.50
      - INTERNAL_SUBNET=100.64.125.0
      - ALLOWEDIPS=0.0.0.0/0
      - LOG_CONFS=true
    volumes:
      - ./config:/config
    ports:
      - 100.64.0.50:4500:51820/udp
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    restart: unless-stopped

```
