function Disable-Sleep {
    powercfg /change standby-timeout-ac 0
    powercfg -setacvalueindex SCHEME_CURRENT `
        4f971e89-eebd-4455-a8de-9e59040e7347 `
        5ca83367-6e45-459f-a27b-476b1d01c936 0

    Write-Output "SUCCESS: Sleep and Lid Closure action when plugged has been disabled."
}
