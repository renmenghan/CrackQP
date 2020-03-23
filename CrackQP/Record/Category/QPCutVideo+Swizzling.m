//
//  NSArray+NullCheck.m
//  HongBao
//
//  Created by Ivan on 17/10/13.
//  Copyright © 2017年 ivan. All rights reserved.
//

#import "QPCutVideo+Swizzling.h"
#import <objc/runtime.h>


@implementation QPCutVideo (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(cutVideoAVAsset:range:offset:size:presetName:toURL:completeBlock:);
        SEL swizzledSelector = @selector(cutVideoAVAsset:range:offset:size:presetName:toURL:completeBlockX:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // 如果 swizzling 的是类方法, 采用如下的方式:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        //交换实现
        //method_exchangeImplementations(originalMethod, swizzledMethod);
        
//        u_int               count;
//        Method*    methods= class_copyMethodList(class, &count);
//        for (int i = 0; i < count ; i++)
//        {
//            SEL name = method_getName(methods[i]);
//            NSString *strName = [NSString  stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
//            NSLog(@"-----------%@--------------",strName);
//        }
        
        
        
    });
}

#pragma mark - Method Swizzling

- (void)cutVideoAVAsset:(AVAsset*)asset
                  range:(CMTimeRange)range
                 offset:(CGPoint)offset
                   size:(CGSize)size //640x640
             presetName:(NSString*)preset
                  toURL:(NSURL*)url
          completeBlockX:(int(^)(int i))complete
{
    NSLog(@"print");
}
@end
