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
