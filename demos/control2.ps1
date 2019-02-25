#requires -version 5.1

#this control script creates an HTML report

[cmdletbinding()]
Param(
    [Parameter(Position = 0, Mandatory, HelpMessage = "Enter the name(s) of a remote computer to analyze.")]
    [ValidateNotNullOrEmpty()]
    [string[]]$Computername,
    [Parameter(HelpMessage = "Open the HTML file upon completion in your default browser")]
    [switch]$Passthru
)

#calculate a rough runtime for this script
$begin = Get-Date

#dot source the function since this isn't in a module - remember scope?!
. $PSScriptRoot\betterfunction.ps1

$data = Get-SystemStatus -Computername $Computername

# get current timezone name
if ( (Get-Date).IsDaylightSavingTime()) {
    $tz = (Get-TimeZone).DaylightName
}
else {
    $tz = (Get-TimeZone).StandardName
}

$fragments = @("<H1>System Report $(Get-Date) $tz<H1>")

foreach ($item in $data) {
    $fragments += "<H2 title='$($item.Operatingsystem)'>$($item.computername)</H2>"

    $fragments += "<H3 title='$($item.services.count) services'>Running Services</H3>"
    $fragments += $item.Services | Select-Object -property Name, Displayname, StartType |
        ConvertTo-Html -Fragment -as table

    <#
    if there is only a single item it may not be treated as an array which means
    the count property won't be defined. Using Measure-Object guarantees a count.
    #>
    $fragments += "<H3 title='$(($item.processes| Measure-Object).count) processes with a WS greater than 50MB'>Top Processes</H3>"

    $fragments += $item.Processes | Sort-Object -Property WS -Descending |
        Select-Object -Property Name, ID, Handles, @{Name = "WS(MB)"; Expression = {$_.WS / 1MB -as [int]}},
    @{Name = "VM(MB)"; Expression = {$_.VM / 1MB -as [int]}} | ConvertTo-Html -Fragment -as table
}

#embed a style sheet into the html header
$head = @"
<title>System Report</title>
<style>
body { background-color:#FFFFFF;
       font-family:Monospace;
       font-size:10pt; }
td, th { border:0px solid black;
         border-collapse:collapse;
         white-space:pre;
         font-size:12pt; }
th { color:white;
     background-color:black; }
table, tr, td, th { padding: 0px; margin: 0px ;white-space:pre; }
tr:nth-child(odd) {background-color: #E6E6E6}
table {  width:60%;margin-left:10px; }
h1,h2,h3 { font-family:Tahoma;}
h2,h3 {color: #0000FF}
h1 { font-size:16pt;}
h2 { font-size:13pt;}
h3 { font-size:12pt;}
.footer {
    color: #31B404;
    margin-left: 10px;
    font-family: Tahoma
    font-size:8pt;
    font-style:italic;
    width:15%;
}
.footer tr:nth-child(odd) {background-color: #FFFFFF}
.footer td,tr {
    border-collapse:collapse;
    border:none;
}
</style>
"@

<#
I like to include some metadata about the script that generated the HTML report.
This can be useful if you set this up as a scheduled job somewhere in your network
and later forget where it is running. Or the person who set it up leaves and never
documents the process they enabled.
#>

$end = Get-Date
# You can manually set a version number for the script
$scriptVersion = "1.5"

$meta = [PSCustomObject]@{
    ReportDate   = (Get-Date)
    Script       = (Convert-Path $MyInvocation.InvocationName).Replace("\", "/")
    Version      = $scriptVersion
    RunBy        = "$env:USERDOMAIN\$env:USERNAME"
    Runtime      = $end - $begin
    Computername = $env:computername
}

[xml]$footer = $meta | ConvertTo-Html -Fragment -as List
#insert css tags into this table
$class = $footer.CreateAttribute("class")
$footer.table.SetAttribute("class", "footer")
$post = "<br><br>$($footer.InnerXml)"

#this might be better as a parameter for the user to specify a filepath.
$filename = "SystemReport_$((get-date -Format yyyyMMdd)).html"
$outfile = Join-Path -path $env:temp -ChildPath $filename

ConvertTo-HTML -Body $fragments -Head $head -PostContent $post | Out-File -FilePath $outfile -Encoding ascii

<#
Normally, -Passthru would write the file object to the pipeline

  Get-Item -path $outfile

  #>
if ($passthru) {
    Invoke-item $outfile
}