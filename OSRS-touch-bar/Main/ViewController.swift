//
//  ViewController.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 2/24/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
//    @IBOutlet weak var combatOptions: NSTouchBarItem!
//    @IBOutlet weak var skills: NSTouchBarItem!
//    @IBOutlet weak var quests: NSTouchBarItem!
//
//    // Touch Bar View
//    @IBOutlet var combatOptionsButton: NSButton!
//    @IBOutlet var skillsButton: NSButton!
//    @IBOutlet var questButton: NSButton!
//    @IBOutlet var equipmentButton: NSButton!
//    @IBOutlet var prayerButton: NSButton!
//    @IBOutlet var spellbookButton: NSButton!
//    @IBOutlet var clanChatButton: NSButton!
//    @IBOutlet var friendsListButton: NSButton!
//    @IBOutlet var ignoreListButton: NSButton!
//    @IBOutlet var optionsButton: NSButton!
//    @IBOutlet var emoteButton: NSButton!
//    @IBOutlet var musicButton: NSButton!
    
    // App View
    @IBOutlet weak var settingsButton: NSButton!
    @IBOutlet weak var reloadButton: NSButton!
    @IBOutlet weak var quitButton: NSButton!

    // Mapping of Touch Bar buttons to their respective KeyCodes
    var keyCodeDict: [NSButton: UInt16]!
    
    // -----------------------
    // MARK: - View life cycle
    // -----------------------
    
    /**
     Maps Touch Bar buttons to their KeyCodes
     and sets up the app menu buttons
     */
    override func viewDidLoad() {
//        keyCodeDict = [combatOptionsButton: KeyCodes.F1KeyCode,
//                    skillsButton: KeyCodes.F2KeyCode,
//                    questButton: KeyCodes.F3KeyCode,
//                    equipmentButton: KeyCodes.F4KeyCode,
//                    prayerButton: KeyCodes.F5KeyCode,
//                    spellbookButton: KeyCodes.F6KeyCode,
//                    clanChatButton: KeyCodes.F7KeyCode,
//                    friendsListButton: KeyCodes.F8KeyCode,
//                    ignoreListButton: KeyCodes.F9KeyCode,
//                    optionsButton: KeyCodes.F10KeyCode,
//                    emoteButton: KeyCodes.F11KeyCode,
//                    musicButton: KeyCodes.F12KeyCode]
        
        setupMenuButtons()
        

        NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
    }
    
    override func makeTouchBar() -> NSTouchBar? {
        let osrsTouchBar = NSTouchBar()
        osrsTouchBar.delegate = self
        osrsTouchBar.customizationIdentifier = NSTouchBar.CustomizationIdentifier(rawValue: "test")
        osrsTouchBar.defaultItemIdentifiers = [.combatOptionsLabelItem]
        osrsTouchBar.customizationAllowedItemIdentifiers = [.combatOptionsLabelItem]
        osrsTouchBar.principalItemIdentifier = .combatOptionsLabelItem
        return osrsTouchBar
    }
    
   
    
    override func viewDidAppear() {
    }
    
//    @IBAction func toggleTouchBarCustomizationPalette(_ sender: Any?) {
//        print("clicked")
//    }
    
    /**
     Adds attributes to the buttons in the App View
    */
    func setupMenuButtons() {
        let appButtons = [settingsButton, reloadButton, quitButton]
        let buttonFontColor: NSColor = NSColor(red: 255.0/255.0, green: 152.0/255.0, blue: 0, alpha: 1)
        
        // Style each button
        for menuButton in appButtons {
            guard let button = menuButton,
                let buttonTitle = button.attributedTitle.mutableCopy() as? NSMutableAttributedString else {
                    continue
            }
            
            buttonTitle.addAttribute(.foregroundColor, value: buttonFontColor, range: NSRange(location: 0, length: buttonTitle.length))
            button.attributedTitle = buttonTitle
            
            button.font = NSFont(name: "Runescape-Chat-Font", size: 19)
        }
    }
    
    func touchesMoved() {
        
    }
    
    // ----------------------
    // MARK: - Action methods
    // ----------------------
    
    /**
     Toggles the Control Strip (if applicable) and updates the
     button's state
     
     - parameter sender: The NSButton clicked
    */
    @IBAction func controlStripButtonClicked(_ sender: NSButton) {
        if (sender.state == .on) {
            sender.image = #imageLiteral(resourceName: "Radio_On")
            if let mutableAttributedTitle: NSMutableAttributedString = sender.attributedTitle.mutableCopy() as? NSMutableAttributedString {
                mutableAttributedTitle.mutableString.setString("  Control Strip (on)")
                sender.attributedTitle = mutableAttributedTitle
            }
            ScriptRunner.restoreControlStrip()
        } else {
            sender.image = #imageLiteral(resourceName: "Radio_Off")
            if let mutableAttributedTitle: NSMutableAttributedString = sender.attributedTitle.mutableCopy() as? NSMutableAttributedString {
                mutableAttributedTitle.mutableString.setString("  Control Strip (off)")
                sender.attributedTitle = mutableAttributedTitle
            }
            ScriptRunner.hideControlStrip()
        }
    }
    
    /**
     Reloads the global Touch Bar
     
     - parameter sender: The NSButton clicked
    */
    @IBAction func reloadButtonClicked(_ sender: NSButton) {
        let appDelegate = NSApplication.shared.delegate as? AppDelegate
        appDelegate?.present(self)
    }
    
    /**
     Restores the user's Control Strip preferences and quits the app
     
     - parameter sender: The NSButton clicked
    */
    @IBAction func quitButtonClicked(_ sender: NSButton) {
//        for button in keyCodeDict.keys {
//            let imageView = button.animator().subviews[1] // probably bad
//            let animation = CAKeyframeAnimation()
//
//            animation.beginTime = CACurrentMediaTime() + CFTimeInterval.random(in: 0...0.15)
//            animation.keyPath = "position.x"
//            animation.values = Bool.random() ? [0, 1, 0, -1, 0] : [0, -1, 0, 1, 0]
//            animation.calculationMode = "paced"
//            animation.duration = 0.5
//            animation.isAdditive = true
//            animation.repeatCount = Float.infinity
//
//            imageView.layer?.add(animation, forKey: "shake")
//        }
        
//        osrsTouchBar.customizationIdentifier = NSTouchBar.CustomizationIdentifier(rawValue: "test")
        NSApplication.shared.toggleTouchBarCustomizationPalette(self)
        
        // TODO the other app is capable of this

        
    }
}

extension ViewController: NSTouchBarDelegate {
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        return CustomTouchBarItem(identifier: identifier)
    }
}
