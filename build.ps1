Param( [Parameter(Mandatory)] [String] $isoUrl,
                              [String] $provider     = 'hyperv',
                              [String] $locale       = 'pl-PL',
                              [String] $winrmTimeout = '10m',
                                       $disksize     = 81920
)

DynamicParam {
    $attributes = new-object System.Collections.ObjectModel.Collection[System.Attribute]

    $attribute = New-Object System.Management.Automation.ParameterAttribute
    $attribute.Position = 0
    $attribute.ParameterSetName = "os"
    $attributes.Add($attribute)

    $validOS = (Get-ChildItem -Directory windows-*).Name | Sort-Object -Descending

    if ($validOS) {
        $validateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($validOS)
        $attributes.Add($validateSetAttribute)
    }

    $parameter = New-Object System.Management.Automation.RuntimeDefinedParameter('os', [string], $attributes)

    $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
    $paramDictionary.Add('os', $parameter)
    return $paramDictionary
}

begin {
    if ($PsBoundParameters['os']) {
        $os = $PsBoundParameters['os']
    } else {
        $os = (Get-ChildItem -Directory windows-*).Name | Select-Object -Last 1
    }
}

process {

Function Invoke-Packer
{
    Param( [ValidateSet( 'windows-10.22H2'
        ,'windows-10.21H2'
        ,'windows-10.21H1'
        ,'windows-10.20H2'
        ,'windows-10.1903'
    )]
           [Parameter(Mandatory)] [String] $os,
           [ValidateSet('hyperv','virtualbox')]
           [Parameter(Mandatory)] [String] $provider,
           [ValidateSet('pl-PL')]
           [Parameter(Mandatory)] [String] $locale,
           [Parameter(Mandatory)] [String] $isoUrl,
           [Parameter(Mandatory)] [String] $isoMd5,
           [Parameter(Mandatory)] [int]    $disksize,
           [Parameter(Mandatory)] [String] $winrmTimeout )

    packer build `
        --var iso_url="$isoUrl" `
        --var disk_size=$disksize `
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
                $version = $_.version.Split('.')
                $build = if ($version.Length -eq 3 ) { $version[2] } else { 0 }
                $_.version = ($version[0], $version[1], (([int]$build)+1)) -join '.'

                $_.providers = @( Get-ChildItem "packed" |
                                        ? Name -Like "$os.*.box" |
                                        Select-Object @{ N='name'; E={ $_.Name.Split('.')[2] } },
                                                      @{ N='url';  E={ $_.FullName } } )

            }

            $_ | ConvertTo-Json -Compress -Depth 4 | Out-File -Encoding ascii $boxFile
        }
}

Invoke-Packer $os $provider $locale $isoUrl ( Get-FileHash $isoUrl -Algorithm MD5 ).Hash $disksize $winrmTimeout -ErrorAction Stop
Step-BuildVersion $os

}