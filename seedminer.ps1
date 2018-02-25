$baseDir = Get-Location

"This script assumes that you are not dumping your own files, and that you have had someone else give you your 'movable_part1.sed'."
  $drive = Read-Host -Prompt "Please enter the drive letter that your SD card is mounted to below (only the letter, no colon (:)or slash (/)"
  $Nintendo3ds = ($drive + ":/Nintendo 3ds")
  echo $Nintendo3ds

  ## generate fresh Nintendo 3DS folder ##
  "Renaming Nintendo 3DS folder to ensure correct ID0..."
  " "
  Rename-Item "$Nintendo3ds" $Nintendo3ds"_BACKUP"
  "Please remove the SD card, then insert it into the 3ds and turn the 3ds on"
  "When the 3ds is fully booted to the home menu, turn the 3ds off and put the SD back into the computer"
  Read-Host -Prompt "Once the SD is returned to the computer, Press <enter>"
  
  
  $drive = Read-Host -Prompt "Please enter the drive letter that your SD card is now mounted to below (only the letter, no colon (:)or slash (/)"
  $Nintendo3ds = ($drive + ":/Nintendo 3ds")

  $id0 = Get-ChildItem -Path ($Nintendo3ds)* -Exclude [pP]*
  $id1 = Get-ChildItem -Path ($id0)* -Exclude [pP]*
  $DSiWare = [io.Path]::combine(($id1),"Nintendo DSiWare")
  

  Rename-Item "$Nintendo3ds" $Nintendo3ds"_FRESH"
  Rename-Item $Nintendo3ds"_BACKUP" "$Nintendo3ds"
  $Nintendo3ds="$Nintendo3ds/"
  echo $Nintendo3ds

  ##"Please ensure that you only have a Private folder and a folder with random numbers and letters in the Nintendo 3ds folder of your sd card before continuing."
  ##C:\Windows\System32\cmd.exe /c pause


"\nChecking for required files, please wait...\n"
## movable_part1
" "
if ([System.IO.File]::Exists("./movable_part1.sed")) {
"movable_part1.sed found!"
} 
else {
"movable_part1.sed missing. Close this window and get your movable_part1.sed from somebody"
}
## seedminer_launcher
" "
if ([System.IO.File]::Exists("./seedminer_launcher.py")) {
"Seedminer found!"
}
else{
"Seedminer program missing. download it from https://github.com/zoogie/seedminer/releases/latest 
put this script and the movable_part1.sed in the same folder as seedminer_launcher.py"
}
" "
## movable.sed
if ([System.IO.File]::Exists("./movable.sed")) {
"movable.sed found...skipping the mining portion"
}
else{
Read-Host -Prompt "address any issues listed above then Press <enter>"

  "Adding ID0 to movable_part1.sed\n"
  py -2 "./seedminer_launcher.py" id0 $id0.Name

  "Copying all DSiWare titles from SD to ./Upload/\n"
  copy-item -Path $DSiWare -Destination "./Upload/" -Recurse

  $dsiwareBin = Get-ChildItem -Path "./Upload/"*

  $dsiwareBinName = Split-Path -Path "/Upload/($dsiwareBin)" -leaf

  $method = Read-Host -Prompt "Do you wish to do 'gpu' or 'cpu' based mining?
  Note: while GPU mining is generally faster, you need the hardware for it. If you have integrated graphics or are unsure, you should select CPU or ask for assistance.

  If someone else is doing the mining for you, send them your movable_part1.sed and close this window."

  py -2 "./seedminer_launcher.py" $method
}
copy-item -Path "./movable.sed" -Destination "./Upload/"

##"Please follow the instructions on: https://jenkins.nelthorya.net/job/DSIHaxInjector/build?delay=0sec and place the result in a folder named 'final' (no quotes). Rename this so that it is identical to the original backup."

Read-Host -Prompt "Please follow the instructions on: https://jenkins.nelthorya.net/job/DSIHaxInjector/build?delay=0sec and place the result in a folder named 'final' (no quotes). Rename this so that it is identical to the original backup."

copy-item -Path [io.Path]::combine("./final/", $DSiWare), $DSiWare
