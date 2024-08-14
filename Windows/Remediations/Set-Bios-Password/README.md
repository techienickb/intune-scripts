# Bios Password Setting

This is a remediation script to detect on Dell/HP/Lenovo devices if the BIOS password has been set.

If no password has been set a random password is generated, applied and the password is stored in an Azure KeyVault.

To use this script you will need to:
1. Create an Azure Key Vault
2. Create an Application Registration for accessing the Key Vault
3. Create a certificate to authenticate to the App Registration, this can be one via Key Vault -> Certificates
4. Add this to the client secrets/certificate section of the app registration
5. Allow List and Create secrets on the Key Vault
6. In Windows Powershell get the base64 copy of the PFX file
```powershell
[convert]::ToBase64String((Get-Content -path xxx.pfx -Encoding byte)) | Set-Clipboard
```
7. Edit [install-bioscreds-cert.ps1](./install-bioscreds-cert.ps1) and put the clipboard contents from #4 into the $b64 variable
8. Upload this to intune as a Windows Script to deploy the cert to the devices. <br />You will need to update this script with a new cert when it expires
9. Edit [Remediation.ps1](./Remediation.ps1) and set the required parameters
```powershell
[guid]$TenantID=""
[guid]$AppID=""
[string]$Thumbprint=""
[string]$VaultName=""
```
10. Create a [Proactive Remediation](https://intune.microsoft.com/#view/Microsoft_Intune_Enrollment/UXAnalyticsMenu/~/proactiveRemediations) script package with the [Detection.ps1](./Detection.ps1) and [Remediation.ps1](./Remediation.ps1) scripts.



> Adapted from [https://github.com/damienvanrobaeys/Intune-Proactive-Remediation-scripts/tree/main/Set%20BIOS%20password](https://github.com/damienvanrobaeys/Intune-Proactive-Remediation-scripts/tree/main/Set%20BIOS%20password)