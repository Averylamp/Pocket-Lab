//
//  StopWatch.m
//  DraculappAccelerometer
//
//  Created by Jake Spracher on 9/4/15.
//  Copyright (c) 2015 Turnt Technologies, LLC. All rights reserved.
//

#import "StopWatch.h"



@implementation StopWatch

-(void)dealloc
{
    [self.displayTimer invalidate];
}

-(void)startTimer
{
    self.startTime = CFAbsoluteTimeGetCurrent();
    self.displayTimer = [ NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector( timerFired: ) userInfo:nil repeats:YES ];
}

-(double)getTimeandReset {
    double returnTime = CFAbsoluteTimeGetCurrent() - self.startTime;
    self.startTime = CFAbsoluteTimeGetCurrent();
    return returnTime;
    
}

-(void)timerFired:(NSTimer *)theTimer {
    [self.delegate secondElapsed];
}

@end
