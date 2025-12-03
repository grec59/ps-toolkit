function Update-HostsFile {
    [CmdletBinding()] param(
        [Parameter(Mandatory)]
        [ValidatePattern('^(?:\d{1,3}\.){3}\d{1,3}$')] $IPAddress,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()] $Hostname
    )

    $hosts = "$env:SystemRoot\System32\drivers\etc\hosts"
    $backup = "$hosts.$((Get-Date -f yyyyMMddHHmmss)).bak"

    Copy-Item $hosts $backup -Force

    $entry = "$IPAddress`t$Hostname"
    if (-not (Select-String $hosts -Pattern "^\s*$IPAddress\s+$Hostname\s*$" -SimpleMatch)) {
        Add-Content $hosts $entry
        "Added: $entry"
    }
    else {
        "Already exists: $entry"
    }
}

