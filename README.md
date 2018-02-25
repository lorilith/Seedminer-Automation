# Seedminer-Automation
Scripts which automate the seedmining process.


### Seedminer + TADPole for a user who is having lfc dumped externally. (Interpreted to give just what is needed and not much else for sanity.
Pretty much assumes that you are doing this over the internet, but the same things apply for local)

##Part 1: Setup

1. Download the following (THE RELEASE ZIPS, NOT THE SOURCE CODE, AND NOTHING ELSE)
	Seedminer: https://github.com/zoogie/seedminer/releases

2. Place Seedminer anywhere

3. Place the scripts in the seedminer folder (there is a folder inside of the release that is called seedminer)

Note: you need python 2 and 3 in order for seedminer and TADpole to work. 
If you do not have these, there is a script that you can run that will make installing python 3 and 2 easier (right click the script and select "run in powershell")

##Part 2: The actual thing (no homebrew access)

1. Create a backup of the DSiWare title you are going to modify. This is done by going to System Settings > Data managment > DSiWare > select the title > copy

2. Find someone that either has homebrew or cfw access, and give them the .3dsx from the seedminer download, and have them put it in /3ds/

3. Add them as a friend, and have them run the seedstarter.3dsx from their homebrew launcher and press B. This will export all lfcs added to their SD card at /seedminer/. 
   Find the one with your FC and have them give it to you. 

4. Once you have this file, change the name to "movable_part1.sed" (no quotes) and put this file in the seedminer folder, and put your SD card in your computer. 

	4.a. Make sure that your Nintendo 3ds folder on your SD card, and that the only other folder in Nintendo 3ds is the private folder. 

5. Run the "run_me.bat" and do as it asks you to do.

6. Once the script is done, continue to this part of the guide: https://3ds.hacks.guide/installing-boot9strap-(dsiware-game-injection)  
   Do the "What you need" section followed by Section V. The below is a list of things which you do not need to download.
	The sudokuhax injection .zip

7. Follow the rest of the guide from there, and you should be done.
