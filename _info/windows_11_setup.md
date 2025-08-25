https://www.reddit.com/r/Argaming/comments/1k69bqw/mi_gu%C3%ADa_definitiva_de_optimizaci%C3%B3n_para_windows/?tl=en
remove this


## registry

````
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 0x28 /f


```
## remove bloatware

```
Set-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 0x28 -Type DWord

Get-AppxPackage -AllUsers MicrosoftCorporationII.QuickAssist | Remove-AppxPackage
Get-AppxPackage -AllUsers Microsoft.WindowsFeedbackHub | Remove-AppxPackage
Get-AppxPackage -AllUsers Microsoft.Copilot | Remove-AppxPackage
Get-AppxPackage -AllUsers Microsoft.BingWeather | Remove-AppxPackage
Get-AppxPackage -AllUsers MicrosoftCorporationII.MicrosoftFamily | Remove-AppxPackage
Get-AppxPackage -AllUsers Microsoft.MicrosoftOfficeHub | Remove-AppxPackage
Get-AppxPackage -AllUsers Microsoft.BingSearch | Remove-AppxPackage
Get-AppxPackage -AllUsers Clipchamp.Clipchamp | Remove-AppxPackage
Get-AppxPackage -AllUsers MSTeams | Remove-AppxPackage
Get-AppxPackage -AllUsers Microsoft.Todos | Remove-AppxPackage
Get-AppxPackage -AllUsers Microsoft.MicrosoftStickyNotes | Remove-AppxPackage
Get-AppxPackage -AllUsers Microsoft.BingNews | Remove-AppxPackage
Get-AppxPackage -AllUsers Microsoft.OutlookForWindows | Remove-AppxPackage
Get-AppxPackage -AllUsers Microsoft.WindowsAlarms | Remove-AppxPackage
Get-AppxPackage -AllUsers Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage

```

## HPET optimization

```
bcdedit /set useplatformtick yes
bcdedit /set disabledynamictick yes
bcdedit /deletevalue useplatformclock

```
