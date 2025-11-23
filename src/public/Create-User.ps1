function Create-User {
    param(
        [PSCredential]$Credential
    )

    Write-Host "Creating Local User Account..." -ForegroundColor Cyan

    if (-not $Credential) {
        $Credential = Get-Credential -Message "Enter credentials for the new local user:"
        if (-not $Credential) { return }
    }

    $username = $Credential.UserName
    $password = $Credential.Password

    $params = @{
        Name                     = $username
        Password                 = $password
        AccountNeverExpires      = $true
        PasswordNeverExpires     = $true
    }

    try {
        New-LocalUser @params -ErrorAction Stop | Out-Null
        Write-Host "SUCCESS: Created new user: $username" -ForegroundColor Green
        "SUCCESS: Created new local user account: $username" | Out-File -FilePath $output -Encoding utf8 -Append
    } 
    
    catch {
        Write-Host "FAIL: Unable to create user: $($_.Exception.Message)" -ForegroundColor Red
        "FAIL: Unable to create local user account: $($_.Exception.Message)" | Out-File -FilePath $output -Encoding utf8 -Append
    }
}
