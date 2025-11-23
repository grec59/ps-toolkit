<#
.DESCRIPTION
  This script executes administrative tasks on a Windows system, including:
    - Update Group Policy
    - Configuration Manager tasks
    - Install Dell system updates
    - Create a local user account
    - Disable sleep on AC
    - Remove temporary files

.NOTES
    - Requires administrative privileges.
    - Designed for interactive use with GUI-based action selection.    
    - Outputs log to C:\results.txt
    - Not compatible with command-line execution (PS-Remoting, PsExec)

.EXAMPLE
  .\Prepare-Image.ps1 
#>

# --- Begin Script Logic ---

Clear-Host

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# --- Check for elevated user session, elevate if needed and restart script execution ---

$pspath = (Get-Process -Id $PID).Path

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process $pspath -Verb runAs -ArgumentList '-NoExit', '-ExecutionPolicy RemoteSigned', '-Command', "& {Invoke-WebRequest 'https://agho.me/provision' -UseBasicParsing | Invoke-Expression}"
    Stop-Process -Id $PID
}

$output = Initialize-Log

$computer = $env:COMPUTERNAME
$cpu = (Get-CimInstance Win32_Processor | Select-Object -First 1).Name
$ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
$bootVolume = [math]::Round((Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'").FreeSpace / 1GB, 2)

$messageHeader = @"

 ==========================================
 Welcome to the Quick Utilities Script v1.0
 ==========================================

"@

$messageDetails = @"
 System Summary:

 Computer Name: $computer
 CPU: $cpu
 Memory: $ram GB
 Boot Volume Free Space: $bootVolume GB

"@

$messageTasks = @"
 Actions Available:

 - Update Group Policy
 - Configuration Manager tasks
 - Install Dell system updates
 - Create a local user account
 - Disable sleep on AC
 - Remove temporary files

"@

$date = Get-Date
" Execution Date & Time: $date" | Out-File -FilePath $output -Encoding utf8

Write-Host $messageHeader -ForegroundColor Cyan
$messageHeader | Out-File -FilePath $output -Encoding utf8 -Append
Write-Host $messageDetails
$messageDetails | Out-File -FilePath $output -Encoding utf8 -Append
Write-Host $messageTasks
"Task Execution Logs:" | Out-File -FilePath $output -Encoding utf8 -Append
" " | out-File -FilePath $output -Encoding utf8 -Append

# --- Retrieve user input and launch selection window upon confirmation ---

while (($i = Read-Host " Press Y to continue or N to quit") -notmatch '^[YyNn]$') {}
if ($i -notmatch '^[Yy]$') { exit }

# --- Execute Tasks ---



" " | Out-File -FilePath $output -Encoding utf8 -Append
"Script execution complete." | Out-File -FilePath $output -Encoding utf8 -Append
Write-Host "Script execution complete. See:"
Write-Host "$output" -Foregroundcolor Gray

Start-Sleep 1
