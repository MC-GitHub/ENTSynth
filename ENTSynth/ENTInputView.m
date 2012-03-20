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

-(void)awakeFromNib
{
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
    fire.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] 
                  CGColor];
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


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    NSLog(@"*** Initialising appDelegate ***");
    
    if (self) {
        
    }
    
    return self;
}


- (int) xCoordinateAsMidiNote:(CGPoint) pt
{
    // Width is 0 - 480
    // Let's say valid notes are between 36 - 60 (24) C2 - C4

    int p = (pt.x/480) * 100; // gets percentage value
    
    int n = (0.24 * p) + 36;
    
    return n;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint pt = [[touches anyObject] locationInView: self];
    int n = [self xCoordinateAsMidiNote:pt];
    
    ENTAppDelegate *appDelegate = (ENTAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateNote:n];
    
    [self setEmitterPositionFromTouch: [touches anyObject]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches begin");
    
    
    [self setEmitterPositionFromTouch: [touches anyObject]];
    [self setIsEmitting:YES];
    
    CGPoint pt = [[touches anyObject] locationInView: self];
    NSLog(@"x = %f, y = %f", pt.x, pt.y);
    
    int n = [self xCoordinateAsMidiNote:pt];
    
    ENTAppDelegate *appDelegate = (ENTAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate playNote:n];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setIsEmitting:NO];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    ENTAppDelegate *appDelegate = (ENTAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateNote:0];
    [self setIsEmitting:NO];
}



-(void)setEmitterPositionFromTouch: (UITouch*)t
{
    //change the emitter's position
    fireEmitter.emitterPosition = [t locationInView:self];
}

-(void)setIsEmitting:(BOOL)isEmitting
{
    //turn on/off the emitting of particles
    [fireEmitter setValue:[NSNumber numberWithInt:isEmitting?200:0] 
               forKeyPath:@"emitterCells.fire.birthRate"];
}



@end

