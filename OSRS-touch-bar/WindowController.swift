//
//  WindowController.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 2/25/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        guard let viewController = contentViewController as? ViewController else {
            return nil
        }
        return viewController.makeTouchBar()
    }
    
}
