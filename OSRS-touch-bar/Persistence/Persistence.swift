//
//  Persistence.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 9/22/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Foundation

class Persistence {
    static let controlStripEnabledKey = "com.patrickgatewood.controlStripEnabled"
    static let buttonsFillControlStripKey = "com.patrickgatewood.buttonsFillControlStrip"
    
    static var controlStripEnabled: Bool = UserDefaults.standard.value(forKey: controlStripEnabledKey) as? Bool ?? false
    static var buttonsFillControlStrip: Bool = UserDefaults.standard.value(forKey: buttonsFillControlStripKey) as? Bool ?? true 
    
    static func persistSettings() {
        UserDefaults.standard.set(controlStripEnabled, forKey: controlStripEnabledKey)
        UserDefaults.standard.set(buttonsFillControlStrip, forKey: buttonsFillControlStripKey)
    }
}
