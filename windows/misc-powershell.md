# Misc. PowerShell

```powershell
Get-WinEvent -FilterHashtable @{LogName='System'; Level=1,2; StartTime=(Get-Date).AddDays(-1)} | Select TimeCreated, LevelDisplayName, ProviderName, Message | Format-Table -Wrap
```

