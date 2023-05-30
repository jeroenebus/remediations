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
    Modified date: 2023-05-30
    Version 1.0 - Release notes/details
#>

# Dection script! Based on https://cloudinfra.net/create-a-local-admin-using-intune-and-powershell/

$winrmservice = Get-Service -Name WinRM

if ($winrmservice.Status -eq "Running") {
    Write-Host "$winrmservice is running"
    Exit 0
}
Else {
    Write-Host "$winrmservice is stopped"
    Exit 1
}