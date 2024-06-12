$CurrentDevices = [Collections.Generic.HashSet[string]]::new([string[]]@((Get-PnpDevice -PresentOnly).DeviceID), [StringComparer]::OrdinalIgnoreCase)
$NewDevices = [Collections.Generic.HashSet[string]]::new([string[]]@((Get-PnpDevice -PresentOnly).DeviceID), [StringComparer]::OrdinalIgnoreCase)
$NewDevices.ExceptWith($CurrentDevices)
$NewDevices = $CurrentDevices
    
function Get-DeviceProperties {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [string]
        $DeviceID,

        [hashtable]
        $Properties = @{
            'DEVPKEY_NAME'                         = 'Name'
            'DEVPKEY_Device_BusReportedDeviceDesc' = 'NameFromBus'
            'DEVPKEY_Device_Service'               = 'Service'
            'DEVPKEY_Device_Class'                 = 'PNPClass'
            'DEVPKEY_Device_Parent'                = 'ParentID'
        }
    )
    process {
        $Instance = [Management.ManagementObject]::new('Win32_PnPEntity.DeviceID="{0}"' -f $DeviceID.Replace('\', '\\'))
        $params = $Instance.GetMethodParameters('GetDeviceProperties')
        $params['devicePropertyKeys'] = [string[]]$Properties.Keys
        $result = $Instance.InvokeMethod('GetDeviceProperties', $params, $null)
        $objHash = [ordered]@{
            DeviceID = $DeviceID
        }
        foreach ($property in $result['deviceProperties']) {
            $name = $property['KeyName']
            if ([string]::IsNullOrEmpty($name)) {
                $name = $property['key']
            }
            $objHash[$Properties[$name]] = $property['Data']
        }
        [PSCustomObject]$objHash
    }
}

$Devices = $NewDevices | Get-DeviceProperties

Write-Host "Found $($Devices.Where({ $_.PNPClass -eq 'Monitor' -and $_.DeviceID -and $_.NameFromBus -notlike 'Integrated*' }).Count) Monitors"

$MonitorDevices = foreach ($Device in $Devices | Where-Object { $_.PNPClass -eq 'Monitor' -and $_.DeviceID -and $_.NameFromBus -notlike 'Integrated*' }) {    
    $scope = [Management.ManagementScope]::new('root/WMI')
    $scope.Connect()
    $QueryString = 'SELECT InstanceName,ProductCodeID,ManufacturerName,SerialNumberID,UserFriendlyName FROM WmiMonitorID WHERE Active = TRUE AND InstanceName LIKE ''{0}%''' -f $Device.DeviceID.Replace('\', '\\')
    $query = [Management.ObjectQuery]::new('WQL', $QueryString)
    $searcher = [Management.ManagementObjectSearcher]::new($scope, $query)
    $WmiMonitorID = try { $searcher.Get() | Select-Object -First 1 } catch {}
    if (!$WmiMonitorID) {
        Write-Host "Wmi Id Missing"
        continue
    }
    $QueryString = 'SELECT VideoOutputTechnology FROM WmiMonitorConnectionParams WHERE InstanceName LIKE ''{0}%''' -f $WmiMonitorID['InstanceName'].Replace('\', '\\')
    $query = [Management.ObjectQuery]::new('WQL', $QueryString)
    $searcher = [Management.ManagementObjectSearcher]::new($scope, $query)
    $GoodOutputType = try { $searcher.Get() | Where-Object { $_['VideoOutputTechnology'] -notin @(6, 11, 13, 0x80000000) } } catch {}

    if (!$GoodOutputType -or $GoodOutputType.Count -eq 0) {
        Write-Host "Not good output type"
        continue
    }

    $DevicePID = [Convert]::ToUInt32([Text.Encoding]::ASCII.GetString($WmiMonitorID['ProductCodeID'], 0, 4), 16)
    $DeviceVID = ($WmiMonitorID['ManufacturerName'][0] - 64 -shl 10) -bor ($WmiMonitorID['ManufacturerName'][1] - 64 -shl 5) -bor ($WmiMonitorID['ManufacturerName'][2] - 64)
    $DeviceSerialNumber = [Text.Encoding]::ASCII.GetString($WmiMonitorID['SerialNumberID']).TrimEnd([char]0)
    $DeviceName = [Text.Encoding]::ASCII.GetString($WmiMonitorID['UserFriendlyName']).TrimEnd([char]0)

    [PSCustomObject][ordered]@{
        'Product ID'      = "$DevicePID"
        'Vendor ID'       = "$DeviceVID"
        'Serial Number'   = "$DeviceSerialNumber"
        'Peripheral Name' = "$DeviceName"
        'Peripheral Type' = 'Screen'
    }
}

$UPN = $null
$DisplayName = $null
$GroupID = $null
while (!$UPN) {
    $UPN = Read-Host "Enter the BYOD Room Account's User Principal Name (UPN)"
}
$DisplayName = Read-Host "Enter the BYOD Room Account's Display Name (default: none)"
$GroupID = Read-Host "Enter the Grouping ID to use for this data collection (default: none)"

$DataToExport = $MonitorDevices | Select-Object @{
    Name = 'Account'; Expression = { $UPN }
}, @{
    Name = 'Display Name'; Expression = { $DisplayName }
}, *, @{
    Name = 'GROUP_ID'; Expression = { $GroupID }
} | Where-Object {
    $_.'Peripheral Type' -notin @('Unknown', 'Camera')
}
$DefaultFilePath = [Environment]::GetFolderPath('Desktop')
$OutputFilePath = Read-Host "Enter the folder path where the PERIPHERALS.csv file will be saved (default: $DefaultFilePath)"
if (!$OutputFilePath) {
    $OutputFilePath = $DefaultFilePath
}
$OutputFilePath = [IO.Path]::Combine($OutputFilePath, 'PERIPHERALS.csv')

if ((Test-Path $OutputFilePath)) {
    while ($true) {
        try {
            $CurrentContents = Import-Csv -Path $OutputFilePath -ErrorAction Stop
            break
        }
        catch [IO.IOException] {
            if (!(Test-Path $OutputFilePath)) {
                $CurrentContents = @()
                break
            }
            Write-Warning "The file $OutputFilePath is currently in use. Please close the file and press Enter to retry."
            $null = Read-Host
        }
    }

    $DataToExport = @($DataToExport) + @($CurrentContents) | 
    Sort-Object -Property 'Product ID', 'Vendor ID', 'Serial Number', 'Peripheral Name', 'Peripheral Type', GROUP_ID -Unique
}

# Update the CSV file
while ($true) {
    try {
        $DataToExport | Export-Csv -Path $OutputFilePath -NoTypeInformation -ErrorAction Stop
        break
    }
    catch [IO.IOException] {
        Write-Warning "The file $OutputFilePath is currently in use. Please close the file and press Enter to retry."
        $null = Read-Host
    }
}

Write-Host "Your discovered peripheral data has been collected and exported to $OutputFilePath." -ForegroundColor Green
Write-Host "Here is a preview of the results that were exported:"
$DataToExport | Format-Table -AutoSize