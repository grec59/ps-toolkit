@{
    RootModule        = 'win-utilities.psm1'
    ModuleVersion     = '1.0.0'
    CompatiblePSEditions = @('Desktop','Core')
    Author            = 'Austin Greco'
    Description       = 'Windows administration utilities.'
    
    FunctionsToExport = '*'

    PrivateData = @{
        PSData = @{
            Tags       = @('Windows','Administration','Utility','Toolkit')
            ProjectUri = 'https://github.com/grec59/win-utilities'
        }
    }
}
