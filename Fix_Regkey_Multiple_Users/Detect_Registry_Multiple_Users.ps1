<#
.Synopsis
    Detection script to detect if all the logged on Azure AD users on the device have a specific registry key
.DESCRIPTION
    This detection script is part of a remediation for setting a specific registry key for all Azure AD users that have logged on to the device
    In this particular script the key that is set is the softwarecenter: key, this is needed to trust links to software center in Office applications
    https://learn.microsoft.com/en-US/microsoft-365/troubleshoot/administration/enable-disable-hyperlink-warning#how-to-enable-or-disable-hyperlink-warnings-per-protocol
.EXAMPLE
    It is possible to check on all kind of registry keys in the HKEY_USERS registry with this script, just replace the registry key/path
.NOTES
    Filename: Detect_Registry_Multiple_Users.ps1
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
$sidlist = Get-Item -path HKU:\S-1-12* -Exclude *Classes* | Select-Object PSChildName

# Check for each SID in the SIDlist if the softwarecenter: regkey is available
Try {
    Foreach ($sid in $sidlist) {
        $sid = $sid.PSChildName
        if ($null -eq (Get-Item "HKU:\$sid\Software\Policies\Microsoft\office\16.0\common\security\trusted protocols\all applications\softwarecenter:" -ErrorAction SilentlyContinue)) {
            Write-Host "Regkey not found"
            Exit 1
        }
        Else {
            Write-Host "Regkey found"
            Exit 0
        }
    }
}

Finally {
    # Disconnect the HKU registry
    Remove-PSDrive HKU
}