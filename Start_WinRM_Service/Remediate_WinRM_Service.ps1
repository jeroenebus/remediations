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

$winrmservice = Get-Service -Name WinRM

if ($winrmservice.Status -eq "Stopped") {
    try {
        Set-Service -Name WinRM -StartupType Automatic
        Start-Service -Name WinRM
        Exit 0
    }  
    Catch {
        Write-error $_
        Exit 1
    }
}