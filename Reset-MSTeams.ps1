function Clear-MSTeams {
    # Stop Microsoft Teams processes
    Write-Host "Stopping Microsoft Teams processes..." -ForegroundColor Cyan
    Get-Process *teams* -ErrorAction SilentlyContinue | Stop-Process -Force

    # Prompt user to select profile(s)
    $users = Get-ChildItem C:\Users | Out-GridView -PassThru

    foreach ($user in $users) {
        $teamsCachePath = Join-Path -Path $user.FullName -ChildPath "AppData\Local\Packages\MSTeams_8wekyb3d8bbwe"

        if (Test-Path $teamsCachePath) {
            Remove-Item -Path $teamsCachePath -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "Cleared Teams cache for: $($user.Name)" -ForegroundColor Green
        } else {
            Write-Host "Teams cache not found for: $($user.Name)" -ForegroundColor Yellow
        }

        Start-Sleep -Seconds 2
    }

    # Download the Microsoft Teams offline installer
    $installerUrl = "https://go.microsoft.com/fwlink/?linkid=2196106"
    $installerPath = "$env:TEMP\MSTeams-x64.msix"

    Write-Host "Downloading Microsoft Teams installer..." -ForegroundColor Cyan

    try {
        Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing
        Write-Host "Download completed: $installerPath" -ForegroundColor Green
    } catch {
        Write-Host "Error downloading installer: $_" -ForegroundColor Red
        return
    }

    # Launch the installer
    Write-Host "Launching installer..." -ForegroundColor Cyan
    Start-Process -FilePath $installerPath

    Write-Host "Microsoft Teams repair complete." -ForegroundColor Green
}
