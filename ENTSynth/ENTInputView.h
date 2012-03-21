//
//  ENTInputView.h
//  ENTSynth
//
//  Created by Robert O'Connor on 16/03/2012.
//  Copyright (c) 2012 WIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ENTAppDelegate.h"


@interface ENTInputView : UIView

/* Tells the CAEmitterLayer to draw fire from where a touch is detected*/
-(void)setEmitterPositionFromTouch: (UITouch*)t;

/* Turns the fire on and off */
-(void)setIsEmitting:(BOOL)isEmitting;

@end
