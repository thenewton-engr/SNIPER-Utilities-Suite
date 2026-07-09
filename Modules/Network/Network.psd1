@{

RootModule = 'Network.psm1'

ModuleVersion = '1.0.0'

GUID = 'C56E2C8D-7D2B-4A3C-9D01-000000000004'

Author = 'Eng. Hafeez Ur Rehman'

CompanyName = 'SNIPER Utilities Suite'

Copyright = '(c) 2026'

Description = 'Network Module'

PowerShellVersion = '5.1'

FunctionsToExport = @(
    'Initialize-SNPNetwork',
    'Test-SNPComputer',
    'Test-SNPShare',
    'Get-SNPShareStatus',
    'Get-SNPMappedDrives',
    'Connect-SNPDrive',
    'Disconnect-SNPDrive'
)

CmdletsToExport = @()

VariablesToExport = @()

AliasesToExport = @()

}