<#
 .SYNOPSIS
  Removes dell junkware from devices
 .DESCRIPTION
  Removes dell junkware from devices
  Source: https://github.com/Eduserv/intune-scripts
  Adapted from: https://gist.github.com/tsfahmed2/5385b56e9a2d387ca61b355b90541084
 .EXAMPLE
  PS C:\> remediate.ps1
 .OUTPUTS
  0 Ok
  1 Error
#>
$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\DellJunkRemediation.log" -Force -Append

Write-Host "Removing Dell Command | Update for Windows 10"

Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/X{5669AB71-1302-4412-8DA1-CB69CD7B7324}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/X{4CCADC13-F3AE-454F-B724-33F6D4E52022}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/X{5669AB71-1302-4412-8DA1-CB69CD7B7324}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/X{41D2D254-D869-4CD8-B440-5DF49083C4BA}","/quiet" -Wait -WindowStyle Hidden -PassThru

Write-Host "Uninstall Dell Update"

Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{D8AE5F9D-647C-49B4-A666-1C20B44EC0E1}","/quiet" -Wait -WindowStyle Hidden -PassThru

Write-Host "Uninstall Dell Update for Windows 10"

Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/X{70E9F8CC-A23E-4C25-B292-C86C1821587C}","/quiet" -Wait -WindowStyle Hidden -PassThru

Write-Host "Uninstalling Dell Digital Delivery Services"

Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/X{CC5730C7-C867-43BD-94DA-00BB3836906F}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{66E2407E-9001-483E-B2AA-7AEF97567143}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/X{81C48559-E2EB-4F18-9854-51331B9DB552}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/X{3722784A-D530-4C82-BB78-4DF3E1A4CAD9}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{693A23FB-F28B-4F7A-A720-4C1263F97F43}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/X{560DFD4A-23E2-45DD-A223-A4B3FA356913}","/quiet" -Wait -WindowStyle Hidden -PassThru

Write-Host "Uninstalling Dell Optimizer Service..."

Start-Process -FilePath "${Env:ProgramFiles(x86)}\InstallShield Installation Information\{286A9ADE-A581-43E8-AA85-6F5D58C7DC88}\DellOptimizer.exe" -ArgumentList "-remove","-runfromtemp","-silent" -Wait -WindowStyle Hidden -PassThru

Write-Host "Uninstalling Dell Update - SupportAssist Update Plugin..."
Start-Process -FilePath "$Env:ProgramData\Package Cache\{819b927b-a8d8-46a9-9512-0326900f80e3}\DellUpdateSupportAssistPlugin.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{AADBB088-81DE-4EC8-B176-D98669BE09D4}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{31581d2d-a9e8-4f15-aa85-d6f9473b619e}\DellUpdateSupportAssistPlugin.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{EDE60887-F1EA-4304-A3E9-806D29EEE3FB}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{9aec637d-a647-4f3b-998e-425f40e7dd50}\DellUpdateSupportAssistPlugin.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{C559D0AB-2D9E-4B59-B2B8-0C2061B3F9BC}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{3a267e2b-0948-4f12-a103-e2ac0461179d}\DellUpdateSupportAssistPlugin.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{8B6D8EEE-9EE4-4FA3-9EC6-87BE5D130CB6}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{eb4d8dd7-ae4c-442d-8d21-8bfb73c03748}\DellUpdateSupportAssistPlugin.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru

