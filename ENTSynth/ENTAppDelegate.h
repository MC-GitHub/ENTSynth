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

// The libpd audioController
@property (strong, nonatomic, readonly) PdAudioController *audioController;

/* Sends a MIDI note to the playNote method in the ViewController. This initiates a note with a trigger. 
 The dispatcher is created in the ViewController */
- (void) playNote:(int) note;

/* This method updates the MIDI note information in the ViewController. 
 The updateNote method in the ViewController DOES NOT initiate a trigger */
- (void) updateNote:(int) note;


@end
