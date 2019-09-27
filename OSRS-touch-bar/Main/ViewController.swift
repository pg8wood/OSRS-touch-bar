//
//  ViewController.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 2/24/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var controlStripButton: NSButton!
    @IBOutlet weak var customizeButton: NSButton!
    @IBOutlet weak var fitButton: NSButton!
    
    let controlStripIconIdentifier = NSTouchBarItem.Identifier(rawValue: "com.patrickgatewood.osrs-logo")
    
    var userDefaultsObserver: NSKeyValueObservation?
    
    // -----------------------
    // MARK: - View life cycle
    // -----------------------
    
    override func viewDidLoad() {
        setupMenuButtons()
        
        UserDefaults.standard.addObserver(self, forKeyPath: TouchBarConstants.userDefaultsTouchBarIdentifier, options: NSKeyValueObservingOptions.new, context: nil)
        
        if Persistence.controlStripEnabled {
            controlStripButton.state = .on
            controlStripButton.image = #imageLiteral(resourceName: "Radio_On")
            setNSButtonTitle(button: controlStripButton, to: "  Control Strip (on)")
        } else {
            ScriptRunner.hideControlStrip()
        }
        
        if Persistence.buttonsFillControlStrip {
            fitButton.image = #imageLiteral(resourceName: "Radio_On")
            fitButtonsToTouchBarScreenSize()
        }

        NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
    }
    
    /**
     Hide the Control Strip and set up the global Touch Bar
     */
    override func viewDidAppear() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)
        DFRElementSetControlStripPresenceForIdentifier(self.controlStripIconIdentifier, true)

        presentModalTouchBar(self.touchBar)
    }
    
    override func viewWillDisappear() {
        Persistence.persistSettings()
    }
    
    private func presentModalTouchBar(_ touchBar: NSTouchBar?) {
        if #available(macOS 10.14, *) {
            NSTouchBar.presentSystemModalTouchBar(touchBar, systemTrayItemIdentifier: self.controlStripIconIdentifier)
        } else {
            NSTouchBar.presentSystemModalFunctionBar(touchBar, systemTrayItemIdentifier: self.controlStripIconIdentifier)
        }
    }
    
    private func fitButtonsToTouchBarScreenSize() {
        /**
         For some reason, part of the Touch Bar API handles a "full" (12-button) Touch Bar's layout
         differently than a Touch Bar with fewer items. This hack is necessary due to that.
         */
        guard let identifiers = touchBar?.itemIdentifiers, identifiers.count < 12 else {
            return
        }
        
        identifiers.compactMap({touchBar?.item(forIdentifier: $0) as? CustomTouchBarItem}).forEach{ item in
            item.updateButtonSize(numItems: identifiers.count)
        }
    }
    
    /**
     Adds attributes to the buttons in the App View
     */
    private func setupMenuButtons() {
        let appButtons: [NSButton] = [controlStripButton, fitButton, customizeButton]
        let buttonFont = NSFont(name: "Runescape-Chat-Font", size: 19)
        let buttonFontColor: NSColor = NSColor(red: 255.0/255.0, green: 152.0/255.0, blue: 0, alpha: 1)
        
        // Style each button
        for button in appButtons {
            guard let buttonTitle = button.attributedTitle.mutableCopy() as? NSMutableAttributedString else {
                    continue
            }
            
            buttonTitle.addAttribute(.foregroundColor, value: buttonFontColor, range: NSRange(location: 0, length: buttonTitle.length))
            button.attributedTitle = buttonTitle
            button.font = buttonFont
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
            Persistence.controlStripEnabled = true
            sender.image = #imageLiteral(resourceName: "Radio_On")
            setNSButtonTitle(button: sender, to: "  Control Strip (on)")

            ScriptRunner.restoreControlStrip()
        } else {
            Persistence.controlStripEnabled = false
            sender.image = #imageLiteral(resourceName: "Radio_Off")
            setNSButtonTitle(button: sender, to: "  Control Strip (off)")
            
            ScriptRunner.hideControlStrip()
        }
    }
    
    /**
     Updates a button's text, preserving the text styles
     */
    func setNSButtonTitle(button: NSButton, to title: String) {
        if let mutableAttributedTitle: NSMutableAttributedString = button.attributedTitle.mutableCopy() as? NSMutableAttributedString {
            mutableAttributedTitle.mutableString.setString(title)
            button.attributedTitle = mutableAttributedTitle
        }
    }
    
    /**
     Shows the Touch Bar customization view
     
     - parameter sender: The NSButton clicked
     */
    @IBAction func customizeButtonClicked(_ sender: NSButton) {
        /* Note that any changes made by the user in this view are represented in UserDefaults.
         The NSTouchBar object is NOT changed. Must use KVO to detect changes to the Touch Bar config. */
        NSApplication.shared.toggleTouchBarCustomizationPalette(touchBar)
    }
    
    /**
     Toggles whether the Touch Bar buttons fill the screen size
     
     - parameter sender: The NSButton clicked
     */
    @IBAction func fitButtonClicked(_ sender: NSButton) {
        Persistence.buttonsFillControlStrip = !Persistence.buttonsFillControlStrip
        
        if Persistence.buttonsFillControlStrip {
            fitButtonsToTouchBarScreenSize()
            presentModalTouchBar(touchBar)
            sender.image = #imageLiteral(resourceName: "Radio_On")
        } else {
            presentModalTouchBar(makeTouchBar())
            sender.image = #imageLiteral(resourceName: "Radio_Off")
        }
    }
    
    /**
     Called when an observed KeyPath's value is changed
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        /* Need to re-present the system-wide modal touchbar due to some limitation in the undocumented
         DFRFoundationFramework. I believe it copies a Touch Bar under the hood, since changes to the "local"
         touch bar aren't reflected until presentSystemModalTouchBar() is called again. */
        touchBar = makeTouchBar()
        presentModalTouchBar(touchBar)
       
        if Persistence.buttonsFillControlStrip {
            fitButtonsToTouchBarScreenSize()
        }
    }
}

extension ViewController: NSTouchBarDelegate {
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        
        touchBar.delegate = self
        touchBar.customizationIdentifier = TouchBarConstants.touchBarCustomizationIdentifierExtension
        
        touchBar.defaultItemIdentifiers = TouchBarConstants.TouchBarIdentifier.allCases.filter {
            $0 != .inventoryLabelItem // most people use ESC for inventory
            }.map({
                NSTouchBarItem.Identifier(rawValue: $0.rawValue)
            })
        
        touchBar.customizationAllowedItemIdentifiers = TouchBarConstants.TouchBarIdentifier.allCases.map({
            NSTouchBarItem.Identifier(rawValue: $0.rawValue)
        })
        
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        guard let touchBarItemData = TouchBarConstants.touchBarItemDict[identifier.rawValue] else {
            return nil
        }
        
        return CustomTouchBarItem(identifier: identifier, name: touchBarItemData.name, keyCode: touchBarItemData.keyCode)
    }
}
