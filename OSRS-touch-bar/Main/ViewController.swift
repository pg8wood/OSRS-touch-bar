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
    
    // -----------------------
    // MARK: - View life cycle
    // -----------------------
    
    override func viewDidLoad() {
        setupMenuButtons()
        
        if Persistence.controlStripEnabled {
            controlStripButton.state = .on
            controlStripButton.image = #imageLiteral(resourceName: "Radio_On")
            setNSButtonTitle(button: controlStripButton, to: "  Control Strip (on)")
        } else {
            ScriptRunner.hideControlStrip()
        }
        
        if Persistence.buttonsFillControlStrip {
            fitButton.image = #imageLiteral(resourceName: "Radio_On")
            TouchBarManager.shared.fitButtonsToTouchBarScreenSize()
        }
    }
    
    /**
     Hide the Control Strip and set up the global Touch Bar
     */
    override func viewDidAppear() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)
        DFRElementSetControlStripPresenceForIdentifier(TouchBarManager.shared.controlStripIconIdentifier, true)
        
        // TODO: move this outa the VC when you remove the app's window
        HTTPServer.start()
        switch HTTPServer.start() {
        case .success(let port):
            // TODO: send the port back to the RuneLite plugin
            break
        case .failure(let error):
            // TODO: Error handling
            break
        }
    }
    
    override func viewWillDisappear() {
        Persistence.persistSettings()
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
        TouchBarManager.shared.presentFKeyTouchBarCustomizationWindow()
    }
    
    /**
     Toggles whether the Touch Bar buttons fill the screen size
     
     - parameter sender: The NSButton clicked
     */
    @IBAction func fitButtonClicked(_ sender: NSButton) {
        TouchBarManager.shared.fitButtonsToTouchBarScreenSize()
    }
    
    // Hack that should only be needed as long as this application has a view
    override func makeTouchBar() -> NSTouchBar? {
        return TouchBarManager.shared.touchBar ?? TouchBarManager.shared.makeFKeyTouchBar()
    }

}
