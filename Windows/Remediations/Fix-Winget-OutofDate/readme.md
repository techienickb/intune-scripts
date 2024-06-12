# Fix Winget being out of date
Looks at winget to see if it's referencing the old CDN, if it is it will download PowerShell 7 and then run the Winget powershell command to fix the install

Additional script [wingetupdate.ps1](./wingetupdate.ps1) can be set as a manual remediation script which for fixes winget

## Remediation steps
Since the winget powershell cli needs PowerShell 7 you need to install that first
1. Detects PowerShell 7 installed (installs if needed)
2. Runs via PowerShell 7
    1. Install PowerShell gallery
    2. Install / update `microsoft.winget.client` module
    3. Runs `Repair-WinGetPackageManager`