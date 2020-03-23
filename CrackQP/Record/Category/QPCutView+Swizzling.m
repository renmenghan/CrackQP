//
//  NSArray+NullCheck.m
//  HongBao
//
//  Created by Ivan on 17/10/13.
//  Copyright © 2017年 ivan. All rights reserved.
//

#import "QPCutView+Swizzling.h"
#import <objc/runtime.h>


@implementation QPCutView (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(layoutSubviewsX);
        
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
- (void)layoutSubviewsX
{
    
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    CGRect viewCenter = self.viewTop.frame;
//    NSLog(@"viewTop:(%f,%f,%f,%f)",0.,viewCenter.origin.y,viewCenter.size.width,viewCenter.size.height);
//    viewCenter = self.viewCenter.frame;
//    //viewCenter.origin.y = 0;
//    viewCenter.size.height = viewCenter.size.width*4/3.;
//    self.viewCenter.frame = viewCenter;
//    NSLog(@"viewCenter:(%f,%f,%f,%f)",0.,viewCenter.origin.y,viewCenter.size.width,viewCenter.size.height);
//    NSLog(@"center subviews:%@",self.viewCenter.subviews);
//    viewCenter = self.viewBottom.frame;
//    viewCenter.origin.y = CGRectGetMaxY(self.viewCenter.frame);
//    viewCenter.size.height = SCREEN_HEIGHT - viewCenter.origin.y;
//    self.viewBottom.frame = viewCenter;
//    NSLog(@"viewBottom:(%f,%f,%f,%f)",0.,viewCenter.origin.y,viewCenter.size.width,viewCenter.size.height);
//    viewCenter = self.scrollViewPlayer.frame;
//    viewCenter.size.height = viewCenter.size.width*4/3.;
//    //self.scrollViewPlayer.frame = viewCenter;
//    //self.scrollViewPlayer.contentSize = self.scrollViewPlayer.frame.size;
//    self.scrollViewPlayer.transform = CGAffineTransformMakeScale(1,1);
//    NSLog(@"scrollViewPlayer:(%f,%f,%f,%f)",0.,viewCenter.origin.y,viewCenter.size.width,viewCenter.size.height);
//    viewCenter = self.viewCutInfo.frame;
//    NSLog(@"viewCutInfo:(%f,%f,%f,%f)",0.,viewCenter.origin.y,viewCenter.size.width,viewCenter.size.height);
//    viewCenter = self.collectionView.frame;
//    NSLog(@"collectionView:(%f,%f,%f,%f)",0.,viewCenter.origin.y,viewCenter.size.width,viewCenter.size.height);
//}
@end
