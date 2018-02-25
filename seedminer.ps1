$baseDir = Get-Location
"This script assumes that you are not dumping your own files, and that you have had someone else give you your 'movable_part1.sed'."

$drive = Read-Host -Prompt "Please enter the drive letter that your SD card is mounted to below (only the letter, no colon (:)or slash (/)"
$Nintendo3ds = ($drive + ":/Nintendo 3ds/")

"Please ensure that you only have a Private folder and a folder with random numbers and letters in the Nintendo 3ds folder of your sd card before continuing."
C:\Windows\System32\cmd.exe /c pause

$id0 = Get-ChildItem -Path ($Nintendo3ds)* -Exclude [pP]*
$id1 = Get-ChildItem -Path ($id0)* -Exclude [pP]*
$DSiWare = [io.Path]::combine(($id1),"Nintendo DSiWare")


copy-item -Path $DSiWare -Destination "./Upload/" -Recurse

$dsiwareBin = Get-ChildItem -Path "./Upload/"*

$dsiwareBinName = Split-Path -Path "/Upload/($dsiwareBin)" -leaf

$method = Read-Host -Prompt "Do you wish to do 'gpu' or 'cpu' based mining?
Note: while GPU mining is generally faster, you need the hardware for it. If you have integrated graphics or are unsure, you should select CPU or ask for assistance.

If someone else is doing the mining for you, send them your movable_part1.sed and close this window."

py -2 "./seedminer_launcher.py" $method

copy-item -Path "./movable.sed" -Destination "./Upload/"

"Please follow the instructions on: https://jenkins.nelthorya.net/job/DSIHaxInjector/build?delay=0sec and place the result in a folder named 'final' (no quotes). Rename this so that it is identical to the original backup."

C:\Windows\System32\cmd.exe /c pause

copy-item -Path [io.Path]::combine("./final/", $DSiWare), $DSiWare