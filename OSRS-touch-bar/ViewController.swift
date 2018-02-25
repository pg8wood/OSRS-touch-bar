//
//  ViewController.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 2/24/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTouchBarDelegate {
    
    // MARK: - Touch Bar methods
    
    @available(OSX 10.12.1, *)
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        let touchBarIdentifier = NSTouchBar.CustomizationIdentifier(rawValue: "com.patrickgatewood.osrs-touch-bar")
        let touchBarLabel1Identifer = NSTouchBarItem.Identifier(rawValue: "com.patrickgatewood.osrs-touch-bar-label1")
       
        touchBar.delegate = self
        touchBar.customizationIdentifier = touchBarIdentifier
        touchBar.defaultItemIdentifiers = [touchBarLabel1Identifer, .fixedSpaceLarge, .otherItemsProxy]
        touchBar.customizationAllowedItemIdentifiers = [touchBarLabel1Identifer]
        return touchBar
    }
    
    @available(OSX 10.12.1, *)
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        
        if identifier.rawValue == "com.patrickgatewood.osrs-touch-bar.label1" {
            let custom = NSCustomTouchBarItem(identifier: identifier)
            custom.customizationLabel = "Label"
            
            let label = NSTextField.init(labelWithString: "Hello, World!")
            custom.view = label
            
            return custom
        }
        
        return nil
        
    }
    
    // MARK: - View life cycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.touchBar = makeTouchBar()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

