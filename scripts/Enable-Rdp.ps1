Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -Value 0

Get-NetFirewallRule |
    ? DisplayGroup -in 'Pulpit zdalny', 'Remote desktop' |
    Enable-NetFirewallRule
