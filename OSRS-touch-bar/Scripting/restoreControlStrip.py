#!/usr/bin/python
# Reloads the user's original Control Strip settings
import sys, os
if len(sys.argv) < 2:
    print("usage: restoreControlStrip.py <preferences_string>")
    exit(1)

defaultsScript = "/usr/bin/defaults write ~/Library/Preferences/com.apple.controlstrip MiniCustomized " + sys.argv[1]

# Restore the user's original preferences
os.system(defaultsScript)
os.system("killall ControlStrip")
