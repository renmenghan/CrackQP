//
//  NSArray+NullCheck.m
//  HongBao
//
//  Created by Ivan on 17/10/13.
//  Copyright © 2017年 ivan. All rights reserved.
//

#import "QPVideo+Swizzling.h"
#import <objc/runtime.h>
#import "QPSDKManager.h"

@implementation QPVideo (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(size);
        SEL swizzledSelector = @selector(sizeX);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // 如果 swizzling 的是类方法, 采用如下的方式:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        //交换实现
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

#pragma mark - Method Swizzling

- (CGSize)sizeX {
    QPSDKManager *sdk = [QPSDKManager sharedManager];
    if (sdk.recordConfig.isImport) {
        //return CGSizeMake(480, 480);
        return CGSizeMake(640, 640);
    }
    //return CGSizeMake(360, 480);
    //return CGSizeMake(480, 480);
    //return CGSizeMake(640, 640);
    return CGSizeMake(480, 640);
}
@end
