//
//  CustomTouchBarItem
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 9/16/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import AppKit

let touchBarItemDict: Dictionary<NSTouchBarItem.Identifier,(imageName: String, KeyCode: UInt16)> = [NSTouchBarItem.Identifier.combatOptionsLabelItem:("Combat_Options", KeyCodes.F1KeyCode)]


class CustomTouchBarItem: NSCustomTouchBarItem {
    
    let keyCode: UInt16!
    
    override init(identifier: NSTouchBarItem.Identifier) {
        let touchBarItemData = touchBarItemDict[identifier]!
        
        keyCode = touchBarItemData.KeyCode
        super.init(identifier: identifier)

        view = NSButton(image: NSImage(named: NSImage.Name(rawValue: touchBarItemData.imageName))!, target: self, action: #selector(buttonPressed(sender:)))
    }
    
    required init?(coder: NSCoder) {
        self.keyCode = 0
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
