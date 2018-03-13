//
//  AppDelegate.m
//
//  Created by Patrick Gatewood on 2/27/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

#import "AppDelegate.h"
#import "TouchBar.h"
#import <OSRS_touch_bar-Swift.h>

static const NSTouchBarItemIdentifier controlStripIconIdentifier = @"osrs-logo";

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTouchBar *touchBar;

@end

@implementation AppDelegate

// Displays the "fullscreen" Touch Bar interface
- (void)present:(id)sender {
    [NSTouchBar presentSystemModalFunctionBar:self.touchBar
                     systemTrayItemIdentifier:controlStripIconIdentifier];
    [NSApp activateIgnoringOtherApps:YES]; // Make sure the user sees the next screen
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [TouchBarScriptRunner hideControlStrip];
    DFRSystemModalShowsCloseBoxWhenFrontMost(YES);

    // Create the Control Strip icon
    NSCustomTouchBarItem *controlStripTBItem = // Touch Bar, not TeleBlock
        [[NSCustomTouchBarItem alloc] initWithIdentifier:controlStripIconIdentifier];
    controlStripTBItem.view = [NSButton buttonWithImage: [NSImage imageNamed:@"OSRS_Logo"] target:self action:@selector(present:)];
    [NSTouchBarItem addSystemTrayItem:controlStripTBItem];
    DFRElementSetControlStripPresenceForIdentifier(controlStripIconIdentifier, YES);
    
    [self present:(controlStripTBItem.view)];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [TouchBarScriptRunner showTouchBarSettings];
}

@end
