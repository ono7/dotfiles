# backup files and exclude some

rsync -rv --exclude=.git noa_bb codebase1

## backups

crontab
`0 4 * * * /usr/bin/rsync -rPavh /home/jlima/containers 100.64.0.50:~/lan5-containers-backup`
