function Initialize-Log {
    # --- Prefer OneDrive\Desktop if available, otherwise use local Desktop ---

    $desktop = [Environment]::GetFolderPath("Desktop")
    $output = if ($env:OneDrive -and (Test-Path $env:OneDrive)) {
        Join-Path $env:OneDrive "Desktop\results.txt"
    } 
    else {
        Join-Path $desktop "results.txt"
    }

    New-Item -Path (Split-Path $output) -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

    return $output

}

$Global:LogFile = Initialize-Log
