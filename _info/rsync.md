# backup files and exclude some

rsync -rv --exclude=.git noa_bb codebase1

## backups

crontab

### no progress bar, only shows files and action

`0 4 * * * /usr/bin/rsync -ravh --partial --delete /home/jlima/containers jlima@100.64.0.5:~/lan50-containers-backup`

### with progress bar and partial -P

`0 4 * * * /usr/bin/rsync -rPavh /home/jlima/containers 100.64.0.50:~/lan5-containers-backup`
