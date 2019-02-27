Function Get-SystemStatus {
    [cmdletbinding()]
    [alias("gss")]
    Param([string[]]$Computername = $env:COMPUTERNAME)

    foreach ($computer in $computername) {

        $os = (Get-Ciminstance win32_operatingsystem -ComputerName $computer).caption
        $p = Get-Process -ComputerName $computer | Where-Object {$_.ws -gt 50mb}
            Select-Object Machinename, ID, Name, Handles, WS, VM
        $s = Get-Service -computername $computer | Where-Object {$_.status -eq 'running'}

        [pscustomobject]@{
            Computername    = $Computer.toUpper()
            OperatingSystem = $os
            Processes       = $p
            Services        = $s
        }
    }
}

# it might also make more sense to split this into different commands
# it might also make sense to NOT limit properties on the process object