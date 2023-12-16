<#
.Synopsis
    Detection script to detect if the WinRM Service is running
.DESCRIPTION
    This detection script is part of a remediation starting and setting the WinRM Service to automatic
.EXAMPLE
    Fill in the service with each other service that you want to start automatically
.NOTES
    Filename: Detect_WinRM_Service_Status.ps1
    Author: Jeroen Ebus (https://manage-the.cloud) 
    Modified date: 2023-12-16
    Version 1.0 - Release notes/details
#>

# Dection script! Based on https://github.com/JayRHa/EndpointAnalyticsRemediationScripts/blob/main/Change-Registry-Key-Generic/detect-regkey.ps1

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

##Enter the value of the registry key we are checking for, for example 0
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