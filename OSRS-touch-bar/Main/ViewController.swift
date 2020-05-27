//
//  ViewController.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 2/24/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Cocoa
import Swifter

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

        presentModalTouchBar()
        
        // TODO: obviously move outta the vc
        
        let server = HttpServer()
        server["/hello"] = { .ok(.htmlBody("You asked for \($0)"))  }
        server["/killtouchbar"] = { request in
            DispatchQueue.main.async { [weak self] in
                // TODO: - add availability check to runelite plugin if possible
                if #available(OSX 10.14, *) {
                    NSTouchBar.dismissSystemModalTouchBar(TouchBarManager.shared.touchBar)
                    TouchBarManager.shared.touchBar = nil
                } else {
                    // Fallback on earlier versions
                }
            }
            return HttpResponse.ok(.htmlBody("1-tick AGS spec-ing that touch bar"))
        }
        server["/newtouchbar"] = { request in
            DispatchQueue.main.async { [weak self] in
                // TODO encapsulate this behavior. Also kill touch bar if one is presented
                TouchBarManager.shared.touchBar = TouchBarManager.shared.makeTouchBar()
                self?.presentModalTouchBar()
            }
            
            return HttpResponse.ok(.htmlBody("new touch bar coming up!"))
        }
        
        
        do {
            try server.start(8080, forceIPv4: false, priority: .userInteractive)
            print("server started at \(try server.port())")
        } catch {
            print("error starting server: \(error)")
        }
    }
    
    override func makeTouchBar() -> NSTouchBar? {
        print("view controller's make touch bar called")
        return nil
    }
    
    override func viewWillDisappear() {
        Persistence.persistSettings()
    }
    
    private func presentModalTouchBar() {
        if #available(macOS 10.14, *) {
            // TODO don't force unwrap here
            NSTouchBar.presentSystemModalTouchBar(TouchBarManager.shared.touchBar!, systemTrayItemIdentifier: self.controlStripIconIdentifier)
        } else {
            NSTouchBar.presentSystemModalFunctionBar(TouchBarManager.shared.touchBar!, systemTrayItemIdentifier: self.controlStripIconIdentifier)
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
        
        let customTouchBarItems = identifiers.compactMap({touchBar?.item(forIdentifier: $0) as? CustomTouchBarItem})
        customTouchBarItems.forEach({ item in
            item.updateButtonSize(numItems: identifiers.count)
        })
    }
    
    /**
     Adds attributes to the buttons in the App View
     */
    private func setupMenuButtons() {
        let appButtons: [NSButton] = [controlStripButton, fitButton, customizeButton]
        let buttonFontColor: NSColor = NSColor(red: 255.0/255.0, green: 152.0/255.0, blue: 0, alpha: 1)
        
        // Style each button
        for button in appButtons {
            guard let buttonTitle = button.attributedTitle.mutableCopy() as? NSMutableAttributedString else {
                    continue
            }
            
            let attributes: [NSAttributedString.Key: Any] =  [
                .font : NSFont(name: "Runescape-Chat-Font", size: 19)!,
                .foregroundColor: buttonFontColor
            ]
            
            buttonTitle.setAttributes(attributes, range: NSRange(location: 0, length: buttonTitle.length))
            button.attributedTitle = buttonTitle
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
        // TODO test all this with the touch bar manager class
//        Persistence.buttonsFillControlStrip = !Persistence.buttonsFillControlStrip
//
//        if Persistence.buttonsFillControlStrip {
//            fitButtonsToTouchBarScreenSize()
//            presentModalTouchBar(touchBar)
//            sender.image = #imageLiteral(resourceName: "Radio_On")
//        } else {
//            presentModalTouchBar(makeTouchBar())
//            sender.image = #imageLiteral(resourceName: "Radio_Off")
//        }
    }
    
    /**
     Called when an observed KeyPath's value is changed
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
         // TODO test all this with the touch bar manager class
//        /* Need to re-present the system-wide modal touchbar due to some limitation in the undocumented
//         DFRFoundationFramework. I believe it copies a Touch Bar under the hood, since changes to the "local"
//         touch bar aren't reflected until presentSystemModalTouchBar() is called again. */
//        touchBar = makeTouchBar()
//        presentModalTouchBar(touchBar)
//
//        if Persistence.buttonsFillControlStrip {
//            fitButtonsToTouchBarScreenSize()
//        }
    }
}

class TouchBarManager: NSObject, NSTouchBarProvider, NSTouchBarDelegate {
    static let shared: TouchBarManager = {
        // TODO add the make touch bar in the property observers ins tead
        let manager = TouchBarManager()
        manager.touchBar = manager.makeTouchBar()
        return manager
    }()
    
    var touchBar: NSTouchBar?
    
    func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        
        touchBar.delegate = self
        touchBar.customizationIdentifier = TouchBarConstants.touchBarCustomizationIdentifierExtension
        
        // TODO: - For runeLite, need to get the user's F-key setup in-game otherwise the buttons might not match up
        touchBar.defaultItemIdentifiers = TouchBarConstants.TouchBarIdentifier.allCases.filter {
            // TODO: - look into esc key identifier property of touch bar
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
