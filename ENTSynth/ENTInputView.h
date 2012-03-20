//
//  ENTInputView.h
//  ENTSynth
//
//  Created by Robert O'Connor on 16/03/2012.
//  Copyright (c) 2012 WIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ENTAppDelegate.h"

//@class ENTAppDelegate;

@interface ENTInputView : UIView

-(void)setEmitterPositionFromTouch: (UITouch*)t;
-(void)setIsEmitting:(BOOL)isEmitting;

@end
