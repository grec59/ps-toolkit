function Disable-Sleep {
    Write-Host "Disabling Sleep When Plugged In..." -ForegroundColor Cyan
    Start-Sleep 2
    powercfg /change standby-timeout-ac 0
    powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
    Write-Host "SUCCESS: Sleep and Lid Closure action when plugged in is disabled." -ForegroundColor Green
    "SUCCESS: Sleep and Lid Closure action when plugged in has been disabled." | Out-File -FilePath $output -Encoding utf8 -Append
    Start-Sleep 2
}
