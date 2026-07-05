@{

RootModule = 'Logging.psm1'

ModuleVersion = '2.0.1000'

GUID = '8F8B8C74-3C56-4C71-8B14-A4E87A8D1000'

Author = 'Eng. Hafeez Ur Rehman'

CompanyName = 'SNIPER Utilities Suite'

Copyright = '(c) 2026'

Description = 'Logging module for SNIPER Utilities Suite'

PowerShellVersion = '5.1'

FunctionsToExport = @(
'Initialize-SNPLogging',
'Write-SNPLog',
'Get-SNPLogFile'
)

CmdletsToExport = @()

VariablesToExport = @()

AliasesToExport = @()

}