Write-Host "Uninstalling Dell SupportAssist Remediation..."
Start-Process -FilePath "$Env:ProgramData\Package Cache\{3c7a4bc1-7c12-40a9-be55-a4a2c1b415bd}\DellSupportAssistRemediationServiceInstaller.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{8FA6BC9C-CF6A-45E7-92BD-1585DFAFB32C}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{5f9ca6e9-c7d9-49c9-88fa-196d35d8eb82}\DellSupportAssistRemediationServiceInstaller.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{2B2C47D2-F037-4C03-B599-07D7AFE8DD54}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{8ce1a5ae-856e-4b8e-a0e8-27dd7a209276}\DellSupportAssistRemediationServiceInstaller.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{1906C253-4035-4CA5-A501-075E691CCEC9}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{96846915-505c-49a2-8aa0-63f90927de87}\DellSupportAssistRemediationServiceInstaller.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{C4EF62FF-E6B9-4CE8-A514-1DDA49CB0C47}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{075ec656-5bd3-49b7-b0ee-07275a577c52}\DellSupportAssistRemediationServiceInstaller.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{795931D8-2EBF-4969-A678-4219B161F676}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{a0d5bbde-c013-48ba-b98a-ca0ff5cf36a6}\DellSupportAssistRemediationServiceInstaller.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{10B1BCF9-4996-4270-A12D-1B1BFEEF979C}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{61A1B864-0DAF-45A4-8184-5A0D347803B1}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{795931D8-2EBF-4969-A678-4219B161F676}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{555298fa-14a9-48f2-a7a0-9602f31785da}\DellSupportAssistRemediationServiceInstaller.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{6B991B44-B938-4902-BDF3-186CBDC62AD3}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{34685541-a19e-4537-97c9-082238790346}\DellSupportAssistRemediationServiceInstaller.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{E21419F5-2AA6-439C-B2C1-840083A05BC5}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{db72dcd5-bf99-4888-b104-cb605b82ec8a}\DellSupportAssistRemediationServiceInstaller.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{28C1FA1E-C3B3-4257-A3F2-059EEA260C64}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{0b3f567c-a2ee-437a-861f-bb6da9f2111b}\DellSupportAssistRemediationServiceInstaller.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru

Write-Host "Uninstalling Dell SupportAssist..."
Start-Process -FilePath "$Env:ProgramFiles\Dell\SupportAssistAgent\bin\SupportAssistUninstaller.exe" -ArgumentList "/S" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{555298fa-14a9-48f2-a7a0-9602f31785da}\DellSupportAssistRemediationServiceInstaller.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{ec40a028-983b-4213-af2c-77ed6f6fe1d5}\DellSupportAssistRemediationServiceInstaller.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru

Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/X{3A0ECCB6-1034-440E-8672-C4E14CCB7689}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/X{5106801D-CA18-4173-85B9-D74C33358F7F}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/X{9EF0AEB0-9AD2-40E6-8667-D7520C508941}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/X{71A59A4C-9348-4CA2-B98C-E422E14C9D31}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/X{E0659C89-D276-4B77-A5EC-A8F2F042E78F}","/quiet" -Wait -WindowStyle Hidden -PassThru

Write-Host "Uninstalling Dell SupportAssist OS Recovery Plugin for Dell Update..."

Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{900D0BCD-0B86-4DAA-B639-89BE70449569}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{e178914d-07c9-4d17-bd20-287c78ecc0f1}\DellUpdateSupportAssistPlugin.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{6DD27BB4-C350-414B-BC25-D33246605FB2}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{900D0BCD-0B86-4DAA-B639-89BE70449569}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{ec40a028-983b-4213-af2c-77ed6f6fe1d5}\DellUpdateSupportAssistPlugin.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/I{A713BCAE-ED3C-43BA-834A-8D1E8773FF2C}","/quiet" -Wait -WindowStyle Hidden -PassThru
Start-Process -FilePath "$Env:ProgramData\Package Cache\{b07a0d04-06d6-445c-ae24-7ae9991f11aa}\DellUpdateSupportAssistPlugin.exe" -ArgumentList "/uninstall","/quiet" -Wait -WindowStyle Hidden -PassThru

Write-Host "Uninstalling Dell Power Manager Service..."
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/X{18469ED8-8C36-4CF7-BD43-0FC9B1931AF8}","/quiet" -Wait -WindowStyle Hidden -PassThru

Write-Host "Uninstalling Dell Foundation Services..."
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/X{BDB50421-E961-42F3-B803-6DAC6F173834}","/quiet" -Wait -WindowStyle Hidden -PassThru

Write-Host "Uninstalled Dell Protected Workspace..."
Start-Process -FilePath "$Env:SystemRoot\System32\MsiExec.exe" -ArgumentList "/X{E2CAA395-66B3-4772-85E3-6134DBAB244E}","/quiet" -Wait -WindowStyle Hidden -PassThru

Stop-Transcript