@{

RootModule        = 'Console.psm1'

ModuleVersion     = '1.0.0'

GUID              = '0c9ab3f8-0d22-4d2a-a001-000000000004'

Author            = 'Eng. Hafeez Ur Rehman'

CompanyName       = 'SNIPER Utilities Suite'

Copyright         = '(c) 2026'

Description       = 'SNIPER Console Framework'

PowerShellVersion = '5.1'

FunctionsToExport = @(
'Write-SNPHeader',
'Write-SNPInfo',
'Write-SNPSuccess',
'Write-SNPWarning',
'Write-SNPError',
'Write-SNPSeparator',
'Write-SNPBlank'
)

}