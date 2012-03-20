//
//  ENTAppDelegate.h
//  ENTSynth
//
//  Created by Robert O'Connor on 16/03/2012.
//  Copyright (c) 2012 WIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdAudioController.h"

@class ENTViewController;

@interface ENTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ENTViewController *viewController;

@property (strong, nonatomic, readonly) PdAudioController *audioController;

- (void) playNote:(int) note;
- (void) updateNote:(int) note;

@end
