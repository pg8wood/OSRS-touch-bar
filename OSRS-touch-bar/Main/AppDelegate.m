//
//  AppDelegate.m
//
//  Created by Patrick Gatewood on 2/27/18.
//  Copyright © 2018 Patrick Gatewood. All rights reserved.
//

#import "AppDelegate.h"
#import "TouchBar.h"
#import <OSRS_touch_bar-Swift.h>

@interface AppDelegate ()


@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTouchBar *touchBar;

@end

@implementation AppDelegate


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
