//
//  ENTInputView.m
//  ENTSynth
//
//  Created by Robert O'Connor on 16/03/2012.
//  Copyright (c) 2012 WIT. All rights reserved.
//

#import "ENTInputView.h"

#import <QuartzCore/QuartzCore.h>

@implementation ENTInputView
{
    CAEmitterLayer* fireEmitter; //1
}

+ (Class) layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    NSLog(@"*** Initialising appDelegate ***");
    
    if (self) {
        
    }
    
    return self;
}

-(void)awakeFromNib
{
    /* Setting up the fire animation properties */
    
    //set ref to the layer
    fireEmitter = (CAEmitterLayer*)self.layer; //2
    
    //configure the emitter layer
    fireEmitter.emitterPosition = CGPointMake(50, 50);
    //fireEmitter.emitterSize = CGSizeMake(10, 10);
    fireEmitter.emitterSize = CGSizeMake(100, 100);
    
    fireEmitter.renderMode = kCAEmitterLayerAdditive;
    
    CAEmitterCell* fire = [CAEmitterCell emitterCell];
    fire.birthRate = 100;
    fire.lifetime = 1.0;
    fire.lifetimeRange = 0.5;
    fire.color = [[UIColor colorWithRed:0.2 green:0.5 blue:0.3 alpha:0.1] CGColor];
    
    fire.contents = (id)[[UIImage imageNamed:@"Particles_fire.png"] CGImage];
    fire.velocity = 10;
    fire.velocityRange = 20;
    fire.emissionRange = M_PI_2;
    fire.scaleSpeed = 0.3;
    fire.spin = 0.5;
    
    fire.birthRate = 0;
    
    [fire setName:@"fire"];
    
    //add the cell to the layer and we're done
    fireEmitter.emitterCells = [NSArray arrayWithObject:fire];
}


/* Tells the CAEmitterLayer to draw fire from where a touch is detected */
-(void)setEmitterPositionFromTouch: (UITouch*)t
{
    //change the emitter's position
    fireEmitter.emitterPosition = [t locationInView:self];
}

/* Turns the fire on and off */
-(void)setIsEmitting:(BOOL)isEmitting
{
    //turn on/off the emitting of particles
    [fireEmitter setValue:[NSNumber numberWithInt:isEmitting?200:0] 
               forKeyPath:@"emitterCells.fire.birthRate"];
}

/* Determines the touch position as a MIDI note number between 36 and 60 (C2 - C4). 
 Far left is C2, far right is C4.
 This is a bit of a hack. */
- (int) xCoordinateAsMidiNote:(CGPoint) pt
{
    // Width is 0 - 480
    // Let's say valid notes are between 36 - 60 (24) C2 - C4

    int p = (pt.x/480) * 100; // gets percentage value
    
    int n = (0.24 * p) + 36; // get percentage as a note value in 0 - 24 range, then add 36 to put in our scale
    
    return n;
}

#pragma mark - Touch Lifecycle Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches begin");
    
    /* Do the drawing */
    [self setEmitterPositionFromTouch: [touches anyObject]];
    [self setIsEmitting:YES];
    
    /* Work out where the touch is happening, get the MIDI value and send it to the AppDelegate as a new playNote message. Remember - playNote will initiate a trigger. updateNote will not.*/
    CGPoint pt = [[touches anyObject] locationInView: self];
    NSLog(@"x = %f, y = %f", pt.x, pt.y);
    
    int n = [self xCoordinateAsMidiNote:pt];
    ENTAppDelegate *appDelegate = (ENTAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate playNote:n];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Do the drawing */
    [self setEmitterPositionFromTouch: [touches anyObject]];
    
    /* Work out where the touch is happening, get the MIDI value and update the note in the AppDelegate (which will then update the displatcher) */
    CGPoint pt = [[touches anyObject] locationInView: self];
    int n = [self xCoordinateAsMidiNote:pt];
    
    ENTAppDelegate *appDelegate = (ENTAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateNote:n];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Stop drawing */
    [self setIsEmitting:NO];
    
    /* Note we're not handling an audio here, because the patch I've "designed" does not sustain.
     May need to look at this in a later version */
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    /* In the event of a touchesCancelled, send a 0 note to the audio dispatcher and turn off the fire.
     A touch could be cancelled by something like an incoming phone call */
    ENTAppDelegate *appDelegate = (ENTAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateNote:0];
    [self setIsEmitting:NO];
}



@end

