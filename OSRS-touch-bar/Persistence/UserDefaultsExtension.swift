//
//  UserDefaultsExtension.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 9/18/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

extension UserDefaults {
    @objc dynamic var osrsTouchBarConfig: [String: Any] {
        return value(forKey: TouchBarConstants.userDefaultsTouchBarIdentifier) as? [String: Any] ?? [:]
    }
    
    @objc dynamic var osrsTouchBarCurrentItems: NSArray {
        return osrsTouchBarConfig["CurrentItems"] as? NSArray ?? NSArray()
    }
}
