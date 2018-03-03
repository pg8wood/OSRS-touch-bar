//
//  TouchBarScriptRunner.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 3/3/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Foundation

@objc class TouchBarScriptRunner: NSObject {
    
    @objc public static func expandTouchBar() {
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
}
