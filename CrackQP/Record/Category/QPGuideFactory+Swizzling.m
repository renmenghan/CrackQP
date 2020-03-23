//
//  NSArray+NullCheck.m
//  HongBao
//
//  Created by Ivan on 17/10/13.
//  Copyright © 2017年 ivan. All rights reserved.
//

#import "QPGuideFactory+Swizzling.h"
#import <objc/runtime.h>


@implementation QPGuideFactory (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//        
        SEL originalSelector = @selector(createRecordDown);
        SEL swizzledSelector = @selector(createRecordDownX);
        
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // 如果 swizzling 的是类方法, 采用如下的方式:
         Class class = object_getClass((id)self);
        
         Method originalMethod = class_getClassMethod(class, originalSelector);
         Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        //交换实现
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

#pragma mark - Method Swizzling

+ (UIView*)createRecordDownX {
    UIView *backView = [self createViewBg];
    UILabel *yellowLabel = [self createYellowLabel:@"点击"];
    UILabel *whiteLabel = [self createWhiteLabel:@"拍摄按钮进行拍摄"];
    [backView addSubview:yellowLabel];
    [backView addSubview:whiteLabel];
    [self layoutView:backView v1:yellowLabel v2:whiteLabel v3:NO];
    return backView;
}
@end
