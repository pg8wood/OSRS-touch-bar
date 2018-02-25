//
//  ViewController.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 2/24/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
}

 // MARK: - Touch Bar delegate

@available(OSX 10.12.1, *)
extension ViewController: NSTouchBarDelegate {
    
    @available(OSX 10.12.2, *)
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
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
        case NSTouchBarItem.Identifier(rawValue: "com.patrickgatewood.osrs-touch-bar-label1"):
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            customViewItem.view = NSTextField(labelWithString: "\u{1F30E} \u{1F4D3}")
            return customViewItem
        default:
            return nil
        }
    }
}

