//
//  CustomTouchBarItem
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 9/16/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import AppKit

class CustomTouchBarItem: NSCustomTouchBarItem {
    
    let name: String! // MUST match both interface name AND interface image name!
    let keyCode: UInt16!
    
    init(identifier: NSTouchBarItem.Identifier, name: String, keyCode: UInt16) {
        self.name = name
        self.keyCode = keyCode
        
        super.init(identifier: identifier)
        
        view = NSButton(image: NSImage(named: NSImage.Name(rawValue: name))!, target: self, action: #selector(buttonPressed(sender:)))
        customizationLabel = name
    }
    
    required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: "name") as? String
        self.keyCode = coder.decodeObject(forKey: "keyCode") as? UInt16
        super.init(coder: coder)
    }
    
    /**
     Detects a Touch Bar button press and sends the corresponding function key press event
     
     - parameter sender: The NSButton clicked
     */
    @IBAction func buttonPressed(sender: NSButton) {
        /*  Sends a system-wide function key press and negates arrow keypresses to
         prevent the camera getting stuck in a pan */
        ScriptRunner.runAppleScriptShowingErrors(sourceString: """
            tell application \"System Events\"
            key code \(keyCode!)\n\
            end tell
            """)
    }
}
