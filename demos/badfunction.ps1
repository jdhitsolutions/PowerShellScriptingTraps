
Function Get-SystemStatus {
    [cmdletbinding()]
    Param([string[]]$Computername = $env:COMPUTERNAME)

    "Operating System"
    (Get-Ciminstance win32_operatingsystem -ComputerName $computername).caption

    $p = Get-Process -ComputerName $computername | Where-Object {$_.ws -gt 50mb}
    $s = Get-Service -computername $computername | Where-Object {$_.status -eq 'running'}
    "Top Processes"
    $p | Select-object Machinename, ID, Name, Handles, WS, VM | format-table
    "Running Services"
    $s
}

