function Run-DellUpdates {
    [CmdletBinding()]
    param(
        [ValidateSet('Firmware','All')]
        [string]$UpdateType = 'All'
    )

    $dcu = 'C:\Program Files\Dell\CommandUpdate\dcu-cli.exe'
    if (-not (Test-Path $dcu)) {
        Write-Output "WARN: Dell CLI not found at $dcu. Skipping."
        return
    }

    $logDir = 'C:\ProgramData\Logs\DellCommandUpdate'
    $null = New-Item -Path $logDir -ItemType Directory -Force
    $log = Join-Path $logDir ("DCU_{0:yyyyMMdd_HHmmss}.log" -f (Get-Date))

    switch ($UpdateType) {
        'Firmware' {
            Write-Output "Running firmware-only updates..."
            $params = "/applyUpdates -autoSuspendBitLocker=enable -forceUpdate=enable -updateType=bios,firmware"
        }
        'All' {
            Write-Output "Running all updates..."
            $params = "/applyUpdates -autoSuspendBitLocker=enable -forceUpdate=enable"
        }
    }

    try {
        & $dcu $params 2>&1 |
            ForEach-Object {
                "$([datetime]::Now) $_" |
                    Tee-Object -FilePath $log -Append -Encoding UTF8
            }

        Write-Output "DCU exit code: $LASTEXITCODE"
        Write-Output "Updates completed. Log: $log"
    }
    catch {
        Write-Output "ERROR running Dell Command Update: $($_.Exception.Message)"
    }
}
