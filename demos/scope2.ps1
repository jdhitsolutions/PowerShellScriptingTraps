
#Do not run this in the ISE unless you are showing how
#it affects scope

Function Pause {
    Param([string]$msg = "Press any key to continue...",
        [switch]$cls)

    Write-Host "`n$msg" -foregroundcolor GREEN

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
    #define the variable in the Global scope which will persist it.
    $global:AlphaGlobal
    Write-Host "Exit Alpha" -ForegroundColor Yellow
}

Function Bravo {
    Write-Host "Running Bravo" -ForegroundColor Yellow
    $Bravo = 456
    #set a variable for the this demo script
    $script:BravoScript = 4

    #write the variables to the pipeline
    Write-Host "Bravo Output" -ForegroundColor Green
    $Bravo
    $script:BravoScript

    Write-Host "Try to access an out of scope variable. `$Alpha was 123 and `$Bravo was 456" -ForegroundColor Green
    Write-Host "`$Bravo + `$Alpha = $($Alpha+$Bravo)"
    Write-Host "Exit Bravo" -ForegroundColor Yellow

}

Clear-Host
Write-Host "Here are the functions defined in this script" -ForegroundColor Green
Write-Host "Alpha" -ForegroundColor Cyan
$function:Alpha
Write-Host "Bravo" -ForegroundColor Cyan
$Function:Bravo
Pause -cls

#main part of script
$Main = "I was here"

Write-Host "The Main variable exists because I just defined it in this demo script's scope." -ForegroundColor Green
Write-Host "`$main = $main"

Pause -cls

Write-Host "Let's call Alpha function." -ForegroundColor Green
Alpha
Pause -cls

Write-Host "Let's call Bravo function." -ForegroundColor Green
Bravo
pause -cls
Write-Host "The Alpha variable wasn't found because it only exists in the scope
of the Alpha function." -foregroundcolor Green
Pause -cls

Write-Host "However, I can save the output from the functions to variables."  -ForegroundColor Green
Write-Host "`$x = Alpha"
Write-Host "`$y = Bravo"
$x = Alpha
$y = Bravo
Write-Host "`$X +`$Y = $($x[0]+$y[0])" -foregroundcolor Cyan

# $x and `$y are arrays (because the functions write multiple objects to the pipeline) which is why I used an index number."
Write-Host "Now this works as expected." -ForegroundColor Green
Pause -cls
Write-Host "Or I can use variables that are visible in the current scope, ie this demo script." -ForegroundColor Green
Write-Host 'Get-Variable Alpha, Bravo, AlphaGlobal, BravoScript -errorAction "SilentlyContinue"' -ForegroundColor Green

Get-Variable Alpha, Bravo, AlphaGlobal, BravoScript -errorAction "SilentlyContinue"
Write-Host "`$BravoScript + `$AlphaGlobal = $($BravoScript+$AlphaGlobal )" -foregroundcolor Cyan

Write-Host "Within the functions I specified a scope for AlphaGlobal and BravoScript." -ForegroundColor Green
Pause -cls

Write-Host "The demo script is finished. In your console session now run:
  Get-Variable Alpha,Bravo,AlphaGlobal,BravoScript -errorAction 'SilentlyContinue'
and see what you have. Also be sure to look at Help About_Scopes" -ForegroundColor Green
