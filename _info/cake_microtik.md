# microtik qos setup

***when changing from queue-tree to interface queue type directly a reboot is needed***

## check stats

/interface print stats where name=e1_LAN or name=e5_WAN


/interface monitor-traffic e1_LAN,e5_WAN
