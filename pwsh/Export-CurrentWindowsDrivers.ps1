[CmdletBinding()]
param (
    [Parameter(Position = 0, HelpMessage = 'Absolute path, like C:\. By default, $cwd')]
    [string]
    [ValidateScript({
            if (-Not ($_ | Test-Path -PathType Container) ) {
                throw "The AbsolutePath argument '$_' must exist and be a folder."
            }
            return $true
        })]
    $absolutePath = $cwd
)

$ErrorActionPreference = 'Stop'
$localMachine = Get-CimInstance CIM_ComputerSystem
$destination = [System.IO.Path]::Combine($absolutePath, ($localMachine.Model, $localMachine.Name) -join '_', (Get-Date -Format "yyyy-MM-dd_HH-mm"))

#   Remove older drivers if any
if ($destination | Test-Path -PathType Container) {
    Get-ChildItem $destination -Recurse | Remove-Item -Force -Recurse
}

Export-WindowsDriver -Destination $destination -Online