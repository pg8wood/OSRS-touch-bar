//
//  TouchBarScriptRunner.swift
//  OSRS-touch-bar
//
//  Runs various AppleScripts that modify Touch Bar settings in System Preferences
//
//  Created by Patrick Gatewood on 3/3/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Foundation

@objc class TouchBarScriptRunner: NSObject {
    
    // "Expands" the Touch Bar by disabling the Control Strip in System Preferences
    @objc static func expandTouchBar() {
        let disableControlStripScript = """
        tell application "System Preferences"
            activate\n
            reveal anchor "keyboardTab" of pane id "com.apple.preference.keyboard"\n\
        end tell\n\
        delay 0.5
        tell application "System Events" to tell process "System Preferences"\n\
            tell pop up button 2 of tab group 1 of window 1\n\
                click\n\
                click menu item "App Controls" of menu 1\n\
            end tell\n\
        end tell\n\
        quit application "System Preferences"
        """
        
        ScriptExecutor.runScriptShowingErrors(sourceString: disableControlStripScript)
    }
    
    // Enables the Control Strip in System Preferences
    static func enableControlStrip() {
        let setupControlStripScript = """
        tell application "System Preferences"
            activate\n
            reveal anchor "keyboardTab" of pane id "com.apple.preference.keyboard"\n\
        end tell\n\
        delay 0.5
        tell application "System Events" to tell process "System Preferences"\n\
            tell pop up button 2 of tab group 1 of window 1\n\
                click\n\
                click menu item "App Controls with Control Strip" of menu 1\n\
            end tell\n\
        end tell
        tell application "OSRS-touch-bar" to activate
        """
        
        ScriptExecutor.runScriptShowingErrors(sourceString: setupControlStripScript)
    }
    
    /*  Displays the Control Strip settings so the user can go back to their
     previous settings. Unfortunately, it seems that AppleScript has no way to
     get the currently-selected menu item, meaning the script can't
     automatically revert to the user's previous settings. */
    static func showTouchBarSettings() {
        let disableControlStripScript = """
        tell application "System Preferences"
            activate\n
            reveal anchor "keyboardTab" of pane id "com.apple.preference.keyboard"\n\
        end tell\n\
        delay 0.5
        tell application "System Events" to tell process "System Preferences"\n\
            tell pop up button 2 of tab group 1 of window 1\n\
                click\n\
            end tell\n\
        end tell
        """
        
        ScriptExecutor.runScriptShowingErrors(sourceString: disableControlStripScript)
    }
}
