#!/usr/bin/python
# Reloads the user's original Control Strip settings
import sys, os

filename = "MiniCustomizedPreferences.txt"

with open(filename, 'r') as constrolStripDefaultsFile:
    # Read the preferences file
    preferences = "' " + constrolStripDefaultsFile.read().replace('\n', "").replace("\"", "") + " '"
    defaultsScript = "/usr/bin/defaults write ~/Library/Preferences/com.apple.controlstrip MiniCustomized " + preferences
    
    # Restore the user's original preferences
    os.system(defaultsScript)
    os.system("killall ControlStrip")
