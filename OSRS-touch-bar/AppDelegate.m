//
//  AppDelegate.m
//
//  Created by Alexsander Akers on 2/13/17.
//  Modified by Patrick Gatewood on 2/27/18.
//  Copyright © 2017 Alexsander Akers. All rights reserved.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

#import "AppDelegate.h"
#import "TouchBar.h"

static const NSTouchBarItemIdentifier controlStripIconIdentifier = @"osrs-logo";

@interface AppDelegate () <NSTouchBarDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTouchBar *touchBar;

@end

@implementation AppDelegate

- (void)present:(id)sender
{
    [NSTouchBar presentSystemModalFunctionBar:self.touchBar
                     systemTrayItemIdentifier:controlStripIconIdentifier];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    DFRSystemModalShowsCloseBoxWhenFrontMost(YES);

    NSCustomTouchBarItem *controlStripTBItem = // Touch Bar, not TeleBlock
        [[NSCustomTouchBarItem alloc] initWithIdentifier:controlStripIconIdentifier];
    controlStripTBItem.view = [NSButton buttonWithImage: [NSImage imageNamed:@"OSRS_Logo"] target:self action:@selector(present:)];
    [NSTouchBarItem addSystemTrayItem:controlStripTBItem];
    DFRElementSetControlStripPresenceForIdentifier(controlStripIconIdentifier, YES);
    
    if (@available(macOS 10.12.1, *)) {
        [NSApplication sharedApplication].automaticCustomizeTouchBarMenuItemEnabled = YES;
    }
}

@end
