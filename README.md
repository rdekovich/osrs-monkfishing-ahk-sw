# osrs-monkfishing-ahk-sw
The following repository contains the source code, assets and instructions for setting up and using the OSRS Monkfishing script, 
which uses AHK (AutoHotKey) to fish and bank monkfish for a given user in OSRS.

## Requirements
To use this script, the following requirements are mandated in order for proper functionality.

### OSRS prerequisites
Prior to considering using this script, the user must first do/have the following:

* Has completed Swan Song (quest)
* Has 62+ Fishing
* Has a small fishing net

### System requirements
Prior to considering using this script, the user must first do/have the following:

* Installed [AutoHotKey](https://www.autohotkey.com/), an automation scripting language
* Installed RuneLite, and configure it for scripting purposes (see **RuneLite configuration**)

## Setup
To setup your computer and RuneLite for the script, follow these intuitive instructions for the quickest setup.

The script uses a programmed hotkey that will use dynamic logic (image recognition, movement logic, etc.) to find monkfish, 
fish them until the inventory is full, and bank them at a near deposit box in Piscatoris Fishing Colony.  The script will take over the 
keyboard and mouse while using, so it is recommended to use it in a Virtual Machine, or AFK.

### OSRS Setup
Prior to running the script, do the following while logged in to OSRS:

* Travel to Piscatoris Fishing Colony
* Place a small fishing net in your inventory, can be in any spot except the last spot in the inventory
* Click the compass near the minimap to put the camera at true **north**
* Hold the up arrow key on your keyboard to move the camera to the highest angle
* Go to the OSRS Settings tab on the bottom of the side bar, and do the following
	* Turn the brightness to (about) the 3rd dot in the line
	* Turn the zoom all the way left (no zoom)
	* Click the left option for screen size (fixed size, not full screen)
* Make sure that when you click the logout option in the bar, it is not prompting the world switcher interface

Once these settings are set, logout of OSRS.  Make sure that the main menu says "Welcome to RuneScape".

### RuneLite configuration
Prior to running the script, do the following in the RuneLite launcher

* Ensure the "Fishing" plugin/macro in the settings bar of RuneLite
	* Make sure that "Display spot icons" is checked, this will show what fish is available at a fishing spot
* Enable the "Entity Hider" plugin/macro in the settings bar of RuneLite
	* Check all the boxes except "Hide NPCs", this will hide your user and all other users from visibility

### Start the script
Before starting the script, open the code `monkfishing.ahk` in (preferably) Notepad++, or another editor that shows line numbers.  Edit
the lines specified within the file before starting.  You should only need to do this once.

Once this is done, to start the AHK key binding, double click the script `monkfishing.ahk`.

Once this is clicked, to start the script, make sure you are on the login screen of RuneLite, and press `Shift+Z`.

To stop the script manually, press `Shift+R`
