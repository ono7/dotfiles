# linux email configuration using gmail

## configure cronie (crontab arch linux)

sudo pacman -Sy cronie postfix
sudo systemctl enable --now cronie
systemctl status cronie

## secrets

vim /etc/postfix/sasl_passwd

```
[smtp.gmail.com]:587 your-email@gmail.com:your-app-password
```

## /etc/postfix/aliase

```
postmaster: root
mailer-daemon: root
root: jxxxxxx@gmail.com
```

## /etc/postfix/main.cf

```
compatibility_level = 3.10
queue_directory = /var/spool/postfix
command_directory = /usr/bin
daemon_directory = /usr/lib/postfix/bin
data_directory = /var/lib/postfix
mail_owner = postfix
unknown_local_recipient_reject_code = 550
alias_maps = lmdb:/etc/postfix/aliases
alias_database = $alias_maps

debug_peer_level = 2

debugger_command =
PATH=/bin:/usr/bin:/usr/local/bin:/usr/X11R6/bin
ddd $daemon_directory/$process_name $process_id & sleep 5

sendmail_path = /usr/bin/sendmail
newaliases_path = /usr/bin/newaliases
mailq_path = /usr/bin/mailq
setgid_group = postdrop
html_directory = no
manpage_directory = /usr/share/man
sample_directory = /etc/postfix

readme_directory = /usr/share/doc/postfix
inet_protocols = ipv4
shlib_directory = /usr/lib/postfix
meta_directory = /etc/postfix

myhostname = lan55.homenet.local
mydomain = homenet.local
myorigin = $mydomain
inet_interfaces = loopback-only
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
relayhost = [smtp.gmail.com]:587

# For Gmail SMTP

smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = texthash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_security_level = encrypt
smtp_use_tls = yes
```

## Check configuration

postfix check

## Restart postfix

## Enable and start the service

systemctl enable postfix
systemctl start postfix

## Test mail

echo "Test with texthash" | mail -s "Test" your-email@gmail.com

## Watch logs

journalctl -u postfix -f

or

## setup ssmtp on linux

sudo apt install ssmtp
file: /etc/ssmtp/ssmtp.conf

```
root=user@gmail.com
mailhub=smtp.gmail.com:587
AuthUser=user@gmail.com
AuthPass=xxxxx
UseSTARTTLS=YES
FromLineOverride=YES
from=user@gmail.com
```
