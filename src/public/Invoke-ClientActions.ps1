function Execute-Actions {
    Add-Type -AssemblyName PresentationFramework

    # --- Create Configuration Manager client actions as PSCustomObjects ---

    $actionsList = @(
        [PSCustomObject]@{ Name = "Machine policy retrieval cycle"; Guid = "{00000000-0000-0000-0000-000000000021}"; IsChecked = $false },
        [PSCustomObject]@{ Name = "Machine policy evaluation cycle"; Guid = "{00000000-0000-0000-0000-000000000022}"; IsChecked = $false },
        [PSCustomObject]@{ Name = "Hardware inventory cycle"; Guid = "{00000000-0000-0000-0000-000000000001}"; IsChecked = $false },
        [PSCustomObject]@{ Name = "Software inventory cycle"; Guid = "{00000000-0000-0000-0000-000000000002}"; IsChecked = $false },
        [PSCustomObject]@{ Name = "Discovery data collection cycle"; Guid = "{00000000-0000-0000-0000-000000000003}"; IsChecked = $false },
        [PSCustomObject]@{ Name = "Software updates scan cycle"; Guid = "{00000000-0000-0000-0000-000000000113}"; IsChecked = $false },
        [PSCustomObject]@{ Name = "Software updates deployment evaluation cycle"; Guid = "{00000000-0000-0000-0000-000000000114}"; IsChecked = $false },
        [PSCustomObject]@{ Name = "Software metering usage report cycle"; Guid = "{00000000-0000-0000-0000-000000000031}"; IsChecked = $false },
        [PSCustomObject]@{ Name = "Application deployment evaluation cycle"; Guid = "{00000000-0000-0000-0000-000000000121}"; IsChecked = $false },
        [PSCustomObject]@{ Name = "Windows installer source list update cycle"; Guid = "{00000000-0000-0000-0000-000000000032}"; IsChecked = $false },
        [PSCustomObject]@{ Name = "File collection"; Guid = "{00000000-0000-0000-0000-000000000010}"; IsChecked = $false }
    )


    foreach ($action in $chosen) {
        try {
            Invoke-WmiMethod -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule -ArgumentList $action.Guid -ErrorAction Stop | Out-Null
            Write-Host "SUCCESS: $($action.Name)" -ForegroundColor Green
            "SUCCESS: $($action.Name)" | Out-File -FilePath $output -Encoding utf8 -Append
        } 
        
        catch {
            Write-Host "FAIL: $($action.Name) $($_.Exception.Message)" -ForegroundColor Red
            "FAIL: $($action.Name) $($_.Exception.Message)" | Out-File -FilePath $output -Encoding utf8 -Append
        }
        Start-Sleep -Seconds 2
    }
}
