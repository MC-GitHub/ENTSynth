//
//  ENTAppDelegate.m
//  ENTSynth
//
//  Created by Robert O'Connor on 16/03/2012.
//  Copyright (c) 2012 WIT. All rights reserved.
//

#import "ENTAppDelegate.h"
#import "ENTViewController.h"

@implementation ENTAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize audioController = _audioController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /* Audio Controller setup code */
    _audioController = [[PdAudioController alloc] init];
    
    if ([self.audioController configureAmbientWithSampleRate:44100
                                              numberChannels:2 mixingEnabled:YES] != PdAudioOK) {
        NSLog(@"failed to initialize audio components");
    }
    
    /* Standard AppDelegate stuff for Universal App. 
     Depending on whether the app is running on iPhone or iPad, the appropriate nib will be loaded */
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[ENTViewController alloc] initWithNibName:@"ENTViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[ENTViewController alloc] initWithNibName:@"ENTViewController_iPad" bundle:nil];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    self.audioController.active = NO; // putting the audioController to sleep
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    self.audioController.active = YES;  // waking up the audioController
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/* Sends a MIDI note to the playNote method in the ViewController. This initiates a note with a trigger. 
 The dispatcher is created in the ViewController
 This is merely a hack to allow the inputView talk to the appropriate viewController 
 via the AppDelegate. May not be the best way to do this. */
- (void) playNote:(int) note
{
    NSLog(@"Note number in App delegate is %d", note);
    [_viewController playNote:note];
}

/* This method updates the MIDI note information in the ViewController. 
 The updateNote method in the ViewController DOES NOT initiate a trigger.
 This is another hack, like the playNote method above*/
- (void) updateNote:(int) note
{
    NSLog(@"Updating midi note in App delegate to %d", note);
    [_viewController updateNote:note]; 
}

@end
