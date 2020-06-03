//
//  TouchBar.h
//  TouchBarTest
//
//  Created by Alexsander Akers on 2/13/17.
//  Copyright © 2017 Alexsander Akers. All rights reserved.
//
#import <AppKit/AppKit.h>
extern void DFRElementSetControlStripPresenceForIdentifier(NSTouchBarItemIdentifier, BOOL);

@interface NSTouchBarItem ()

+ (void)addSystemTrayItem:(NSTouchBarItem *)item;

@end
@interface NSTouchBar ()

+ (void)dismissSystemModalTouchBar:(NSTouchBar *)touchBar NS_AVAILABLE_MAC(10.14);
+ (void)presentSystemModalTouchBar:(NSTouchBar *)touchBar systemTrayItemIdentifier:(NSTouchBarItemIdentifier)identifier NS_AVAILABLE_MAC(10.14);
+ (void)presentSystemModalTouchBar:(NSTouchBar *)touchBar placement:(long long)placement systemTrayItemIdentifier:(NSTouchBarItemIdentifier)identifier;


+ (void)presentSystemModalFunctionBar:(NSTouchBar *)touchBar placement:(long long)placement systemTrayItemIdentifier:(NSTouchBarItemIdentifier)identifier;
+ (void)presentSystemModalFunctionBar:(NSTouchBar *)touchBar systemTrayItemIdentifier:(NSTouchBarItemIdentifier)identifier NS_DEPRECATED_MAC(10.12.2, 10.14);

// TODO: -DFRElementGetScreenBounds or _DFRGetScreenSize test if this is better for fitting to touch bar

// TODO: - Find > 10.12.2 && < 10.14 and below version of dismissSystemModalTouchBar: equivalent in the header dumps or drop support
@end
