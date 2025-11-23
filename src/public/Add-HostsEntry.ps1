function Update-HostsFile {
    $hostname = Read-Host "Enter the hostname"
    $ip = Read-Host "Enter the IP address"
    $hosts = "$env:SystemRoot\System32\drivers\etc\hosts"
    $entry = "`n$ip`t$hostname"
    # Backup the original hosts file
    Copy-Item $hosts "$hosts.bak" -Force
    Add-Content -Path $hosts -Value $entry
    Write-Output "Entry added: $ip $hostname"
}
