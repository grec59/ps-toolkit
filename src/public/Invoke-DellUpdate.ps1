function Run-DellUpdates {
    $dcu = 'C:\Program Files\Dell\CommandUpdate\dcu-cli.exe'
    $log = 'C:\results.txt'

    if (-not (Test-Path $dcu)) { Write-Output "WARN: Dell CLI not found. Skipping."; return }

    Write-Output "Running Dell Updates..."
    Remove-Item $log -ErrorAction SilentlyContinue

    & $dcu /applyUpdates -autoSuspendBitLocker=enable -forceUpdate=enable 2>&1 |
        ForEach-Object { "$([datetime]::Now) $_" | Tee-Object -FilePath $log -Append -Encoding UTF8 }

    Write-Output "Updates completed. Log saved to $log"
}
