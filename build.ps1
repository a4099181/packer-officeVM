Param( [Parameter(Mandatory)] [String] $isoUrl,
                              [String] $os = 'windows10_1607' )

Function Invoke-Packer
{
    Param( [ValidateSet('windows10_1607','windows10_1703')]
           [Parameter(Mandatory)] [String] $os,
           [Parameter(Mandatory)] [String] $isoUrl,
           [Parameter(Mandatory)] [String] $isoMd5 )

    packer build `
        --var iso_url="$isoUrl" `
        --var iso_checksum=$isoMd5 `
        --var autounattend=.\$os\Autounattend.xml `
        --only=virtualbox-iso .\$os\template.json
}

Invoke-Packer $os $isoUrl ( Get-FileHash $isoUrl -Algorithm MD5 ).Hash
