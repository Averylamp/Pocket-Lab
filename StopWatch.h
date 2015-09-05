//
//  StopWatch.h
//  DraculappAccelerometer
//
//  Created by Jake Spracher on 9/4/15.
//  Copyright (c) 2015 Turnt Technologies, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopWatch :NSObject
    @property ( nonatomic, strong ) NSTimer * displayTimer ;
    @property ( nonatomic ) CFAbsoluteTime startTime ;

-(void)startTimer;
-(double)getTimeSinceStart;

@end
