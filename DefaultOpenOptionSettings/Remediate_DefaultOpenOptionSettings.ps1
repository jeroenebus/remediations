<#
.Synopsis
    Remediation script to set the DefaultOpenOptionSettings to "Desktop"
.DESCRIPTION
    This remediation script will set the DefaultOpenOptionSettings to "Desktop"
.EXAMPLE
    You can use this script to remediate the value of any other registry value
.NOTES
    Filename: Remediate_DefaultOpenOptionSettings.ps1
    Author: Jeroen Ebus (https://manage-the.cloud) 
    Modified date: 2023-12-16
    Version 1.0 - Release notes/details
#>

# Remediation script! Based on https://github.com/JayRHa/EndpointAnalyticsRemediationScripts/blob/main/Change-Registry-Key-Generic/remediate-regkey.ps1
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

## Enter the value of the registry key for example 0
$regvalue = "3"

## Enter the type of the registry key for example DWord
$regtype = "DWord"

New-Item -Path $regpath -Force
New-ItemProperty -LiteralPath $regpath -Name $regname -Value $regvalue -PropertyType $regtype -Force