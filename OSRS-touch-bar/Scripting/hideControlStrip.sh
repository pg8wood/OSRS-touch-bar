#!/bin/sh
# Hides the user's Control Control Strip

defaults write ~/Library/Preferences/com.apple.controlstrip MiniCustomized '()'
killall ControlStrip
