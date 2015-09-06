//
//  Wrapper.h
//  Draculapp
//
//  Created by Avery Lamp on 9/4/15.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Wrapper : NSObject


+(NSArray*)processImage:(UIImage*)image live:(BOOL) live;
+(NSArray*)isolateBlood:(UIImage *)image;

+(NSArray*)isolateBloodForSamples:(UIImage *)image;

+(UIImage *)cropImage:(UIImage *)image byRect:(CGRect)rect;



@end
