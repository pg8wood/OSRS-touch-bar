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
    
    // Records the user's Control Strip preferences
    static var controlStripPreferences: String? = nil
    
    /**
     Runs a subprocess and returns its output
     
     - parameter launchPath: The executable to run
     - parameter args: Argument(s) to pass to the executable
     
     - returns: An optional String with contents of the process' standard output
    */
    @discardableResult
    static func shell(_ launchPath: String, _ args: [String]) -> String? {
        let process = Process()
        process.launchPath = launchPath
        process.arguments = args
        
        // Capture the process' output
        let pipe = Pipe()
        process.standardOutput = pipe
        
        // Run the process
        process.launch()
        process.waitUntilExit()
        
        if let output = String(data: pipe.fileHandleForReading.readDataToEndOfFile(),  encoding: String.Encoding.utf8) {
            return output
        }
        return nil
    }

    /**
     Records the user's Control Strip preferences and hides the Control Strip
    */
    @objc static func hideControlStrip() {
        if let recordScriptPath = Bundle.main.path(forResource: "recordControlStripPrefs", ofType: "sh") {
            // Record the Control Strip preferences only on first call
            if controlStripPreferences == nil {
                controlStripPreferences = shell(recordScriptPath, [])
            }
            print(controlStripPreferences!)
            
            // Hide the Control Strip
            if let hideScriptPath = Bundle.main.path(forResource: "hideControlStrip", ofType: "sh") {
                shell(hideScriptPath, [])
            }
        }
    }
    
    /**
     Restores the Control Strip
    */
    @objc static func restoreControlStrip() {
        /*
         Python's file I/O is much simpler here, and Apple recommends using
         the `defaults` utility for System Preferences rather than NSUserDefaults.
         */
//        if let scriptPath = Bundle.main.path(forResource: "restoreControlStrip", ofType: "py") {
//            shell(scriptPath)
//        }
        
        if  let controlStripPrefs = controlStripPreferences,
            let scriptPath = Bundle.main.path(forResource: "restoreControlStrip", ofType: "py") {
            // String format required for writing to defaults
            let prefsString: String = "' \(controlStripPrefs.replacingOccurrences(of: "\n", with: " ").replacingOccurrences(of: "\"", with: "")) '"
            print(prefsString)
//            print("/usr/bin/defaults", "write", "~/Library/Preferences/com.apple.controlstrip", "MiniCustomized", prefsString)
//            print(shell("/usr/bin/defaults", ["write", "~/Library/Preferences/com.apple.controlstrip", "MiniCustomized", prefsString]))
//            print(shell("/usr/bin/killall", ["ControlStrip"]))
            shell(scriptPath, [prefsString])
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
