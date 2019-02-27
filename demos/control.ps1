#requires -version 5.1

#this creates a 'viewable' text report
[cmdletbinding()]
Param([string[]]$Computername)

#dot source since this isn't in a module - remember scope?!
. $PSScriptRoot\betterfunction.ps1

$data = Get-SystemStatus @PSBoundParameters

foreach ($item in $data) {
    "System Report"
    $item | Select-Object -property Computername,OperatingSystem,
    @{Name="ReportDate";Expression = { (Get-Date)}} | format-table
    "`nRunning Services"
    $item.Services | Select-Object -property Name,Displayname,StartType | Format-Table
    "`nTop Processes"
    $item.Processes | Format-Table
}

#powershell doesn't like to mix formatting