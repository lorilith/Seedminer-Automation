"Please download the latest release of Python 3 and Python 2 from here: https://www.python.org/downloads/ and place them in the same directory as this script.\nOnce this is done, press enter to continue with installing Python 3 then Python 2."
C:\Windows\System32\cmd.exe /c pause

Start-Process -FilePath (Resolve-Path "python-3.*.exe") -ArgumentList "/simple /passive"
"Once python 3 has finished installing, please press enter as prompted below."
C:\Windows\System32\cmd.exe /c pause

msiexec /i (Resolve-Path "python-2.7.*.msi") /passive
"Once python 2 has finished installing, please press enter as prompted below."
C:\Windows\System32\cmd.exe /c pause

"Please make sure that the below versions are the latest (just to confirm that things went as planned)"

py -3 --version
py -2 --version
C:\Windows\System32\cmd.exe /c pause

py -2 -mpip install pycryptodomex