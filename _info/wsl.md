## copy and paste neovim

install wl-copy (in setup/setup_linux_deps.sh), neovim will detect and use
accordingly, tmux just works with alacritty configuration

## wsl adjust the nat range to allow vpn

## install wsl


```sh
wsl --update --web-download
wsl --set-default-version 2
wsl --update
wsl --install
```

```sh

wsl --update
wsl --install

# Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss]
"NatGatewayIpAddress"="100.65.0.1"
"NatNetwork"="100.65.0.0/24"
```

# windows keyboard repeat rate

- use the "Filter Keys" feature in the Ease of
  Access center to speed it up.

```
[HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response]
"AutoRepeatDelay"="200"
"AutoRepeatRate"="10"
"DelayBeforeAcceptance"="0"
"Flags"="59"
"BounceTime"="0"
```

# Start-Process powershell -Verb runas

run this as admin to set metric on vpn client to 6000, should run every time we connect
needs LxssManager to restart

```powershell
Get-NetAdapter | Where-Object {$_.InterfaceDescription -Match "Cisco AnyConnect"} | Set-NetIPInterface -InterfaceMetric 6000
Restart-Service LxssManager
```

# nat ports

```powershell
netsh interface portproxy add v4tov4 listenport=[PORT] listenaddress=0.0.0.0 connectport=[PORT] connectaddress=[WSL_IP]

<!-- view ports -->

netsh interface portproxy show v4tov4

<!-- windows firewall add ports -->

New-NetFirewallRule -DisplayName "WSL2 Port Bridge" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 80,443,10000,3000,5000

```

## Automate via powershell script

```ps1
$ports = @(80, 443, 10000, 3000, 5000);

$wslAddress = bash.exe -c "ifconfig eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"

if ($wslAddress -match '^(\d{1,3}\.){3}\d{1,3}$') {
  Write-Host "WSL IP address: $wslAddress" -ForegroundColor Green
  Write-Host "Ports: $ports" -ForegroundColor Green
}
else {
  Write-Host "Error: Could not find WSL IP address." -ForegroundColor Red
  exit
}

$listenAddress = '0.0.0.0';

foreach ($port in $ports) {
  Invoke-Expression "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$listenAddress";
  Invoke-Expression "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$listenAddress connectport=$port connectaddress=$wslAddress";
}

$fireWallDisplayName = 'WSL Port Forwarding';
$portsStr = $ports -join ",";

Invoke-Expression "Remove-NetFireWallRule -DisplayName $fireWallDisplayName";
Invoke-Expression "New-NetFireWallRule -DisplayName $fireWallDisplayName -Direction Outbound -LocalPort $portsStr -Action Allow -Protocol TCP";
Invoke-Expression "New-NetFireWallRule -DisplayName $fireWallDisplayName -Direction Inbound -LocalPort $portsStr -Action Allow -Protocol TCP";
```
