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
    var fitButtonsToTouchBar = false
    
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
        
        if fitButtonsToTouchBar {
            fitButtonsToTouchBarScreenSize()
        }
    }
    
    private func presentModalTouchBar(_ touchBar: NSTouchBar?) {
        if #available(macOS 10.14, *) {
            NSTouchBar.presentSystemModalTouchBar(touchBar, systemTrayItemIdentifier: self.controlStripIconIdentifier)
        } else {
            NSTouchBar.presentSystemModalFunctionBar(touchBar, systemTrayItemIdentifier: self.controlStripIconIdentifier)
        }
    }
    
    private func fitButtonsToTouchBarScreenSize() {
        guard let identifiers = touchBar?.itemIdentifiers else {
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
     Shows the Touch Bar customization view
     
     - parameter sender: The NSButton clicked
     */
    @IBAction func customizeButtonClicked(_ sender: NSButton) {
        /* Note that any changes made by the user in this view are represented in UserDefaults.
         The NSTouchBar object is NOT changed. */
        NSApplication.shared.toggleTouchBarCustomizationPalette(touchBar)
    }
    
    /**
     Toggles whether the Touch Bar buttons fill the screen size
     
     - parameter sender: The NSButton clicked
     */
    @IBAction func fitButtonClicked(_ sender: NSButton) {
        fitButtonsToTouchBar = !fitButtonsToTouchBar
        
        if fitButtonsToTouchBar {
            fitButtonsToTouchBarScreenSize()
        }
        
        presentModalTouchBar(fitButtonsToTouchBar ? touchBar : makeTouchBar())
        
        sender.image = fitButtonsToTouchBar ? #imageLiteral(resourceName: "Radio_On") : #imageLiteral(resourceName: "Radio_Off")
    }
    
    /**
     Called when an observed KeyPath's value is changed
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        /* Need to re-present the system-wide modal touchbar due to some limitation in the undocumented
         DFRFoundationFramework. I believe it copies a Touch Bar under the hood or something, since
         changes to the "local" touch bar aren't reflected until presentSystemModalTouchBar() is called again. */
        
        // When you don't want to reset the button sizes, just call the below line and delete everything else
        // presentModalTouchBar(makeTouchBar())
        
        
        // TODO: Size buttons on load. Get buttons the right size (slightly off now [see default set]). See if you can allow 13 buttons on the screen. See if you can override esc key with not-an-x. Consider allowing an easier resizing scheme: i.e. a view with a slider.
        
        touchBar = makeTouchBar()
       
        if fitButtonsToTouchBar {
            fitButtonsToTouchBarScreenSize()
        }
        
        presentModalTouchBar(touchBar)
    }
    
    
}

extension ViewController: NSTouchBarDelegate {
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        
        touchBar.delegate = self
        touchBar.customizationIdentifier = NSTouchBar.CustomizationIdentifier(rawValue: TouchBarConstants.touchBarCustomizationIdentifierExtension)
        
        touchBar.defaultItemIdentifiers = TouchBarConstants.TouchBarIdentifier.allCases.filter{
            $0 != .inventoryLabelItem // most people use ESC for inventory
            }.map({
                NSTouchBarItem.Identifier(rawValue: $0.rawValue)
            })
        
        touchBar.customizationAllowedItemIdentifiers = TouchBarConstants.TouchBarIdentifier.allCases.map({
            NSTouchBarItem.Identifier(rawValue: $0.rawValue)
        })
        touchBar.principalItemIdentifier = touchBar.defaultItemIdentifiers.first
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        guard let touchBarItemData = TouchBarConstants.touchBarItemDict[identifier.rawValue] else {
            return nil
        }
        
        return CustomTouchBarItem(identifier: identifier, name: touchBarItemData.name, keyCode: touchBarItemData.keyCode)
    }
}
