//
//  NSArray+NullCheck.m
//  HongBao
//
//  Created by Ivan on 17/10/13.
//  Copyright © 2017年 ivan. All rights reserved.
//

#import "QPPickerPreviewViewController+Swizzling.h"
#import <objc/runtime.h>


@implementation QPPickerPreviewViewController (Swizzling)

void imagePickerControllerDidCancel(id self,SEL _cmd, UIImagePickerController *picker)
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
 
        class_addMethod([QPPickerPreviewViewController class], @selector(imagePickerControllerDidCancel:), (IMP)imagePickerControllerDidCancel, "v@:@");
        
        
    });
}

@end
