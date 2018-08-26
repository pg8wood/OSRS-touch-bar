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

/**
 Displays the "fullscreen" Touch Bar interface
 */
- (void)present:(id)sender {
    if (@available(macOS 10.14, *)) {
        [NSTouchBar presentSystemModalTouchBar:self.touchBar
                      systemTrayItemIdentifier:controlStripIconIdentifier];
    } else {
        [NSTouchBar presentSystemModalFunctionBar:self.touchBar
                         systemTrayItemIdentifier:controlStripIconIdentifier];
    }

    [NSApp activateIgnoringOtherApps:YES]; // Make sure the user sees the next screen
}

/**
 Hide the Control Strip and set up the global Touch Bar
 */
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [ScriptRunner hideControlStrip];
    DFRSystemModalShowsCloseBoxWhenFrontMost(NO);
    DFRElementSetControlStripPresenceForIdentifier(controlStripIconIdentifier, YES);
    [self present:(self)];
}

/**
 Show the app icon in the Control Strip if the user closes the global
 Touch Bar. Tapping it will re-open the global Touch Bar and the window
 */
- (void)applicationWillResignActive:(NSNotification *)notification {
    NSCustomTouchBarItem *controlStripTBItem = // Touch Bar, not TeleBlock
    [[NSCustomTouchBarItem alloc] initWithIdentifier:controlStripIconIdentifier];
    controlStripTBItem.view = [NSButton buttonWithImage: [NSImage imageNamed:@"OSRS_Logo"] target:self action:@selector(present:)];
    
     [NSTouchBarItem addSystemTrayItem:controlStripTBItem];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [ScriptRunner restoreControlStrip];
}

@end
