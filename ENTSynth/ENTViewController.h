//
//  ENTViewController.h
//  ENTSynth
//
//  Created by Robert O'Connor on 16/03/2012.
//  Copyright (c) 2012 WIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdDispatcher.h"
#import "ENTInputView.h"

@interface ENTViewController : UIViewController
{
    /* Putting the dispatcher in the ViewController as per the libpd tutorial.
     Perhaps it'd be a better suited in the AppDelegate? Or maybe not? */
     
    PdDispatcher *dispatcher;
    void *patch;
}

-(void) playNote:(int)n;
-(void) updateNote:(int)n;

@end
