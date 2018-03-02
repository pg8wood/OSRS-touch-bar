//
//  ViewController.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 2/24/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTouchBarDelegate {
    
    @IBOutlet var touchBarOutlet: NSTouchBar!
    @IBOutlet var combatOptionsButton: NSButton!
    @IBOutlet var skillsButton: NSButton!
    @IBOutlet var questButton: NSButton!
    @IBOutlet var inventoryButton: NSButton!
    @IBOutlet var equipmentButton: NSButton!
    @IBOutlet var prayerButton: NSButton!
    @IBOutlet var spellbookButton: NSButton!
    @IBOutlet var clanChatButton: NSButton!
    @IBOutlet var friendsListButton: NSButton!
    @IBOutlet var ignoreListButton: NSButton!
    @IBOutlet var optionsButton: NSButton!
    @IBOutlet var emoteButton: NSButton!
    @IBOutlet var musicButton: NSButton!
    @IBOutlet weak var hintLabel: NSTextField!
    
    let osrsInterfaceIdentifiers: [NSTouchBarItem.Identifier] = [.combatOptionsLabelItem, .statsLabelItem, .questListLabelItem, .inventoryLabelItem, .equipmentLabelItem, .prayerLabelItem, .spellbookLabelItem, .clanChatLabelItem, .friendsListLabelItem, .ignoreListLabelItem, .optionsLabelItem, .emotesLabelItem, .musicPlayerLabelItem]
    
    var keyCodeDict: [NSButton: UInt16]?
    
    var touchBarIsExpanded = false

    
    // MARK: - View life cycle
    
    // Map Touch Bar buttons to function buttons
    override func viewDidLoad() {
        keyCodeDict = [combatOptionsButton: KeyCodes.F1KeyCode,
                    skillsButton: KeyCodes.F2KeyCode,
                    questButton: KeyCodes.F3KeyCode,
                    equipmentButton: KeyCodes.F4KeyCode,
                    inventoryButton: KeyCodes.ESCKeyCode,
                    prayerButton: KeyCodes.F5KeyCode,
                    spellbookButton: KeyCodes.F6KeyCode,
                    clanChatButton: KeyCodes.F7KeyCode,
                    friendsListButton: KeyCodes.F8KeyCode,
                    ignoreListButton: KeyCodes.F9KeyCode,
                    optionsButton: KeyCodes.F10KeyCode,
                    emoteButton: KeyCodes.F11KeyCode,
                    musicButton: KeyCodes.F12KeyCode]
        
        // Set up the Control Strip
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
        touchBarIsExpanded = false
        
        ScriptExecutor.runScriptShowingErrors(sourceString: setupControlStripScript)
        
        // TODO make this look good and actually make sense. I wish we could just listen for when the big touch bar button is pressed :(
        hintLabel.stringValue = "Press the OSRS button and any other button to enable the touch bar"
    }
    
    /*  Displays the Control Strip settings so the user can go back to their previous settings.
        Unfortunately, it seems that AppleScript has no way to get the currently-selected menu
        item, meaning the script can't automatically revert to the user's previous settings. */
    override func viewWillDisappear() {
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
        touchBarIsExpanded = false
        
        ScriptExecutor.runScriptShowingErrors(sourceString: disableControlStripScript)
    }

    // Detects a Touch Bar button press and sends the corresponding function key press event
    @IBAction func buttonPressed(sender: NSButton) {
        guard let keyCode: UInt16 = keyCodeDict?[sender] else {
                return
        }
        
        if !touchBarIsExpanded {
            expandTouchBar()
            touchBarIsExpanded = true
        }
        
        // Sends a system-wide function key press
        ScriptExecutor.runScriptShowingErrors(sourceString: "tell application \"System Events\" to key code \(keyCode)")
    }
    
    func expandTouchBar() {
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
    
     // MARK: - Touch Bar delegate
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        return touchBarOutlet
    }
}




