//
//  ScriptRunner.swift
//  OSRS-touch-bar
//
//  Runs various AppleScripts that modify Touch Bar settings in System Preferences
//
//  Created by Patrick Gatewood on 3/3/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Foundation

@objc class ScriptRunner: NSObject {
    
    /**
     Executes a shell process and discards the result
     
     - parameter args: Argument(s) to pass to the process
    */
    static func shell(_ args: String...) {
        let task = Process()
        task.launchPath = "/usr/bin/env/"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
    }

    /**
     Records the user's Control Strip preferences and hides the Control Strip
    */
    @objc static func hideControlStrip() {
        if let recordScriptPath = Bundle.main.path(forResource: "recordControlStripPrefs", ofType: "sh") {
            shell(recordScriptPath)
    
            if let hideScriptPath = Bundle.main.path(forResource: "hideControlStrip", ofType: "sh") {
                shell(hideScriptPath)
            }
        }
    }
    
    /**
     Restores the Control Strip
    */
    @objc static func restoreControlStrip() {
        if let scriptPath = Bundle.main.path(forResource: "restoreControlStrip", ofType: "py") {
            shell(scriptPath)
        }
    }
    
    /**
     Executes an AppleScript from a source string and displays any errors inan NSAlert.
     
     - parameter sourceString: The AppleScript to execute
    */
    @objc static func runAppleScriptShowingErrors(sourceString: String) {
        var scriptError: NSDictionary?
        
        if let script = NSAppleScript(source: sourceString) {
            script.executeAndReturnError(&scriptError)
        }
        
        if scriptError != nil {
            let alert = NSAlert()
            alert.informativeText = "\(String(describing: scriptError!.allValues))"
            alert.runModal()
        }
    }
}
