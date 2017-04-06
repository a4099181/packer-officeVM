Get-ChildItem e:\cert -Filter *.cer |
    % { e:\cert\VBoxCertUtil add-trusted-publisher $_.FullName --root $_.FullName }

e:\VBoxWindowsAdditions /S
