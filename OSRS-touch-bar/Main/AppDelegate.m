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

@interface AppDelegate () <NSTouchBarDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTouchBar *touchBar;
@property (weak) IBOutlet NSView *appView;

@end

@implementation AppDelegate

- (void)present:(id)sender {
    [NSTouchBar presentSystemModalFunctionBar:self.touchBar
                     systemTrayItemIdentifier:controlStripIconIdentifier];
    [TouchBarScriptRunner expandTouchBar];
    [_window setContentView:[self appView]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
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

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [TouchBarScriptRunner showTouchBarSettings];
}

@end
