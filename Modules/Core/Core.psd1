@{

RootModule        = 'Core.psm1'

ModuleVersion     = '1.0.0'

GUID              = '8a52d8a4-4f6c-4b2e-a100-000000000001'

Author            = 'Eng. Hafeez Ur Rehman'

CompanyName       = 'SNIPER Utilities Suite'

Copyright         = '(c) Eng. Hafeez Ur Rehman'

Description       = 'Core Engine'

PowerShellVersion = '5.1'

FunctionsToExport = @(
'Start-SNPCore',
'Get-SNPVersion'
)

CmdletsToExport = @()

VariablesToExport='*'

AliasesToExport=@()

}