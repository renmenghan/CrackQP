//
//  NSArray+NullCheck.m
//  HongBao
//
//  Created by Ivan on 17/10/13.
//  Copyright © 2017年 ivan. All rights reserved.
//

#import "QPRecordViewController+Swizzling.h"
#import <objc/runtime.h>
#import "QupaiSDK.h"
#import "QPEventManager.h"
#import "QPSDKManager.h"

@implementation QPRecordViewController (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(checkAuth);
        SEL swizzledSelector = @selector(noCheckAuth);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // 如果 swizzling 的是类方法, 采用如下的方式:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        //交换实现
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
        
        SEL actOriginalSelector = @selector(actionSheet:clickedButtonAtIndex:);
        SEL actSwizzledSelector = @selector(myActionSheet:clickedButtonAtIndex:);
        
        Method actOriginalMethod = class_getInstanceMethod(class, actOriginalSelector);
        Method actSwizzledMethod = class_getInstanceMethod(class, actSwizzledSelector);
        
        //交换实现
        method_exchangeImplementations(actOriginalMethod, actSwizzledMethod);
        
        
        //inject finishRecord
//        SEL finishOriginalSelector = @selector(finishRecord);
//        SEL finishSwizzledSelector = @selector(finishRecordX);
//
//        
//        Method finishOriginalMethod = class_getInstanceMethod(class, finishOriginalSelector);
//        Method finishSwizzledMethod = class_getInstanceMethod(class, finishSwizzledSelector);
//        
//        IMP finishImp = method_getImplementation(finishOriginalMethod);
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored"-Wundeclared-selector"
//            class_addMethod([QPRecordViewController class], @selector(finishRecordOrigin), finishImp, "v@:");
//#pragma clang diagnostic pop
//        });
//
//        method_exchangeImplementations(finishOriginalMethod, finishSwizzledMethod);

    });
}

#pragma mark - Method Swizzling
//- (void)finishRecordX
//{
//    QPSDKManager *sdk = [QPSDKManager sharedManager];
//    sdk.recordConfig.isImport = NO;
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored"-Wundeclared-selector"
//    [self performSelector:@selector(finishRecordOrigin) withObject:nil];
//#pragma clang diagnostic pop
//}

- (void)noCheckAuth {
    NSLog(@"no check auth");
    
//    unsigned int count;
//    //获取属性列表
//    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
//    for (unsigned int i=0; i<count; i++) {
//        const char *propertyName = property_getName(propertyList[i]);
//        NSLog(@"property---->%@", [NSString stringWithUTF8String:propertyName]);
//    }
//    
//    //获取成员变量列表
//    Ivar *ivarList = class_copyIvarList([self class], &count);
//    for (unsigned int i; i<count; i++) {
//        Ivar myIvar = ivarList[i];
//        const char *ivarName = ivar_getName(myIvar);
//        NSLog(@"Ivar---->%@", [NSString stringWithUTF8String:ivarName]);
//    }
}

- (void)myActionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"放弃录制"]) {
        QPVideo *video = self.video;
        [video removeAllPoint];
        
        QupaiSDK *sdk = [QupaiSDK shared];
        [sdk compelete:nil thumbnailPath:nil];
        QPEventManager *manager = [QPEventManager shared];
        [manager event:@"record_abandon"];
    }else {
        if ([buttonTitle isEqualToString:@"重新录制"]) {
            QPVideo *video = self.video;
            [video removeAllPoint];
            QPEventManager *manager = [QPEventManager shared];
            [manager event:@"record_retake"];
            
        }
    }
    
}

@end
