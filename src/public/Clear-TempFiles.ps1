function Remove-TempFiles {
    $temp = 'C:\Windows\Temp\'
    Write-Verbose "Removing temporary files and folders in $temp..."

    $itemsremoved = 0
    $freedBytes = 0

    Get-ChildItem $temp -Force -ErrorAction SilentlyContinue | ForEach-Object {
        try {
            $itemSize = if ($_.PSIsContainer) { 
                (Get-ChildItem $_.FullName -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum 
            } else { $_.Length }

            Remove-Item $_.FullName -Recurse -Force -ErrorAction Stop
            $freedBytes += $itemSize
            $removedCount++
        } catch {
            # item could not be removed, skip
        }
    }

    $size = switch ($freedBytes) {
        {$_ -ge 1GB} { "{0:N2} GB" -f ($freedBytes/1GB); break }
        {$_ -ge 1MB} { "{0:N2} MB" -f ($freedBytes/1MB); break }
        {$_ -ge 1KB} { "{0:N2} KB" -f ($freedBytes/1KB); break }
        default { "$freedBytes bytes" }
    }

    Write-Output "SUCCESS: Removed $itemsremoved temporary files, freeing $size."

}
