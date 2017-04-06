Param( [Parameter(Mandatory)] [String] $isoUrl,
                              [String] $os     = 'windows10_1703',
                              [String] $locale = 'pl-PL' )

Function Invoke-Packer
{
    Param( [ValidateSet('windows10_1607','windows10_1703')]
           [Parameter(Mandatory)] [String] $os,
           [ValidateSet('pl-PL')]
           [Parameter(Mandatory)] [String] $locale,
           [Parameter(Mandatory)] [String] $isoUrl,
           [Parameter(Mandatory)] [String] $isoMd5 )

    packer build `
        --var iso_url="$isoUrl" `
        --var iso_checksum=$isoMd5 `
        --var autounattend=.\$os\$locale\Autounattend.xml `
        --only=virtualbox-iso .\$os\template.json
}

Invoke-Packer $os $locale $isoUrl ( Get-FileHash $isoUrl -Algorithm MD5 ).Hash
