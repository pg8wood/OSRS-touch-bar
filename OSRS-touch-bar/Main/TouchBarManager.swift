//
//  TouchBarManager.swift
//  OSRS Touch Bar
//
//  Created by Patrick Gatewood on 5/28/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//

import Cocoa

class TouchBarManager: NSObject, NSTouchBarProvider, NSTouchBarDelegate {

    static let shared: TouchBarManager = {
        // TODO add the make touch bar in the property observers instead
        let manager = TouchBarManager()
        manager.touchBar = manager.makeTouchBar()
        return manager
    }()
    
    let controlStripIconIdentifier = NSTouchBarItem.Identifier(rawValue: "com.patrickgatewood.osrs-logo")
    
    var touchBar: NSTouchBar?
    
    private override init() {}
    
    func dismissModalTouchBar() {
        guard Thread.isMainThread else {
            assertionFailure("Attempted to dismiss the Touch Bar on a background thread!")
            return
        }
        
        if #available(OSX 10.14, *) {
            NSTouchBar.dismissSystemModalTouchBar(touchBar)
        } else {
            // TODO: -  Fallback on earlier versions
        }
        
        
        touchBar = nil
    }
    
    func presentModalTouchBar() {
        guard Thread.isMainThread else {
            assertionFailure("Attempted to present a Touch Bar on a background thread!")
            return
        }
        
        if touchBar != nil {
            dismissModalTouchBar()
        }
        
        let touchBar = makeTouchBar()
        
        if #available(macOS 10.14, *) {
            // TODO don't force unwrap here
            NSTouchBar.presentSystemModalTouchBar(touchBar, systemTrayItemIdentifier: controlStripIconIdentifier)
        } else {
            NSTouchBar.presentSystemModalFunctionBar(touchBar, systemTrayItemIdentifier: controlStripIconIdentifier)
        }
        
        self.touchBar = touchBar
    }
    
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
    
    // MARK: - NSTouchBarDelegate
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        guard let touchBarItemData = TouchBarConstants.touchBarItemDict[identifier.rawValue] else {
            return nil
        }
        
        return CustomTouchBarItem(identifier: identifier, name: touchBarItemData.name, keyCode: touchBarItemData.keyCode)
    }
}
