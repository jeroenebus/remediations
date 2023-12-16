<#
.Synopsis
    Remediation script to start the WinRM service
.DESCRIPTION
    This remediation script will start the WinRM service and sets the running startup type to automatic
.EXAMPLE
    Fill in the service with each other service that you want to start automatically
.NOTES
    Filename: Remediate_WinRM_Service.ps1
    Author: Jeroen Ebus (https://manage-the.cloud) 
    Modified date: 2023-05-30
    Version 1.0 - Release notes/details
#>

# Remediation script! Based on https://github.com/JayRHa/EndpointAnalyticsRemediationScripts/blob/main/Change-Registry-Key-Generic/remediate-regkey.ps1

If ($ENV:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
    Try {
        &"$ENV:WINDIR\SysNative\WindowsPowershell\v1.0\PowerShell.exe" -File $PSCOMMANDPATH
    }
    Catch {
        Throw "Failed to start $PSCOMMANDPATH"
    }
    Exit
}

##Enter the path to the registry key for example HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
$regpath = "HKCU:\Software\Microsoft\Office\16.0\Common\FLORA\All"

##Enter the name of the registry key for example EnableLUA
$regname = "DefaultOpenOptionSettings"

##Enter the value of the registry key for example 0
$regvalue = "3"

##Enter the type of the registry key for example DWord
$regtype = "DWord"

New-Item -Path $regpath -Force
New-ItemProperty -LiteralPath $regpath -Name $regname -Value $regvalue -PropertyType $regtype -Force