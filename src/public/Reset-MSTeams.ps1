function Clear-MSTeams {
    param(
        [string]$InstallerUrl = "https://go.microsoft.com/fwlink/?linkid=2196106",
        # [string]$bootstrap = "https://go.microsoft.com/fwlink/?linkid=2243204&clcid=0x409",
        [string]$InstallerPath = "$env:TEMP\MSTeams-x64.msix"
    )

    # Stop Teams processes
    Write-Output "Stopping Microsoft Teams processes..."
    Get-Process *teams* -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

    # Clear Teams cache
    Get-ChildItem C:\Users -Directory | ForEach-Object {
        $userProfile = $_.FullName
        $paths = @(
            Join-Path $userProfile "AppData\Local\Packages\MSTeams_8wekyb3d8bbwe"
            Join-Path $userProfile "AppData\Roaming\Microsoft\Teams"
        )

        foreach ($path in $paths) {
            if (Test-Path $path) {
                Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
                Write-Output "Cleared Teams cache for $($_.Name) at $path"
            }
        }
    }

    # Download Microsoft Teams installer using BITS
    Write-Output "Starting Microsoft Teams installer download..."
    if (Test-Path $InstallerPath) { Remove-Item $InstallerPath -Force }

    $job = Start-BitsTransfer -Source $InstallerUrl -Destination $InstallerPath -Asynchronous

    # Monitor progress
    do {
        if ($job.BytesTotal -gt 0) {
        $progress = ($job.BytesTransferred / $job.BytesTotal) * 100
        Write-Output ("Download progress: {0:N1}%" -f $progress)
        }
        Start-Sleep -Seconds 1
    } while ($job.JobState -eq "Transferring")

    Complete-BitsTransfer -BitsJob $job

    if (-not (Test-Path $InstallerPath)) {
        Write-Output "ERROR: Installer download failed, cannot proceed."
        return
    }

    Write-Output "Download completed: $InstallerPath"

    # Automate MSIX installation
    try {
        Write-Output "Installing Microsoft Teams silently..."
        Add-AppxPackage -Path $InstallerPath -ForceApplicationShutdown -ErrorAction Stop
        # .\teamsbootstrapper.exe -p -o $InstallerPath
        Write-Output "Microsoft Teams installation complete."
    } catch {
        Write-Output "ERROR: Installation failed: $_"
    }
}
