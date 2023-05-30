<#
.Synopsis
    Remediation script to detect if the desired local admin is available on the device
.DESCRIPTION
    This is the remediation script for creating a local administrator
.EXAMPLE
    Creates a local administrator with a specific name and random password, this can be used with LAPS where the password will be set through a policy
.NOTES
    Filename: Remediate_Local_Admin.ps1
    Author: Jeroen Ebus (https://manage-the.cloud) 
    Modified date: 2023-05-25
    Version 1.0 - Release notes/details
#>

# Function created with the help of https://www.sharepointdiary.com/2020/04/powershell-generate-random-password.html

Function Get-RandomPassword {
    #define parameters
    param([int]$PasswordLength = 10)
 
    #ASCII Character set for Password
    $CharacterSet = @{
        Uppercase   = (97..122) | Get-Random -Count 10 | % { [char]$_ }
        Lowercase   = (65..90)  | Get-Random -Count 10 | % { [char]$_ }
        Numeric     = (48..57)  | Get-Random -Count 10 | % { [char]$_ }
        SpecialChar = (33..47) + (58..64) + (91..96) + (123..126) | Get-Random -Count 10 | % { [char]$_ }
    }
 
    #Frame Random Password from given character set
    $StringSet = $CharacterSet.Uppercase + $CharacterSet.Lowercase + $CharacterSet.Numeric + $CharacterSet.SpecialChar
 
    -join (Get-Random -Count $PasswordLength -InputObject $StringSet)
}

# Actual remediation! Based on https://cloudinfra.net/create-a-local-admin-using-intune-and-powershell/

$userName = "cloud-local-admin"
$userexist = (Get-LocalUser).Name -Contains $userName
$password = Get-RandomPassword | ConvertTo-SecureString -AsPlainText -Force

if ($userexist -eq $false) {
    try { 
        New-LocalUser -Name $username -Description "Local adminsitrator account managed through LAPS" -Password $password
        Exit 0
    }   
    Catch {
        Write-error $_
        Exit 1
    }
} 