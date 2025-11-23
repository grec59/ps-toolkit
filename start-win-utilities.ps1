function Start-WinUtilities {
    <#
    .SYNOPSIS
        Interactive administrative toolkit
    .DESCRIPTION
        Allows the user to select one or more admin actions.
    .EXAMPLE
        Start-WinUtilities
    #>

    Clear-Host

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # --- Elevation check ---
    $pspath = (Get-Process -Id $PID).Path

    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
        ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

        Start-Process $pspath -Verb runAs -ArgumentList '-NoExit', '-ExecutionPolicy RemoteSigned', '-Command', "& {Start-WinUtilities}"
        exit
    }

    # Initialize log (your module function)
    $output = Initialize-Log  

    # ---- System Info ----
    $computer   = $env:COMPUTERNAME
    $cpu        = (Get-CimInstance Win32_Processor | Select-Object -First 1).Name
    $ram        = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
    $bootVolume = [math]::Round((Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'").FreeSpace / 1GB, 2)

    Write-Host @"
 ==========================================
 Quick Utilities Toolkit v1.0
 ==========================================
"@ -ForegroundColor Cyan

    Write-Host " Computer: $computer"
    Write-Host " CPU: $cpu"
    Write-Host " RAM: $ram GB"
    Write-Host " C: Drive Free Space: $bootVolume GB"
    Write-Host ""

    # ---- Action List (Edit this area to add/remove tasks) ----
    $Actions = @{
        1 = @{ Name = "Update Group Policy";              Function = "Update-ComputerPolicy" }
        2 = @{ Name = "SCCM Client Actions";              Function = "Invoke-ClientActions" }
        3 = @{ Name = "Install Dell Updates";             Function = "Install-DellUpdates" }
        4 = @{ Name = "Create Local User";                Function = "Create-NewUser" }
        5 = @{ Name = "Disable Sleep";                    Function = "Disable-SystemSleep" }
        6 = @{ Name = "Clear Temporary Files";            Function = "Clear-TemporaryFiles" }
        7 = @{ Name = "Reset Microsoft Teams";            Function = "Reset-MSTeams" }
        8 = @{ Name = "Add Hosts Entry";                  Function = "Add-HostsEntry" }
    }

    Write-Host " Actions Available:`n"
    foreach ($key in $Actions.Keys | Sort-Object) {
        Write-Host " [$key] $($Actions[$key].Name)"
    }
    Write-Host ""

    # Ask user for selections
    $selection = Read-Host "Enter one or more numbers separated by commas (e.g. 1,3,5)"

    if (-not $selection) {
        Write-Warning "No selection made. Exiting."
        return
    }

    # Convert "1,3,5" → array of integers
    $selectedActions = $selection -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' }

    if (-not $selectedActions) {
        Write-Warning "Invalid selection. Exiting."
        return
    }

    Write-Host "`nStarting selected tasks...`n"

    # ---- Run Selected Functions ----
    foreach ($choice in $selectedActions) {
        if ($Actions.ContainsKey([int]$choice)) {

            $task = $Actions[[int]$choice]
            $func = $task.Function

            Write-Host "▶ Running: $($task.Name) ($func)" -ForegroundColor Cyan

            try {
                & $func | Out-File -FilePath $output -Append -Encoding utf8
                Write-Host "✓ Completed: $($task.Name)" -ForegroundColor Green
            }
            catch {
                Write-Host "✗ Failed: $($task.Name)" -ForegroundColor Red
                $_ | Out-File -FilePath $output -Append
            }

            Write-Host ""
        }
        else {
            Write-Warning "Unknown option: $choice"
        }
    }

    Write-Host "`nAll selected actions completed."
    Write-Host "Log saved to: $output" -ForegroundColor Gray
}
