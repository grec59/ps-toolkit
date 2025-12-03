function Invoke-GroupPolicy {
    try {
        Write-Output "Running Policy Update..."
        gpupdate /target:computer | Out-Null
        Start-Sleep -Seconds 5
        Write-Output "SUCCESS: Computer Policy update has completed."
    }
    catch {
        Write-Output "FAIL: Failed to update Computer Policy. Check Event Viewer for details."
        Write-Output "ERROR: $($_.Exception.Message)"
    }
}
