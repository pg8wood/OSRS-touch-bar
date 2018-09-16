//
//  AppDelegate.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 9/16/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let controlStripIconIdentifier = NSTouchBarItem.Identifier(rawValue: "com.patrickgatewood.osrs-logo")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if #available(OSX 10.12.1, *) {
            NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        }
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        let controlStripTBItem = NSCustomTouchBarItem(identifier: controlStripIconIdentifier) // Touch Bar, not TeleBlock
        controlStripTBItem.view = NSButton(image: NSImage(named: NSImage.Name(rawValue: "OSRS_Logo"))!, target: self, action: #selector(present))
        
        NSTouchBarItem.addSystemTrayItem(controlStripTBItem)
    }
    
    @objc func present() {
        let windows = NSApplication.shared.windows
        
        guard windows.count > 0, let viewController = windows[0].contentViewController as? ViewController else {
            return
        }
        
        if #available(macOS 10.14, *) {
            NSTouchBar.presentSystemModalTouchBar(viewController.touchBar!, systemTrayItemIdentifier: self.controlStripIconIdentifier)
        } else {
            NSTouchBar.presentSystemModalFunctionBar(viewController.touchBar!, systemTrayItemIdentifier: self.controlStripIconIdentifier)
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        ScriptRunner.restoreControlStrip()
    }
}
