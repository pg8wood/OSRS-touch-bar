//
//  ViewController.swift
//  OSRS-touch-bar
//
//  Created by Patrick Gatewood on 2/24/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var touchBarOutlet: NSTouchBar!
    @IBOutlet var combatOptionsButton: NSButton!
    @IBOutlet var skillsButton: NSButton!
    
    let osrsInterfaceIdentifiers: [NSTouchBarItem.Identifier] = [.combatOptionsLabelItem, .statsLabelItem, .questListLabelItem, .inventoryLabelItem, .equipmentLabelItem, .prayerLabelItem, .spellbookLabelItem, .clanChatLabelItem, .friendsListLabelItem, .ignoreListLabelItem, .optionsLabelItem, .emotesLabelItem, .musicPlayerLabelItem]
}

 // MARK: - Touch Bar delegate

@available(OSX 10.12.1, *)
extension ViewController: NSTouchBarDelegate {
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
//        touchBarOutlet.item(forIdentifier: .combatOptionsLabelItem).view?.frame = NSRect(
        
        return touchBarOutlet
    }
    
//    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
//        let viewItem = NSCustomTouchBarItem(identifier: identifier)
////        viewItem.view = NSImageView(image: NSImage(named: NSImage.Name(rawValue: "combat-options"))!)
//
//
//        return nil
//    }
}

