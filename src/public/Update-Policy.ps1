function Invoke-GroupPolicy {
    try {
        Write-Host "Running Policy Update..." -ForegroundColor Cyan
        gpupdate /target:computer | out-null
        Start-Sleep -Seconds 5
        Write-Host "SUCCESS: Computer Policy update has completed." -ForegroundColor Green
        "SUCCESS: Computer Policy update completed. Check Event Viewer for details." | Out-File -FilePath $output -Encoding utf8 -Append
    }

    catch {
        Write-Host "FAIL: Failed to update Computer Policy. Check Event Viewer for details." -ForegroundColor Yellow
        "FAIL: Unable to update Computer Policy." | Out-File -FilePath $output -Encoding utf8 -Append
        $($_.Exception.Message) | Out-File -FilePath $output -Encoding utf8 -Append
    }
}
