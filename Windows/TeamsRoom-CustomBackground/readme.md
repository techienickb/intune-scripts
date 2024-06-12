# Teams Room Custom Background

Downloads 3 files from a blob storage location (or any url) and installs them into the Teams Room

## IntuneWin32 App
Edit [install.ps1](./install.ps1) entering your blob storage or other storage folder for your background, tablet and SkypeSettings file, the script will download these and install them

Download the IntuneWinAppUtil and package up using
```powershell
IntuneWinAppUtil.exe -c ./ -s ./install.ps1 -o ./ -q
```

Install command
```
%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1
```

Uninstall command
```
%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1
```

Check script is [check.ps1](./check.ps1)

## Remediation script

This script checks to see if there is an update to images to download, it has 2 files.

You will need to edit both [detect.ps1](./detect.ps1) and [remediate.ps1](./remediate.ps1) with the blob storage location of the files you want to download

Create a remediation script with both [detect.ps1](./detect.ps1) and [remediate.ps1](./remediate.ps1) and set to run after 5pm, before the maintainance window