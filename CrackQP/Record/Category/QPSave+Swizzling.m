//
//  QPSave+Swizzling.m
//  DemoQPSDK
//
//  Created by marco on 9/27/16.
//  Copyright © 2016 lyle. All rights reserved.
//

#import "QPSave+Swizzling.h"
#import <objc/runtime.h>

@implementation QPSave(Swizzling)


//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//        
//        SEL originalSelector = @selector(recordGuide);
//        SEL swizzledSelector = @selector(recordGuideX);
//        
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//        
//        // 如果 swizzling 的是类方法, 采用如下的方式:
//        // Class class = object_getClass((id)self);
//        // ...
//        // Method originalMethod = class_getClassMethod(class, originalSelector);
//        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
//        
//        //交换实现
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    });
//}
//
//#pragma mark - Method Swizzling
//
//- (BOOL)recordGuideX {
//    
//    return YES;
//}
@end
