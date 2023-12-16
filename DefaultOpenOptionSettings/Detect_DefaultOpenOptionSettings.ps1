<#
.Synopsis
    Detection script to detect if the DefaultOpenOptionSettings are set to "Desktop"
.DESCRIPTION
    This detection script is part of a remediation that sets the DefaultOpenOptionSettings behaviour in Outlook to "Desktop"
.EXAMPLE
    You can use this script to detect the value of any other registry value
.NOTES
    Filename: Detect_DefaultOpenOptionSettings.ps1
    Author: Jeroen Ebus (https://manage-the.cloud) 
    Modified date: 2023-12-16
    Version 1.0 - Release notes/details
#>

# Dection script! Based on https://github.com/JayRHa/EndpointAnalyticsRemediationScripts/blob/main/Change-Registry-Key-Generic/detect-regkey.ps1
# Credits for running Powershell always in 64-bit context: https://call4cloud.nl/2021/05/the-sysnative-witch-project/

If ($ENV:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
    Try {
        &"$ENV:WINDIR\SysNative\WindowsPowershell\v1.0\PowerShell.exe" -File $PSCOMMANDPATH
    }
    Catch {
        Throw "Failed to start $PSCOMMANDPATH"
    }
    Exit
}

## Enter the path to the registry key for example HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
$regpath = "HKCU:\Software\Microsoft\Office\16.0\Common\FLORA\All"

## Enter the name of the registry key for example EnableLUA
$regname = "DefaultOpenOptionSettings"

## Enter the value of the registry key we are checking for, for example 0
$regvalue = "3"

Try {
    $Registry = Get-ItemProperty -Path $regpath -Name $regname -ErrorAction Stop | Select-Object -ExpandProperty $regname
    If ($Registry -eq $regvalue) {
        Write-Output "Compliant"
        Exit 0
    } 
    Write-Warning "Not Compliant"
    Exit 1
} 
Catch {
    Write-Warning "Not Compliant"
    Exit 1
}