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
     - parameter args: Arguments to pass to the executable
     
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
            
            // Hide the Control Strip
            if let hideScriptPath = Bundle.main.path(forResource: "hideControlStrip", ofType: "sh") {
                shell(hideScriptPath, [])
            }
        }
    }
    
    /**
     Restores the Control Strip. Uses a small Python script since Swift's Process
     class is barred from managing user defaults, but at the same time Apple recommends
     using the `defaults` utility for System Preferences rather than the NSUserDefaults
     class ¯\_(ツ)_/¯
    */
    @objc static func restoreControlStrip() {
        if  let controlStripPrefs = controlStripPreferences,
            let scriptPath = Bundle.main.path(forResource: "restoreControlStrip", ofType: "py") {
            
            /*
             `defaults read` prints the defaults with double quotes, but `defaults write`
             doesn't accept double quotes. So, strip them off and create a nice one line
             String that `defaults write` will accept
             */
            let strippedPrefsString = controlStripPrefs.replacingOccurrences(of: "\n", with: " ").replacingOccurrences(of: "\"", with: "")
            
            // `defaults write` also requires the defaults to be single quoted
            let finalPrefsString: String = "' \(strippedPrefsString) '"
            
            // Run the script
            shell(scriptPath, [finalPrefsString])
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
