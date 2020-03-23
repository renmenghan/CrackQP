//
//  ZHBlock.h
//  BabyDaily
//
//  Created by marco on 9/5/16.
//  Copyright © 2016 marco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHBlock : NSObject

+ (void)dispatchOnMainThread:(void (^)())block;

+ (void)dispatchAfter:(NSTimeInterval)delay onMainThread:(void (^)())block;

+ (void)dispatchOnSynchronousQueue:(void (^)())block;

+ (void)dispatchOnSynchronousFileQueue:(void (^)())block;

+ (void)dispatchOnDefaultPriorityConcurrentQueue:(void (^)())block;
+ (void)dispatchOnLowPriorityConcurrentQueue:(void (^)())block;
+ (void)dispatchOnHighPriorityConcurrentQueue:(void (^)())block;

@end
