#Source: https://github.com/Eduserv/intune-scripts

Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2
Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root
dism /online /disable-feature /FeatureName:MicrosoftWindowsPowerShellV2Root
dism /online /disable-feature /FeatureName:MicrosoftWindowsPowerShellV2