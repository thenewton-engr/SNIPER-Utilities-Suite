#=========================================================
# SNIPER Utilities Suite
# Configuration Module
# Build 1001
#=========================================================

Set-StrictMode -Version Latest

$script:Config = @{}

function Initialize-SNPConfiguration {

    param(
        [string]$ConfigFile = (Join-Path $PSScriptRoot "..\..\Config\Config.ini")
    )

    if (!(Test-Path $ConfigFile)) {
        throw "Configuration file not found: $ConfigFile"
    }

    $CurrentSection = ""

    foreach ($Line in Get-Content $ConfigFile) {

        $Line = $Line.Trim()

        if ($Line -eq "") { continue }

        if ($Line.StartsWith(";")) { continue }

        if ($Line.StartsWith("[")) {

            $CurrentSection = $Line.Trim("[","]")

            if (!$script:Config.ContainsKey($CurrentSection)) {
                $script:Config[$CurrentSection] = @{}
            }

            continue
        }

        if ($Line -match "=") {

            $Parts = $Line.Split("=",2)

            $Key = $Parts[0].Trim()

            $Value = $Parts[1].Trim()

            $script:Config[$CurrentSection][$Key] = $Value
        }
    }
}

function Get-SNPConfig {

    param(
        [string]$Section,
        [string]$Key
    )

    return $script:Config[$Section][$Key]

}

Export-ModuleMember `
-Function Initialize-SNPConfiguration, `
          Get-SNPConfig