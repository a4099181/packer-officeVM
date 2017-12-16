Param( [Parameter(Mandatory)] [String] $isoUrl,
                              [String] $provider     = 'virtualbox',
                              [String] $os           = 'windows-10.1709',
                              [String] $locale       = 'pl-PL',
                              [String] $winrmTimeout = '10m' )

Function Invoke-Packer
{
    Param( [ValidateSet('windows-10.1709','windows-10.1607','windows-10.1703')]
           [Parameter(Mandatory)] [String] $os,
           [ValidateSet('hyperv','virtualbox')]
           [Parameter(Mandatory)] [String] $provider,
           [ValidateSet('pl-PL')]
           [Parameter(Mandatory)] [String] $locale,
           [Parameter(Mandatory)] [String] $isoUrl,
           [Parameter(Mandatory)] [String] $isoMd5,
           [Parameter(Mandatory)] [String] $winrmTimeout )

    packer build `
        --var iso_url="$isoUrl" `
        --var iso_checksum=$isoMd5 `
        --var os=$os `
        --var autounattend=.\$os\$locale\$provider\Autounattend.xml `
        --var winrm_timeout=$winrmTimeout `
        --only=$provider-iso .\$os\template.json

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
                 "providers" : [ ]
      }]
    }
"@ )

    ( $(If (Test-Path $boxFile) { Get-Content $boxFile } Else { $default }) | ConvertFrom-Json ) |
        % {
            $_.versions |
            % {
                $_.version = ( New-Object Version $_.version |
                    % { New-Object Version $_.Major, $_.Minor, ( $_.Build + 1 ) } ).ToString(3)

                $_.providers = @( Get-ChildItem "packed" |
                                        ? Name -Like "$os.*.box" |
                                        Select-Object @{ N='name'; E={ $_.Name.Split('.')[2] } },
                                                      @{ N='url';  E={ $_.FullName } } )

            }

            $_ | ConvertTo-Json -Compress -Depth 4 | Out-File -Encoding ascii $boxFile
        }
}

Invoke-Packer $os $provider $locale $isoUrl ( Get-FileHash $isoUrl -Algorithm MD5 ).Hash $winrmTimeout -ErrorAction Stop
Step-BuildVersion $os
