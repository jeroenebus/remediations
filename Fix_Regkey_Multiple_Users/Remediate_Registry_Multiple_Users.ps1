<#
.Synopsis
    Remediation script to set a specific registry for all Azure AD users on the device
.DESCRIPTION
    This remediation script will set a specific registry key for all Azure AD users that have logged on to the device
    In this particular script the key that is set is the softwarecenter: key, this is needed to trust links to software center in Office applications
    https://learn.microsoft.com/en-US/microsoft-365/troubleshoot/administration/enable-disable-hyperlink-warning#how-to-enable-or-disable-hyperlink-warnings-per-protocol
.EXAMPLE
    It is possible to fix all kind of registry keys in the HKEY_USERS registry with this script, just replace the registry key/path
.NOTES
    Filename: Remediate_Registry_Multiple_Users.ps1
    Author: Jeroen Ebus (https://manage-the.cloud) 
    Modified date: 2023-05-31
    Version 1.0 - Release notes/details
#>

# Check if HKEY_USERS is loaded
If (!(Test-Path HKU:)) {
    New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
}
else { Write-Host "The HKU: drive is already in use." }

# Get SID of all Azure AD users (starting with S-1-12) that are on the device (excluding the classes)
$sidlist = get-item -path HKU:\S-1-12* -Exclude *Classes* | Select-Object PSChildName

Foreach ($sid in $sidlist) {
    $sid = $sid.PSChildName
    # Set regkey softwarecenter: for each SID in the SIDlist
    New-Item -Path "HKU:\$sid\Software\Policies\Microsoft\office\16.0\common\security" -Name "trusted protocols" -Force -ErrorAction Stop
    New-Item -Path "HKU:\$sid\Software\Policies\Microsoft\office\16.0\common\security\trusted protocols" -Name "all applications" -Force -ErrorAction Stop
    New-Item -Path "HKU:\$sid\Software\Policies\Microsoft\office\16.0\common\security\trusted protocols\all applications" -Name "softwarecenter:" -Force -ErrorAction Stop
}

# Disconnect the HKU registry
Remove-PSDrive HKU