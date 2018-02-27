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

static const NSTouchBarItemIdentifier kBearIdentifier = @"io.a2.Bear";
static const NSTouchBarItemIdentifier kPandaIdentifier = @"io.a2.Panda";
static const NSTouchBarItemIdentifier kGroupIdentifier = @"io.a2.Group";

@interface AppDelegate () <NSTouchBarDelegate>

@property (weak) IBOutlet NSWindow *window;
//@property (nonatomic) NSTouchBar *groupTouchBar;
@property (weak) IBOutlet NSTouchBar *touchBar;

@end

@implementation AppDelegate

- (void)bear:(id)sender
{
}

- (void)present:(id)sender
{
    [NSTouchBar presentSystemModalFunctionBar:self.touchBar
                     systemTrayItemIdentifier:kPandaIdentifier];
}

- (NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar
       makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
{
    if ([identifier isEqualToString:kBearIdentifier]) {
        NSCustomTouchBarItem *bear =
            [[NSCustomTouchBarItem alloc] initWithIdentifier:kBearIdentifier];
        bear.view = [NSButton buttonWithTitle:@"\U0001F43B" target:self action:@selector(bear:)];
        return bear;
    } else if ([identifier isEqualToString:kPandaIdentifier]) {
        NSCustomTouchBarItem *panda =
            [[NSCustomTouchBarItem alloc] initWithIdentifier:kPandaIdentifier];
        panda.view =
            [NSButton buttonWithTitle:@"\U0001F43C" target:self action:@selector(present:)];
        return panda;
    } else {
        return nil;
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    DFRSystemModalShowsCloseBoxWhenFrontMost(YES);

    NSCustomTouchBarItem *panda =
        [[NSCustomTouchBarItem alloc] initWithIdentifier:kPandaIdentifier];
    panda.view = [NSButton buttonWithTitle:@"\U0001F43C" target:self action:@selector(present:)];
    [NSTouchBarItem addSystemTrayItem:panda];
    DFRElementSetControlStripPresenceForIdentifier(kPandaIdentifier, YES);
    
    if (@available(macOS 10.12.1, *)) {
        [NSApplication sharedApplication].automaticCustomizeTouchBarMenuItemEnabled = YES;
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

@end
