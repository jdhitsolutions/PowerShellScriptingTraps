cd
#run this in a console session
$x = 100

new-psdrive -Name Work -PSProvider FileSystem -Root C:\work

$x * $x | out-file work:\x.txt

get-content work:\x.txt
