#CommentFlag //

/* 
 File: monkfishing.ahk
 Date: 03 May 2020
 Author: R. Dekovich (dekovich@umich.edu)
 Description: OSRS Monkfishing script to include fishing and banking of
 			  monkfish in Piscatoris Fishing Colony.

 Setup: Follow the instructions below..
			1. Login, and ensure the following before usage:
				a. User is located near/around the bank logo in Piscatoris Fishing Colony
				b. User is using RuneLite launcher to play OSRS
					b.i. Ensure that the "Fishing" macro is enabled, and "Display spot icons" is checked within the macro
					b.ii. Turn on the "Entity hider" macro
						- Check all the boxes in the Entity hider macro except "Hide NPCs"
				c. Adjust the OSRS screen brightness to the third dot on the line
				d. Adjust the OSRS zoom to all the way left (no zoom at all)
				e. Set the compass to true NORTH, move the camera all the way up by holding the up arrow until it stops
				f. Ensure that the user has a small fishing net in their inventory in the first spot.
			2. Logout of OSRS to the default login screen
			3. Double click the AHK script to start the script, making its hotkeys available
			4. Press Shift+Z to start the script, to stop/reload, hit Shift+R

 BEFORE YOU START THE SCRIPT, CHANGE THE FOLLOWING VALUES IN THE LINES IN THE CODE (!):
	1. Line 111, change the path to the 'runescape-login.png' picture to your local path for it
	2. Line 149, change the path to the 'monkfish.png' picture to your local path for it
	3. Line 161, change the path to the 'monkfish.png' picture to your local path for it
	4. Line 179, change the path to the 'bank.png' picture to your local path for it
	5. Line 187, change the path to the 'fishing.png' picture to your local path for it
	6. Line 229, change the path to the 'net.png' picture to your local path for it
	7. Line 125, change the PASSWORD value to your OSRS passsword to login, ensure that your username/email is saved in entry field (default)
*/

global execGood


// Key bind for reloading the script (restarting/stopping)
+r::
{
	Clipboard=Manual reload
	TrayTip, Reload, Reload complete.
	Reload
}

// Key bind for starting the script
+z::
{
	Loop {
		// Activate and use the RuneLite window as its local frame
		IfWinExist, RuneLite
		WinActivate
		
		// Sleep temporarily for loop reload (5 seconds)
		sleep 5000
		
		// Check to see if the user is at the login page, if not, exit the script
		if (userOnLogin()) {
			// Log the user into OSRS
			loginUser()
			
			// Ensure the login was successful, break if not
			PixelGetColor, loginSuccess, 703, 201
			if (loginSuccess != 0x657A89) {
				Clipboard=Login unsuccessful
				Reload
			}
		}
		else {
			Clipboard=User wasn't on log-in page correctly
			Reload
		}
		
		// Set execution bit to good, set a timer to replace it when time is up for this iteration
		execGood := 1
		setTimer, changeExec, -10800000 // Timer runs for 3 hours (1000 * 60 (1s) * 60 (1m/h) * 3)
		
		// Loop indefinitley, break when timer has been reached after the last banking run
		Loop {
			// Check to see if your inventory is full
			if (inventoryFull()) {
				// Walk the user to the bank
				walkToBank()
				
				// Deposit the caught monkfish
				bankMonkfish()
				
				// See if the timer is up, if so, break the loop
				if (execGood = 0) {
					break
				}
			}
			
			// If the user is not already fishing
			if !(isFishing()) {
				// Find a fishing spot
				findFishingSpot()
				sleep 10000
			}
		}
		
		// Log the user out
		logoutUser()
	}
}



// Method to see if the user is on the login page - assumes normal conditions (not booted, etc)
userOnLogin() {
	ImageSearch Px, Py, 209, 201, 566, 394, C:\Users\15868\Desktop\osrs\scripts\assets\runescape-login.png
	loggedIn := 0
	if (ErrorLevel = 0) {
		// User is on login page
		loggedIn := 1
	}
	return loggedIn
}

