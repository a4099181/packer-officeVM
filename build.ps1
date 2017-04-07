Param( [Parameter(Mandatory)] [String] $isoUrl,
                              [String] $os      = 'windows-10.1703',
                              [String] $locale  = 'pl-PL')

Function Invoke-Packer
{
    Param( [ValidateSet('windows-10.1607','windows-10.1703')]
           [Parameter(Mandatory)] [String] $os,
           [ValidateSet('pl-PL')]
           [Parameter(Mandatory)] [String] $locale,
           [Parameter(Mandatory)] [String] $isoUrl,
           [Parameter(Mandatory)] [String] $isoMd5 )

    packer build `
        --var iso_url="$isoUrl" `
        --var iso_checksum=$isoMd5 `
        --var os=$os `
        --var autounattend=.\$os\$locale\Autounattend.xml `
        --only=virtualbox-iso .\$os\template.json

    if ( -Not $? )
    {
        throw "Non-zero exit code from packer (exit code: $lastExitCode). See packer output."
    }
}

Function Step-BuildVersion
{
    Param( [Parameter(Mandatory)] [String] $os,
                                  [String] $boxFile = "packed\$os.json",
                                  [String] $default = @"
    { "name"     : "packer-officeVM",
      "versions" : [{
                 "version"   : "$($os.Split("-")[1])",
                 "providers" : [{
                             "name" : "virtualbox",
                             "url"  : "packer-officeVM/packed/$os.virtualbox.box"
                 }]
      }]
    }
"@ )

    ( $(If (Test-Path $boxFile) { Get-Content $boxFile } Else { $default }) | ConvertFrom-Json ) |
        % {
            $box = $_
            $box.versions |
            % {
                $_.version = ( New-Object Version $_.version |
                    % { New-Object Version $_.Major, $_.Minor, ( $_.Build + 1 ) } ).ToString(3)
            }

            $box | ConvertTo-Json -Compress -Depth 4 | Out-File -Encoding ascii $boxFile
        }
}

Invoke-Packer $os $locale $isoUrl ( Get-FileHash $isoUrl -Algorithm MD5 ).Hash -ErrorAction Stop
Step-BuildVersion $os
