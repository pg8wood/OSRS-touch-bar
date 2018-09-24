//
//  WindowController.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 9/16/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    @available(OSX 10.12.1, *)
    override func makeTouchBar() -> NSTouchBar? {
        guard let viewController = contentViewController as? ViewController else {
            return nil
        }
        
        return viewController.makeTouchBar()
    }
}
