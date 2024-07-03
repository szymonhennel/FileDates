# Import all public functions
Get-ChildItem -Path "$PSScriptRoot\public" -Filter *.ps1 | ForEach-Object { . $_.FullName }

# Import all private functions (if any)
Get-ChildItem -Path "$PSScriptRoot\private" -Filter *.ps1 | ForEach-Object { . $_.FullName }

# Export public functions
Get-ChildItem -Path "$PSScriptRoot\public" -Filter *.ps1 | ForEach-Object { Export-ModuleMember -Function $_.BaseName }
