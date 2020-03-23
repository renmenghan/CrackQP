//
//  NSArray+NullCheck.m
//  HongBao
//
//  Created by Ivan on 15/10/13.
//  Copyright © 2017年 ivan. All rights reserved.
//

#import "QPGPUImageFiveInputFilter+Swizzling.h"
#import <objc/runtime.h>


@implementation QPGPUImageFiveInputFilter (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        //inject finishRecord
        SEL originalSelector = @selector(newFrameReadyAtTime:atIndex:);
        SEL swizzledSelector = @selector(newFrameReadyAtTime:atIndexX:);


        Method finishOriginalMethod = class_getInstanceMethod(class, originalSelector);
        Method finishSwizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        NSString *p = [NSString  stringWithCString:method_copyArgumentType(finishOriginalMethod,2) encoding:NSUTF8StringEncoding];
        
        IMP finishImp = method_getImplementation(finishOriginalMethod);
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
            class_addMethod([QPGPUImageFiveInputFilter class], @selector(newFrameReadyAtTime:atIndexO:), finishImp, "v@:{?=qilq}i");
#pragma clang diagnostic pop
        });

        method_exchangeImplementations(finishOriginalMethod, finishSwizzledMethod);
        
    });
}


#pragma mark - Method Swizzling
- (void)newFrameReadyAtTime:(CMTime)time
                    atIndexX:(int)index
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    if (CMTIME_IS_VALID(time)) {
        @try {
            [self performSelector:@selector(newFrameReadyAtTime:atIndexO:) withObject:[NSValue valueWithCMTime:time] withObject:@(index)];

        } @catch (NSException *exception) {
            NSLog(@"exception:%@",exception);
        } @finally {
            //NSLog(@"-----------------catch-------------------");
        }
    }
#pragma clang diagnostic pop

}
@end
