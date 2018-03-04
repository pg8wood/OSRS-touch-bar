//
//  ViewController.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 2/24/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTouchBarDelegate {
    
    // Touch Bar View
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
    
    // Main View
    @IBOutlet weak var hintLabel: NSTextField!
    
    // App View
    @IBOutlet weak var settingsButton: NSButton!
    @IBOutlet weak var reloadButton: NSButton!
    @IBOutlet weak var quitButton: NSButton!
    
    let osrsInterfaceIdentifiers: [NSTouchBarItem.Identifier] =
        [.combatOptionsLabelItem, .statsLabelItem, .questListLabelItem,
        .inventoryLabelItem, .equipmentLabelItem, .prayerLabelItem,
        .spellbookLabelItem, .clanChatLabelItem, .friendsListLabelItem,
        .ignoreListLabelItem, .optionsLabelItem, .emotesLabelItem, 
        .musicPlayerLabelItem]
    
    // Mapping of Touch Bar buttons to their respective KeyCodes
    var keyCodeDict: [NSButton: UInt16]?
    
    // -----------------------
    // MARK: - View life cycle
    // -----------------------
    
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
        
        setupMenuButtons()
    }
   
    
    // Adds attributes to the buttons in the App View
    func setupMenuButtons() {
        let appButtons = [settingsButton, reloadButton, quitButton]
        let buttonFontColor: NSColor = NSColor(red: 255.0/255.0, green: 152.0/255.0, blue: 0, alpha: 1)
        
        for button in appButtons {
            if let mutableAttributedTitle = button?.attributedTitle.mutableCopy() as? NSMutableAttributedString {
                mutableAttributedTitle.addAttribute(.foregroundColor, value: buttonFontColor, range: NSRange(location: 0, length: mutableAttributedTitle.length))
                button?.attributedTitle = mutableAttributedTitle
            }
        }
    }
    
    @IBAction func settingsButtonClicked(_ sender: NSButton) {
        TouchBarScriptRunner.showTouchBarSettings()
    }
    
    @IBAction func reloadButtonClicked(_ sender: NSButton) {
        let appDelegate = NSApplication.shared.delegate! as! AppDelegate
        appDelegate.present(self);
    }
    
    @IBAction func quitButtonClicked(_ sender: Any) {
        TouchBarScriptRunner.showTouchBarSettings()
        exit(0)
    }

    // Detects a Touch Bar button press and sends the corresponding function key press event
    @IBAction func buttonPressed(sender: NSButton) {
        guard let keyCode: UInt16 = keyCodeDict?[sender] else {
                return
        }
        
        // Sends a system-wide function key press
        ScriptExecutor.runScriptShowingErrors(sourceString: "tell application \"System Events\" to key code \(keyCode)")
    }
    
    // ---------------------------
    // MARK: - Touch Bar delegate
    // ---------------------------
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        return touchBarOutlet
    }
}
