# tunneling

ssh -L \*:80:192.168.117.200:80 user@pivothost

\* = bind to all addresses (makes this socket public)
80 = expose this port to the lan
192.168.117.200 = remote host to expose
:80 = remote host port

# create ssh keys

- in alternate directory

  ssh-keygen -t rsa -b 4096 -C "noa_tower@conseto.com" -f ~/tmp/dir/tower

- in current directory

  ssh-keygen -t rsa -b 4096 -C "noa_tower@conseto.com" -f tower

```
Host *
  SendEnv LANG -LC_* -LANG* COLORTERM
  ServerAliveInterval 30
  ServerAliveCountMax 3

  # this is not recommended for prod
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null

  # Kex algos can be obtained with "ssh -Q kex"
  # KexAlgorithms +diffie-hellman-group1-sha1,ssh-dss
  # KexAlgorithms +diffie-hellman-group1-sha1,diffie-hellman-group14-sha1
  KexAlgorithms +diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1
  HostkeyAlgorithms=+ssh-rsa
  # Allow older algos for cisco crap gear...
  # PasswordAuthentication
  Ciphers +aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc,aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc
  IPQoS cs2
```
