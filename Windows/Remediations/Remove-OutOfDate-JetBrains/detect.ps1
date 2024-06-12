#Source: https://github.com/Eduserv/intune-scripts
Start-Transcript -Path "$Env:Programfiles\_MEM\Log\JetBrainsDetection.log" -Force -Append

if (!(Test-Path "C:\Program Files\PowerShell\7\pwsh.exe")) {
    Write-Output "Need PowerShell 7 - downloading"
    # GitHub API endpoint for PowerShell (7) releases
    $githubApiUrl = 'https://api.github.com/repos/PowerShell/PowerShell/releases/latest'

    # Fetch the latest release details
    $release = Invoke-RestMethod -Uri $githubApiUrl

    # Find asset with .msi in the name and x64 in the name
    $asset = $release.assets | Where-Object { $_.name -like "*msi*" -and $_.name -like "*x64*" }

    # Get the download URL and filename of the asset (assuming it's a MSI file)
    $downloadUrl = $asset.browser_download_url
    $filename = $asset.name

    # Download the latest release using .NET's System.Net.WebClient for faster download
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($downloadUrl, $filename)

    Write-Output "Installing PowerShell 7"
    # Install PowerShell 7
    Start-Process msiexec.exe -Wait -ArgumentList "/I $filename /qn"
}

# Start a new PowerShell 7 session
$pwshExecutable = "C:\Program Files\PowerShell\7\pwsh.exe"

# Run a script block in PowerShell 7
$exitcode = & $pwshExecutable -Command {

    Write-Output "Checking for Nuget Package Provider"
    # Check if NuGet provider is installed
    $provider = Get-PackageProvider NuGet -ErrorAction Ignore -Verbose
    if (-not $provider) {
        Write-Host "Installing provider NuGet"
        Find-PackageProvider -Name NuGet -ForceBootstrap -IncludeDependencies -Verbose
        Write-Output "Install NuGet Package Provider"
    }

    Write-Output "Installing Winget Client PowerShell"
    # Install or update the Microsoft WinGet client module
    Install-Module microsoft.winget.client -Force -AllowClobber -Verbose

    Write-Output "Importing Winget Client PowerShell"
    # Import the Microsoft WinGet client module
    Import-Module microsoft.winget.client

    Write-Output "Searching for JetBrains packages"
    $availpackages = Find-WinGetPackage "JetBrains"

    foreach ($package in $availpackages) {
        Write-Output "Finding versions of $($package.Id) that are installed that aren't the latest version"
        $installedPackages = Get-WingetPackage $package.Name
        if (($installedPackages | Where-Object IsUpdateAvailable -eq $true).Count -gt 0) {
            Write-Error "Multiple version of $($package.Name) found"
            Write-Output "Issue detected"
            Exit 1
        } else {
            Write-Output "Only $($installedPack.Count) version of $($package.Id)"
        }
    }
    Write-Output "No issue"
}

$exitcode

if ($exitcode -like "*Issue detected*") {
    Write-Error "Multiversions detected"
    Exit 1
} else {
    Write-Output "No issue"
    Exit 0
}

Stop-Transcript