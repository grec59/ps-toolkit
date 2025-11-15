function Run-DellUpdates {
    Write-Host "Running System Updates..." -ForegroundColor Cyan
    $path = 'C:\Program Files\Dell\CommandUpdate\dcu-cli.exe'
    if (Test-Path $path) {
        Start-Sleep -Seconds 2
        "Dell Command CLI application detected, starting updates..." | Out-File -FilePath $output -Encoding utf8 -Append
        & "$path" /applyUpdates -autoSuspendBitLocker=enable -forceupdate=enable -outputLog='C:\command.log'
    } 
    
    else {
        Write-Host "WARN: Dell Command application not detected, skipping updates."  -ForegroundColor Yellow
         "WARN: Dell Command CLI application not detected, skipping updates." | Out-File -FilePath $output -Encoding utf8 -Append
    }
}
