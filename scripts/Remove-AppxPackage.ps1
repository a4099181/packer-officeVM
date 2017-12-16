
Param ( [String[]] $WantedAppxPackages = @(
                                        "Microsoft.Office.OneNote",
                                        "Microsoft.WindowsCalculator",
                                        "Microsoft.Windows.Photos")
      , [String[]] $UnremovableAppxPackages = @(
                                        "1527c705-839a-4832-9118-54d4Bd6a0c89",
                                        "c5e2524a-ea46-4f67-841f-6a9465d9d515",
                                        "CortanaListenUIApp",
                                        "DesktopLearning",
                                        "DesktopView",
                                        "E2A4F912-2574-4A75-9BB0-0D023378592B",
                                        "EnvironmentsApp",
                                        "HoloCamera",
                                        "HoloItemPlayerApp",
                                        "HoloShell",
                                        "Microsoft.AAD.BrokerPlugin",
                                        "Microsoft.AccountsControl",
                                        "Microsoft.BioEnrollment",
                                        "Microsoft.CredDialogHost",
                                        "Microsoft.LockApp",
                                        "Microsoft.MicrosoftEdge",
                                        "Microsoft.PPIProjection",
                                        "Microsoft.Windows.Apprep.ChxApp",
                                        "Microsoft.Windows.AssignedAccessLockApp",
                                        "Microsoft.Windows.CloudExperienceHost",
                                        "Microsoft.Windows.ContentDeliveryManager",
                                        "Microsoft.Windows.Cortana",
                                        "Microsoft.Windows.HolographicFirstRun",
                                        "Microsoft.Windows.ModalSharePickerHost",
                                        "Microsoft.Windows.OOBENetworkCaptivePortal",
                                        "Microsoft.Windows.OOBENetworkConnectionFlow",
                                        "Microsoft.Windows.ParentalControls",
                                        "Microsoft.Windows.SecHealthUI",
                                        "Microsoft.Windows.SecondaryTileExperience",
                                        "Microsoft.Windows.SecureAssessmentBrowser",
                                        "Microsoft.Windows.ShellExperienceHost",
                                        "Microsoft.Windows.WindowPicker",
                                        "Microsoft.XboxGameCallableUI",
                                        "Windows.ContactSupport",
                                        "windows.immersivecontrolpanel",
                                        "Windows.MiracastView",
                                        "Windows.PrintDialog"
                                        )
      , [String[]] $Dependencies = ( Get-AppxPackage |
                                        ? Name  -In $WantedAppxPackages |
                                        Select-Object -expand Dependencies |
                                        Select-Object -expand Name -Unique ) )

Get-AppxProvisionedPackage -Online |
    Where-Object DisplayName -NotIn $WantedAppxPackages |
    Remove-AppxProvisionedPackage -Online |
    Out-Null

Get-AppxPackage -AllUsers |
    Where-Object Name -NotIn $WantedAppxPackages |
    Where-Object Name -NotIn $UnremovableAppxPackages |
    Where-Object Name -NotIn $Dependencies |
    Sort-Object Dependencies -Descending |
    Remove-AppxPackage
