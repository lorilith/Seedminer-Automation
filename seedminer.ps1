function getID0 {
    param([string]$N3DS_Folder)
    return (Get-ChildItem -Path ($N3DS_Folder)* -Exclude [pP]* | Where-Object -FilterScript {$_.Name -match "^[0-9a-f]{32}" -and $_.Name.Length -eq 32})
}
function getID1 {
    param([string]$ID0_Folder)
    return (Get-ChildItem -Path ($ID0_Folder)* -Exclude [pP]* | Where-Object -FilterScript {$_.Name -match "^[0-9a-f]{32}" -and $_.Name.Length -eq 32})
}
function IsOneID0 {
    param([string]$N3DS_Folder)
    $id0 = GetID0 $N3DS_Folder
    if ($id0.Count -ne 1) {
        return $False;    
    }
    return $True
}
function IsOneID1 {
    param([string]$ID0_Folder)
    $id1 = GetID1 $ID0_Folder
    if ($id1.Count -ne 1) {
        return $False;
    }
    return $True
}
function GetDriveLetter {
    $drive = Read-Host -Prompt "Please enter the drive letter that your SD card is mounted to below (only the letter, no colon (:)or slash (/)"
    return $drive
}
function GenerateFreshNintendo3DS {
    $exitTrigger = 0
  while ($exitTrigger -ne 1) {
    $drive = GetDriveLetter;
    
    $Nintendo3ds = $drive + ":/Nintendo 3ds";
    if (-not [System.IO.Directory]::Exists($Nintendo3ds)) {
        Write-Host "I can't find your Nintendo 3ds folder on that drive...please check your drive letters and try again.`nIf the drive letter was right, make sure you used this SD card in your Nintendo 3ds/2ds"
        exit(1);
    }    
  Write-Host "`nMaking sure you only have 1 ID0 folder in the Nintendo 3ds folder on your SD.`n"

  if ( IsOneID0 $Nintendo3ds ) {
     $id0 = GetID0 $Nintendo3ds

    if ( IsOneID1 $id0 ) {
      return $Nintendo3ds
      
    }
  }
  if ([System.IO.Directory]::Exists($Nintendo3ds+"_FRESH")) {
    if ([System.IO.Directory]::Exists($Nintendo3ds)) {
     if ([System.IO.Directory]::Exists($Nintendo3ds+"_BACKUP")) {
        Read-Host -Prompt "$($Nintendo3ds)_FRESH , _BACKUP, and normal directories found, if you can debug, find the original nintendo 3ds folder and remove the others and rerun this script.`nPress Enter to Continue"
     }else{
        Read-Host -Prompt "$($Nintendo3ds)_FRESH and normal directories found. Assuming you cancelled mid process. renaming directories. `nYou will need to enter the drive letter after this.`nPress Enter to Continue"
        Rename-Item "$Nintendo3ds" $Nintendo3ds"_BACKUP"
        Rename-Item $Nintendo3ds"_FRESH" $Nintendo3ds
     }
    }else{
        Read-Host -Prompt "$($Nintendo3ds)_FRESH and _BACKUP directories found. Assuming you cancelled mid process. renaming directories. `nYou will need to enter the drive letter after this.`nPress Enter to Continue"
        Rename-Item $Nintendo3ds"_FRESH" $Nintendo3ds
    }
  }else{
  ## check for existance of _BACKUP folder
       if ([System.IO.Directory]::Exists($Nintendo3ds+"_BACKUP")) {

            Read-Host -Prompt "$($Nintendo3ds)_BACKUP found. Please rename this folder and press <enter>"
            
        } else {

          "Renaming Nintendo 3DS folder to ensure correct ID0..."
            " "
           Rename-Item "$Nintendo3ds" $Nintendo3ds"_BACKUP"
            Write-Host "Please remove the SD card, then insert it into the 3ds and turn the 3ds on"
            Write-Host "When the 3ds is fully booted to the home menu, turn the 3ds off and put the SD back into the computer"
            Read-Host -Prompt "Once the SD is returned to the computer, Press <enter>"
        }
  }
  }
}
function RestoreNintendo3DS {
    param([string]$Drive)
        $Nintendo3ds = ($drive + ":/Nintendo 3ds/")

 if ([System.IO.Directory]::Exists($Nintendo3ds+"_BACKUP")) {
    if (-not [System.IO.Directory]::Exists($Nintendo3ds+"_FRESH")) {
     Rename-Item "$Nintendo3ds" $Nintendo3ds"_FRESH"
    }else{
     Rename-Item "$Nintendo3ds" $Nintendo3ds"_ABCDEFGHIJ"
    }
    Rename-Item $Nintendo3ds"_BACKUP" $Nintendo3ds
 }
}
function VerifyMiningFiles {
$missingCount = 0
Write-Host "`nChecking for required files in $(Resolve-Path ./) , please wait...`n"
## movable_part1
    if ([System.IO.File]::Exists("$pwd/movable_part1.sed")) {
    Write-Host "movable_part1.sed found!"
    } 
    else {
    Write-Host "movable_part1.sed missing. Close this window and get your movable_part1.sed from somebody"
        $missingCount=$missingCount+1
    }
    ## seedminer_launcher
    " "
    if ([System.IO.File]::Exists("$pwd/seedminer_launcher.py")) {
    Write-Host "Seedminer found!"
    }
    else{
        Write-Host "Seedminer program missing. download it from https://github.com/zoogie/seedminer/releases/latest "
        Write-Host "put this script and the movable_part1.sed in the same folder as seedminer_launcher.py"
        $missingCount=$missingCount+1
    }
    return $missingCount
}
function VerifyMiningComplete {
## movable.sed
    if([System.IO.File]::Exists("./Upload/movable.sed")) {
          Write-Host "movable.sed found"
        return $True
    }elseif ([System.IO.File]::Exists("./movable.sed")) {
        copy-item -Path "./movable.sed" -Destination "./Upload/"
        return $True
    }else{
        return $False
    }
}
function HandleDSiWare {
    param([string]$DSiWare)

  Write-Host "Copying all DSiWare titles from SD to ./Upload/"
  copy-item -Path $DSiWare -Destination "./Upload/" -Recurse

  $dsiwareBin = Get-ChildItem -Path "./Upload/"*

  $dsiwareBinName = Split-Path -Path "./Upload/($dsiwareBin)" -leaf


}
function AddID0 {
    param([string]$iD0)

  Write-Host "Adding ID0 ($iD0) to movable_part1.sed`n"
  py -2 "./seedminer_launcher.py" id0 $iD0
  
}

