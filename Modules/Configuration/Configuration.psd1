@{

RootModule = 'Configuration.psm1'

ModuleVersion = '1.0.0'

GUID = 'A6B6E0E7-6E36-4D97-9F59-000000000003'

Author = 'Eng. Hafeez Ur Rehman'

CompanyName = 'SNIPER Utilities Suite'

Copyright = '(c) 2026'

Description = 'Configuration Manager'

PowerShellVersion = '5.1'

FunctionsToExport = @(
    'Initialize-SNPConfiguration',
    'Get-SNPConfiguration',
    'Get-SNPConfigValue',
    'Show-SNPConfiguration'
)

CmdletsToExport = @()

VariablesToExport = @()

AliasesToExport = @()

}