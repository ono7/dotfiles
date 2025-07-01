# backup files and exclude some

rsync -rv --exclude=.git noa_bb codebase1

## backups

crontab

### no progress bar, only shows files and action

`0 4 * * * /usr/bin/rsync -ravh --partial --delete /home/jlima/containers jlima@100.64.0.5:~/lan50-containers-backup`

### with progress bar and partial -P

`0 4 * * * /usr/bin/rsync -rPavh /home/jlima/containers 100.64.0.50:~/lan5-containers-backup`

this is jsut an example should not be used in production systems

```sh
#!/bin/bash
# rsync script, see crontab -l, will connect over ssh using ansible-prod-user
# account and use sudo for the rest, will log to rsync.log only if there is an
# error during the process
servers=(1.1.1.2 1.1.1.3)

echo "Starting rsync process at $(date)"
echo "Target servers: ${servers[*]}"
echo "----------------------------------------"

for server in "${servers[@]}"; do
    echo "Processing server: $server"

    if sudo /usr/bin/rsync -rahv --partial --delete --stats --rsync-path="sudo rsync" -e "ssh -i ~/.ssh/server.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" /opt/netdevops/os-upgrades/images ansible-prod-user@$server:/opt/netdevops/os-upgrades/; then
        echo "✓ SUCCESS: rsync job for $server completed"
        echo "$(date) - rsync job for $server success" >> ~/rsync.log
    else
        echo "✗ FAILED: rsync job for $server failed"
        echo "$(date) - rsync job for $server failed" >> ~/rsync.log
    fi
    echo "----------------------------------------"
done

echo "rsync process completed at $(date)"
```
