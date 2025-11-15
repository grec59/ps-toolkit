function Remove-TempFiles {
    $temp = 'C:\Windows\Temp\'
    Write-Host "Removing temporary files..." -ForegroundColor Cyan
    $itemsremoved = (Get-ChildItem $temp | ForEach-Object { try { Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue; $_ } catch {} }).Count
    Write-Host "SUCCESS: Removed $itemsremoved temporary files from $temp" -ForegroundColor Green

}