function Mining {

  $method = Read-Host -Prompt "Do you wish to do 'gpu' or 'cpu' based mining?
  Note: while GPU mining is generally faster, you need the hardware for it. If you have integrated graphics or are unsure, you should select CPU or ask for assistance.

  If someone else is doing the mining for you, send them your movable_part1.sed and close this window."

  py -2 "./seedminer_launcher.py" $method
 while (-not (VerifyMiningComplete) ) {
    sleep 10
 }
}
function Patching {
##"Please follow the instructions on: https://jenkins.nelthorya.net/job/DSIHaxInjector/build?delay=0sec and place the result in a folder named 'final' (no quotes). Rename this so that it is identical to the original backup."

Read-Host -Prompt "Please follow the instructions on: https://jenkins.nelthorya.net/job/DSIHaxInjector/build?delay=0sec and place the result in a folder named 'final' (no quotes). Rename this so that it is identical to the original backup."

copy-item -Path [io.Path]::combine("./final/", $DSiWare), $DSiWare

}


$baseDir = Get-Location
   Write-Host "running in $baseDir"

  Write-Host "This script assumes that you are not dumping your own files, and that you have had someone else give you your 'movable_part1.sed'."

     $Nintendo3ds = GenerateFreshNintendo3DS 
     Write-Host "Alright! we now know what your ID0 and ID1 folders are, lets get started!"
     $id0 = GetID0 $Nintendo3ds
     $id1 = GetID1 $id0
     
     $DSiWare = [io.Path]::combine(($id1),"Nintendo DSiWare")
    
  if (-Not [System.IO.Directory]::Exists($DSiWare)) {
    Write-Host "Oh No! DSiWare Folder not found. Please backup your DSiWare game to the SD and restart this script."
    Write-Host "Instructions for copying DSiWare:`nPut your SD into your 3ds and turn it on.`nGo to System Settings`nGo to Data Management`nGo To DSiWare`nClick your game`nClick Copy`n"
    Read-Host -Prompt "Press Enter to exit."
   exit(1)
  }
    HandleDSiWare $DSiWare

$missing = VerifyMiningFiles
Write-Host "Missing $missing Files"
if ($missing -gt 0) {
    Write-Host "Please correct the above issues and restart the script"
    Read-Host -Prompt "Press Enter to Continue"
   exit(1)
}

if (VerifyMiningComplete) {
    Write-Host "Mining seems to have already been completed, moving to patching"
    Patching
}else{
    AddID0 $id0.Name
    Mining
    Patching
}
