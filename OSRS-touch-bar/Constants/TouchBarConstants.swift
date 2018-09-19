//
//  TouchBarItemConstants.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 9/16/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Foundation

public class TouchBarConstants {
    
    public static let touchBarCustomizationIdentifierExtension = "OSRS Touch Bar"
    public static let userDefaultsTouchBarIdentifier = "NSTouchBarConfig: \(touchBarCustomizationIdentifierExtension)"

    public enum TouchBarIdentifier: String, CaseIterable {
        case combatOptionsLabelItem = "com.patrickgatewood.combat-options"
        case statsLabelItem = "com.patrickgatewood.stats"
        case questListLabelItem = "com.patrickgatewood.quest-list"
        case inventoryLabelItem = "com.patrickgatewood.inventory"
        case equipmentLabelItem = "com.patrickgatewood.worn-equipment"
        case prayerLabelItem = "com.patrickgatewood.prayer"
        case spellbookLabelItem = "com.patrickgatewood.magic"
        case clanChatLabelItem = "com.patrickgatewood.clan-chat"
        case friendsListLabelItem = "com.patrickgatewood.friends-list"
        case ignoreListLabelItem = "com.patrickgatewood.ignore-list"
        case optionsLabelItem = "com.patrickgatewood.options"
        case emotesLabelItem = "com.patrickgatewood.emotes"
        case musicPlayerLabelItem = "com.patrickgatewood.music-player"
    }
    
    public static let touchBarItemDict: Dictionary<String, (name: String, keyCode: UInt16)> = [
        TouchBarIdentifier.combatOptionsLabelItem.rawValue: ("Combat Options", KeyCodes.F1KeyCode),
        TouchBarIdentifier.statsLabelItem.rawValue: ("Stats", KeyCodes.F2KeyCode),
        TouchBarIdentifier.questListLabelItem.rawValue: ("Quests", KeyCodes.F3KeyCode),
        TouchBarIdentifier.inventoryLabelItem.rawValue: ("Inventory", KeyCodes.ESCKeyCode),
        TouchBarIdentifier.equipmentLabelItem.rawValue: ("Worn Equipment", KeyCodes.F4KeyCode),
        TouchBarIdentifier.prayerLabelItem.rawValue: ("Prayer", KeyCodes.F5KeyCode),
        TouchBarIdentifier.spellbookLabelItem.rawValue: ("Spellbook", KeyCodes.F6KeyCode),
        TouchBarIdentifier.clanChatLabelItem.rawValue: ("Clan Chat", KeyCodes.F7KeyCode),
        TouchBarIdentifier.friendsListLabelItem.rawValue: ("Friends List", KeyCodes.F8KeyCode),
        TouchBarIdentifier.ignoreListLabelItem.rawValue: ("Ignore List", KeyCodes.F8KeyCode),
        TouchBarIdentifier.optionsLabelItem.rawValue: ("Options", KeyCodes.F9KeyCode),
        TouchBarIdentifier.emotesLabelItem.rawValue: ("Emotes", KeyCodes.F10KeyCode),
        TouchBarIdentifier.musicPlayerLabelItem.rawValue: ("Music", KeyCodes.F11KeyCode)
    ]
}
