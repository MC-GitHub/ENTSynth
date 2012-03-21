//
//  ENTViewController.m
//  ENTSynth
//
//  Created by Robert O'Connor on 16/03/2012.
//  Copyright (c) 2012 WIT. All rights reserved.
//

#import "ENTViewController.h"

@implementation ENTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    /* Initializing the dispatcher with the patch */
    dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:dispatcher];
    patch = [PdBase openFile:@"simple_entsynth_patch.pd"
                        path:[[NSBundle mainBundle] resourcePath]];
    if (!patch) {
        NSLog(@"Failed to open patch!");
        // Gracefully handle failure...
    }
}

- (void)viewDidUnload
{
    [PdBase closeFile:patch];
    [PdBase setDelegate:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

/* Sends a MIDI note and a trigger to our dispatcher */
-(void) playNote:(int)n 
{
    NSLog(@"Playing note %d", n);
    [PdBase sendFloat:n toReceiver:@"midinote"];
    [PdBase sendBangToReceiver:@"trigger"];
}

/* Updates the MIDI note information in the dispatcher */
-(void) updateNote:(int)n 
{
    [PdBase sendFloat:n toReceiver:@"midinote"];
}

@end
