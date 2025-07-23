# backup files and exclude some

rsync -rv --exclude=.git noa_bb codebase1

## backups

crontab

### no progress bar, only shows files and action

`0 4 * * * /usr/bin/rsync -ravh --partial --delete /home/jlima/containers jlima@100.64.0.5:~/lan50-containers-backup`

### with progress bar and partial -P

`0 4 * * * /usr/bin/rsync -rPavh /home/jlima/containers 100.64.0.50:~/lan5-containers-backup`

```sh
#!/bin/bash
# this is jsut an example should not be used in production systems
servers=(1.1.1.1 1.1.1.2)

log() {
  printf '[ %s ] - %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" | tee -a ~/rsync.log
}

log "Starting rsync process"
log "Target servers: ${servers[*]}"

for server in "${servers[@]}"; do
    log "Processing server: $server"

    if sudo /usr/bin/rsync -rahv --partial --delete --stats --rsync-path="sudo rsync" -e "ssh -i ~/.ssh/server.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" /opt/netdevops/os-upgrades/images $USER@$server:/opt/netdevops/os-upgrades/ >> rsync.log; then
        log "✓ SUCCESS: rsync job for $server completed"
    else
        log "✗ FAILED: rsync job for $server failed"
    fi
done
log "rsync process completed"
```
