
#Do not run this in the ISE unless you are showing how
#it affects scope

Function Pause {
    Param([string]$msg = "Press any key to continue...",
        [switch]$cls)

    Write-Host $msg -foregroundcolor GREEN

    $Running = $true

    While ($Running) {
        if ($host.ui.RawUi.KeyAvailable) {
            $key = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            if ($key) {
                $Running = $False
            }
        }
        start-sleep -millisecond 100
    } #end While
    if ($cls) {
        Clear-host
    }
} #end function

Function Alpha {
    Write-Host "Running Alpha" -ForegroundColor Yellow
    $Alpha = 123
    $global:AlphaGlobal = 1

    #write the variables to the pipeline
    Write-Host "Alpha output" -ForegroundColor Green
    $Alpha
    $global:AlphaGlobal
    Write-Host "Exit Alpha" -ForegroundColor Yellow
}

Function Bravo {
    Write-Host "Running Bravo" -ForegroundColor Yellow
    $Bravo = 456
    #set a script variable
    $script:BravoScript = 4

    #write the variables to the pipeline
    Write-Host "Bravo Output" -ForegroundColor Green
    $Bravo
    $script:BravoScript

    Write-host "Try to access an out of scope variable." -ForegroundColor Green
    Write-Host "Bravo + Alpha= $($Alpha+$Bravo)"
    Write-Host "Exit Bravo" -ForegroundColor Yellow

}

Clear-Host
Write-Host "Here are the functions defined in this script" -ForegroundColor Green
Write-host "Alpha" -ForegroundColor Cyan
$function:Alpha
Write-host "Bravo" -ForegroundColor Cyan
$Function:Bravo
Pause -cls

#main part of script
$Main = "I am here"

Write-Host "The Main variable exists because I just defined it." -ForegroundColor Green
write-host "`$main = $main" -ForegroundColor Green

Pause -cls

Write-Host "Let's call Alpha function." -ForegroundColor Green
Alpha
Pause -cls

Write-Host "Let's call Bravo function." -ForegroundColor Green
Bravo
Write-host "The Alpha variable wasn't found because it only exists in the scope
of the Alpha function." -foregroundcolor Green
Pause -cls

Write-host "However, I can save the output from the functions to variables."  -ForegroundColor Green
Write-host "`$x=Alpha"
write-host "`$y = Bravo"
$x = Alpha
$y = Bravo
write-Host "X+Y=$($x[0]+$y[0])" -foregroundcolor Cyan

write-host "Now this works. `$x and `$y are arrays (because the functions write multiple objects to the pipeline) which is why I used an index number." -ForegroundColor Green
Pause -cls
Write-Host "Or I can use variables that are visible in the current scope, ie this demo script." -ForegroundColor Green
write-host 'Get-Variable Alpha, Bravo, AlphaGlobal, BravoScript -errorAction "SilentlyContinue"' -ForegroundColor Green

Get-Variable Alpha, Bravo, AlphaGlobal, BravoScript -errorAction "SilentlyContinue"
Write-Host "BravoScript+AlphaGlobal=$($BravoScript+$AlphaGlobal )" -foregroundcolor Cyan

Write-host "Within the functions I specified a scope for AlphaGlobal and BravoScript." -ForegroundColor Green
Pause -cls

Write-host "The demo script is finished. In your console session now run:
  Get-Variable Alpha,Bravo,AlphaGlobal,BravoScript -errorAction 'SilentlyContinue'
and see what you have. Also be sure to look at Help About_Scopes" -ForegroundColor Green
