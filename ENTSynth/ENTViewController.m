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

-(void) playNote:(int)n 
{
    NSLog(@"Playing note %d", n);
    [PdBase sendFloat:n toReceiver:@"midinote"];
    [PdBase sendBangToReceiver:@"trigger"];
}

-(void) updateNote:(int)n 
{
    [PdBase sendFloat:n toReceiver:@"midinote"];
}

-(IBAction)playE:(id)sender {
    NSLog(@"Playing E");
    [self playNote:40];
}


@end
