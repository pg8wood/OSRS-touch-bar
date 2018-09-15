//
//  TouchBarGestureRecognizer.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 9/14/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Cocoa

class TouchBarGestureRecognizer: NSGestureRecognizer {
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        self.allowedTouchTypes = .direct
        print("created")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func touchesBegan(with event: NSEvent) {
        print("touches began")
    }
    
    override func touchesMoved(with event: NSEvent) {
        print("touches moved")
    }
}
