Get-NetConnectionProfile |
    ? NetworkCategory -eq Public |
    Set-NetConnectionProfile -NetworkCategory Private
