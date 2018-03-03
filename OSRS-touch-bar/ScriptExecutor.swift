//
//  ScriptExecutor.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 3/1/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Cocoa

@objc class ScriptExecutor: NSObject {
    
    // Executes an AppleScript from a source string and displays any errors in
    // an NSAlert.
    @objc public static func runScriptShowingErrors(sourceString: String) {
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