// Method to log the user in to RuneLite client, and proceed to game
loginUser() {
	Click, 464, 317
	Click, 351, 292
	sleep 100
	SendInput PASSWORD
	Click, 309, 350
	sleep 12000 // Sleep for 12 seconds (allow script to login with some level of lag)
	Click, 403, 364
	sleep 2000
	return
}

// Method to log the user out of OSRS
logoutUser() {
	Click, 646, 509
	sleep 500
	Click, 639, 460
}

// Method to set the execution bit to 0 when the timer is up
changeExec() {
	execGood := 0
	return
}

// Method for finding a fishing spot in Piscatoris Fishing Colony; uses RuneLite overlays
findFishingSpot() {
	// Find where a monkfish overlay exists, click on it
	ImageSearch, Fx, Fy, 0, 0, 520, 365, C:\Users\15868\Desktop\osrs\scripts\assets\monkfish.png
	if (ErrorLevel = 0) {
		// Click on the fishing spot
		Click, %Fx%, %Fy%
	}
	return
}

// Method for checking if the inventory is full of monkfish
inventoryFull() {
	// See if a monkfish is in the final inventory slot
	SendInput {F2}
	ImageSearch, Mx, My, 691, 457, 729, 487, C:\Users\15868\Desktop\osrs\scripts\assets\monkfish.png
	if (ErrorLevel = 0) {
		// Inventory is full, return true
		return 1
	}
	return 0
}

// Method for finding and walking to the deposit box (bank)
walkToBank() {	
	// Default the click to move south west
	clickX := 605
	clickY := 144
		
	// Loop until the bank has been located
	errorCount := 0
	Loop {
		// See if the bank is on the map
		ImageSearch, Bx, By, 539, 30, 750, 195, C:\Users\15868\Desktop\osrs\scripts\assets\bank.png
		if (ErrorLevel = 0) {
			// Walk to the bank
			Click, %Bx%, %By%
			break
		}
		
		// Determine if you are all the way north west of the colony
		ImageSearch, Ex, Ey, 539, 30, 750, 195, C:\Users\15868\Desktop\osrs\scripts\assets\fishing.png
		if (ErrorLevel = 0) {
			// Set the click X and Y to move (hard) south east
			clickX := 702
			clickY := 135
		}
		
		// Pause after two attempts to find the bank for 10 seconds, try again
		if (errorCount > 1) {
			sleep 5000
			errorCount := errorCount + 1
			
			// If too many moves without finding bank, error out
			if (errorCount > 9) {
				Clipboard=Could not find bank
				Reload
			}
			
			continue
		}
		
		// Gradiently walk south east/west on the map until the bank comes within frame
		Click, %clickX%, %clickY%
		sleep 7000
		
		// Increment the error count
		errorCount := errorCount + 1
	}
	
	// Sleep and let the user walk to the bank
	sleep 10000
}

// Method for depositing the monkfish into the deposit box in Piscatoris
bankMonkfish() {
	// Open the deposit box
	Click, 247, 192
	
	// Sleep, give time for the deposit box to open
	sleep 1500
	
	// Validate that the bank was opened
	ImageSearch, Dx, Dy, 43, 91, 482, 285, C:\Users\15868\Desktop\osrs\scripts\assets\net.png
	if (ErrorLevel != 0) {
		Clipboard=Failed to open bank
		Reload
	}
	
	// Bank all the monkfish in the inventory
	Click, Right, 146, 118
	sleep 5000
	Click, 146, 188
	
	// Exit the inventory
	Click, 472, 78
	
	// Sleep for a second
	sleep 1000
}

// Method for checking if the user is currently fishing or not
isFishing() {
	PixelGetColor, fishingIndicator, 58, 65
	if (fishingIndicator = 0x00FF00) {
		return 1
	}
	return 0
}
