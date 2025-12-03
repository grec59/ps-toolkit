function Create-User {
    # Prompt for username
    $username = Read-Host "Enter the new local username"
    if (-not $username) {
        Write-Output "No username entered. Exiting."
        return
    }

    # Prompt for password securely with confirmation
    do {
        $password1 = Read-Host "Enter password" -AsSecureString
        $password2 = Read-Host "Confirm password" -AsSecureString

        # Convert SecureStrings to plain text for comparison
        $first = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [Runtime.InteropServices.Marshal]::SecureStringToBSTR($password1)
        )
        $second = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [Runtime.InteropServices.Marshal]::SecureStringToBSTR($password2)
        )

        if ($first -eq $second) {
            $password = $password1
            break
        } else {
            Write-Output "Passwords do not match. Please try again."
        }
    } while ($true)

    # Create local user
    $params = @{
        Name                 = $username
        Password             = $password
        AccountNeverExpires  = $true
        PasswordNeverExpires = $true
    }

    try {
        New-LocalUser @params -ErrorAction Stop
        Write-Output "SUCCESS: Created new user: $username"
    } 
    catch {
        Write-Output "FAIL: Unable to create user: $($_.Exception.Message)"
    }
}
