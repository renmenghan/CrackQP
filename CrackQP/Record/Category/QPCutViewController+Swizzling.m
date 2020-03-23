//
//  NSArray+NullCheck.m
//  HongBao
//
//  Created by Ivan on 17/10/13.
//  Copyright © 2017年 ivan. All rights reserved.
//

#import "QPCutViewController+Swizzling.h"
#import <objc/runtime.h>
#import "QPCutInfo.h"
#import "QPSDKManager.h"

@implementation QPCutViewController (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(onClickButtonNextAction:);
        SEL swizzledSelector = @selector(onClickButtonNextActionX:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        //交换实现
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
        
        SEL originalXSelector = @selector(setAVPlayerByPlayerItem:);
        SEL swizzledXSelector = @selector(setAVPlayerByPlayerItemX:);
        
        Method originalXMethod = class_getInstanceMethod(class, originalXSelector);
        Method swizzledXMethod = class_getInstanceMethod(class, swizzledXSelector);
        
        //交换实现
        //method_exchangeImplementations(originalXMethod, swizzledXMethod);
        
        SEL originalYSelector = @selector(videoFitRectByAVAsset:);
        SEL swizzledYSelector = @selector(videoFitRectByAVAssetX:);
        
        Method originalYMethod = class_getInstanceMethod(class, originalYSelector);
        Method swizzledYMethod = class_getInstanceMethod(class, swizzledYSelector);
        
        //交换实现
       //method_exchangeImplementations(originalYMethod, swizzledYMethod);
    });
    
   
}

#pragma mark - Method Swizzling

- (void)onClickButtonNextActionX:(id)sender {
    Ivar ivar = class_getInstanceVariable([self class], "_cutInfo");
    QPCutInfo *cutInfo = (QPCutInfo*)object_getIvar(self, ivar);
    CGFloat runtime = cutInfo.endTime - cutInfo.startTime;
    QPSDKManager *sdk = [QPSDKManager sharedManager];
    if (runtime <= sdk.recordConfig.MaxDuration) {
        sdk.recordConfig.isImport = YES;
        [self finishCutVideo];
    }else{
        TTAlertView *alert = [[TTAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"剪裁后的视频长度不能超过%ds",(int)sdk.recordConfig.MaxDuration] containerView:nil delegate:nil confirmButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)setAVPlayerByPlayerItemX:(AVPlayerItem*)item
{
    AVAsset *asset = item.asset;
    CGRect rect = [self videoFitRectByAVAsset:asset];
    NSLog(@"rect(0,40,240,320)");
}

- (CGRect)videoFitRectByAVAssetX:(AVAsset*)asset
{
    return CGRectMake(0, 0, 240, 320);
}

@end
