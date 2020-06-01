//
//  TouchBarManager.swift
//  OSRS Touch Bar
//
//  Created by Patrick Gatewood on 5/28/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//

import Cocoa

class TouchBarManager: NSObject, NSTouchBarProvider, NSTouchBarDelegate {

    static let shared: TouchBarManager = TouchBarManager()
    
    let controlStripIconIdentifier = NSTouchBarItem.Identifier(rawValue: "com.patrickgatewood.osrs-logo")
    
    var touchBar: NSTouchBar?
    
    private override init() {
        super.init()
        observeTouchBarCustomizationChanges()
    }
     /// Observe user customization of the F-Key Touch Bar. A hack is needed. See  [presentNewCustomizedTouchBar](x-source-tag://presentNewCustomizedTouchBar) for more info.
    private func observeTouchBarCustomizationChanges() {
        UserDefaults.standard.addObserver(self,
                                          forKeyPath: TouchBarConstants.userDefaultsTouchBarIdentifier,
                                          options: NSKeyValueObservingOptions.new, context: nil)
    }
    
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
    
    @objc
    func presentModalFKeyTouchBar() {
        guard Thread.isMainThread else {
            assertionFailure("Attempted to present a Touch Bar on a background thread!")
            return
        }
        
        if touchBar != nil {
            dismissModalTouchBar()
        }
        
        let touchBar = makeFKeyTouchBar()
        self.touchBar = touchBar
        
        if #available(macOS 10.14, *) {
            // TODO don't force unwrap here
            NSTouchBar.presentSystemModalTouchBar(touchBar, systemTrayItemIdentifier: controlStripIconIdentifier)
        } else {
            NSTouchBar.presentSystemModalFunctionBar(touchBar, systemTrayItemIdentifier: controlStripIconIdentifier)
        }
    }
    
    func presentFKeyTouchBarCustomizationWindow() {
        if touchBar == nil {
            presentModalFKeyTouchBar()
        }
        
        /* Note that any changes made by the user in this view are only represented in UserDefaults.
         The NSTouchBar object is NOT changed. */
        
        NSApplication.shared.toggleTouchBarCustomizationPalette(touchBar)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?, change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard keyPath == TouchBarConstants.userDefaultsTouchBarIdentifier else {
            return
        }
        
        presentNewCustomizedFKeyTouchBar()
    }
    
    /// - Tag: presentNewCustomizedTouchBar
    /// Re-presents the system-wide modal Touch Bar due to some limitation in the undocumented
    /// DFRFoundationFramework, since changes to the presented Touch Bar aren't reflected until
    /// presentModalFKeyTouchBar() is called again.
    private func presentNewCustomizedFKeyTouchBar() {
        presentModalFKeyTouchBar()
        
        if Persistence.buttonsFillControlStrip {
            fitButtonsToTouchBarScreenSize()
        }
    }
    
    func fitButtonsToTouchBarScreenSize() {
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
    
    func makeFKeyTouchBar() -> NSTouchBar? {
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
    
    // MARK: - Control Strip
    
    func showControlStripIcon() {
        let controlStripTBItem = NSCustomTouchBarItem(identifier: controlStripIconIdentifier) // Touch Bar, not TeleBlock
        controlStripTBItem.view = NSButton(image: NSImage(named: "OSRS_Logo")!, target: TouchBarManager.shared, action: #selector(TouchBarManager.shared.presentModalFKeyTouchBar))
        
        NSTouchBarItem.addSystemTrayItem(controlStripTBItem)
        DFRElementSetControlStripPresenceForIdentifier(controlStripIconIdentifier, true)
    }
    
    func restoreControlStrip() {
        ScriptRunner.restoreControlStrip()
        showControlStripIcon()
    }
}
