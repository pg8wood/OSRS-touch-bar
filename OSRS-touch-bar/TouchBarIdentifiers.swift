//
//  TouchBarIdentifiers.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 2/25/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import AppKit

extension NSTouchBarItem.Identifier {
    static let combatOptionsLabelItem = NSTouchBarItem.Identifier("com.patrickgatewood.combat-options")
    static let statsLabelItem = NSTouchBarItem.Identifier("com.patrickgatewood.stats")
    static let questListLabelItem = NSTouchBarItem.Identifier("com.patrickgatewood.quest-list")
    static let inventoryLabelItem = NSTouchBarItem.Identifier("com.patrickgatewood.inventory")
    static let equipmentLabelItem = NSTouchBarItem.Identifier("com.patrickgatewood.worn-equipment")
    static let prayerLabelItem = NSTouchBarItem.Identifier("com.patrickgatewood.prayer")
    static let spellbookLabelItem = NSTouchBarItem.Identifier("com.patrickgatewood.magic")
    static let clanChatLabelItem = NSTouchBarItem.Identifier("com.patrickgatewood.clan-chat")
    static let friendsListLabelItem = NSTouchBarItem.Identifier("com.patrickgatewood.friends-list")
    static let ignoreListLabelItem = NSTouchBarItem.Identifier("com.patrickgatewood.ignore-list")
    static let optionsLabelItem = NSTouchBarItem.Identifier("com.patrickgatewood.options")
    static let emotesLabelItem = NSTouchBarItem.Identifier("com.patrickgatewood.emotes")
    static let musicPlayerLabelItem = NSTouchBarItem.Identifier("com.patrickgatewood.music-player")
}

extension NSTouchBar.CustomizationIdentifier {
    static let osrsBar = NSTouchBar.CustomizationIdentifier(rawValue: "com.patrickgatewood.osrs-touch-bar")
}
