//
//  ViewController.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 2/24/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var touchBarOutlet: NSTouchBar!
    @IBOutlet var combatOptionsButton: NSButton!
    @IBOutlet var skillsButton: NSButton!
    @IBOutlet var questButton: NSButton!
    @IBOutlet var equipmentButton: NSButton!
    @IBOutlet var prayerButton: NSButton!
    @IBOutlet var spellbookButton: NSButton!
    @IBOutlet var clanChatButton: NSButton!
    @IBOutlet var friendsListButton: NSButton!
    @IBOutlet var ignoreListButton: NSButton!
    @IBOutlet var optionsButton: NSButton!
    @IBOutlet var emoteButton: NSButton!
    @IBOutlet var musicButton: NSButton!
    
    let osrsInterfaceIdentifiers: [NSTouchBarItem.Identifier] = [.combatOptionsLabelItem, .statsLabelItem, .questListLabelItem, .inventoryLabelItem, .equipmentLabelItem, .prayerLabelItem, .spellbookLabelItem, .clanChatLabelItem, .friendsListLabelItem, .ignoreListLabelItem, .optionsLabelItem, .emotesLabelItem, .musicPlayerLabelItem]
    
    var keyCodeDict: [NSButton: UInt16]?

    
    // MARK: - View life cycle
    
    // Map Touch Bar buttons to function buttons
    override func viewDidLoad() {
        keyCodeDict = [combatOptionsButton: KeyCodes.F1KeyCode,
                    skillsButton: KeyCodes.F2KeyCode,
                    questButton: KeyCodes.F3KeyCode,
                    equipmentButton: KeyCodes.F4KeyCode,
                    prayerButton: KeyCodes.F5KeyCode,
                    spellbookButton: KeyCodes.F6KeyCode,
                    clanChatButton: KeyCodes.F7KeyCode,
                    friendsListButton: KeyCodes.F8KeyCode,
                    ignoreListButton: KeyCodes.F9KeyCode,
                    optionsButton: KeyCodes.F10KeyCode,
                    emoteButton: KeyCodes.F11KeyCode,
                    musicButton: KeyCodes.F12KeyCode,]
    }

    // Detects a Touch Bar button press and sends the corresponding function key press event
    @IBAction func buttonPressed(sender: NSButton) {
        var scriptError: NSDictionary?
        guard let keyCode: UInt16 = keyCodeDict?[sender] else {
                return
        }
        
        // Sends a system-wide function key press
        let keycodeScriptSource = """
        tell application "System Events" to key code \(keyCode)
        """
        
        if let script = NSAppleScript(source: keycodeScriptSource) {
            script.executeAndReturnError(&scriptError)
        }
        
        if scriptError != nil {
            let alert = NSAlert()
            alert.informativeText = "\(String(describing: scriptError!.allValues))"
            alert.runModal()
        }
    }
}

 // MARK: - Touch Bar delegate

@available(OSX 10.12.1, *)
extension ViewController: NSTouchBarDelegate {
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        return touchBarOutlet
    }
    
}

