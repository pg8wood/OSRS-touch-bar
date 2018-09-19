//
//  ViewController.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 2/24/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var settingsButton: NSButton!
    @IBOutlet weak var reloadButton: NSButton!
    @IBOutlet weak var customizeButton: NSButton!
    
    let controlStripIconIdentifier = NSTouchBarItem.Identifier(rawValue: "com.patrickgatewood.osrs-logo")
    
    var userDefaultsObserver: NSKeyValueObservation?
    
    // -----------------------
    // MARK: - View life cycle
    // -----------------------
    
    override func viewDidLoad() {
        setupMenuButtons()
        
        UserDefaults.standard.addObserver(self, forKeyPath: TouchBarConstants.userDefaultsTouchBarIdentifier, options: NSKeyValueObservingOptions.new, context: nil)
        
        NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
    }
    
    /**
     Hide the Control Strip and set up the global Touch Bar
     */
    override func viewDidAppear() {
        ScriptRunner.hideControlStrip()
        
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)
        DFRElementSetControlStripPresenceForIdentifier(self.controlStripIconIdentifier, true)

        presentModalTouchBar(self.touchBar)
    }
    
    func presentModalTouchBar(_ touchBar: NSTouchBar?) {
        if #available(macOS 10.14, *) {
            NSTouchBar.presentSystemModalTouchBar(touchBar, systemTrayItemIdentifier: self.controlStripIconIdentifier)
        } else {
            NSTouchBar.presentSystemModalFunctionBar(touchBar, systemTrayItemIdentifier: self.controlStripIconIdentifier)
        }
    }
    
    /**
     Adds attributes to the buttons in the App View
     */
    func setupMenuButtons() {
        let appButtons = [settingsButton, reloadButton, customizeButton]
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
        presentModalTouchBar(touchBar)
        
        print(UserDefaults.standard.osrsTouchBarConfig)
        print("current items: \(UserDefaults.standard.osrsTouchBarCurrentItems)")
    }
    
    /**
     Shows the Touch Bar customization view
     
     - parameter sender: The NSButton clicked
     */
    @IBAction func customizeButtonClicked(_ sender: NSButton) {
        // Note that any changes here are represented in UserDefaults. The NSTouchBar object is NOT changed.
        NSApplication.shared.toggleTouchBarCustomizationPalette(touchBar)
    }
    
    /**
     Observe change to UserDefaults
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
       
    }

}

extension ViewController: NSTouchBarDelegate {
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        print("making touch bar")
        
        touchBar.delegate = self
        touchBar.customizationIdentifier = NSTouchBar.CustomizationIdentifier(rawValue: TouchBarConstants.touchBarCustomizationIdentifierExtension)
        
        touchBar.defaultItemIdentifiers = TouchBarConstants.TouchBarIdentifier.allCases.filter{
            $0 != .inventoryLabelItem // most people use ESC for inventory
            }.map({
                NSTouchBarItem.Identifier(rawValue: $0.rawValue)
            })
        touchBar.customizationAllowedItemIdentifiers = touchBar.defaultItemIdentifiers
        touchBar.principalItemIdentifier = touchBar.defaultItemIdentifiers.first
        
//        touchBar.observe(\NSTouchBar) { (touchBar, change) in
//            print("Detected Touch Bar change!!!"
//            )
//        }
        
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        guard let touchBarItemData = TouchBarConstants.touchBarItemDict[identifier.rawValue] else {
            return nil
        }
        
        return CustomTouchBarItem(identifier: identifier, name: touchBarItemData.name, keyCode: touchBarItemData.keyCode)
    }
}
