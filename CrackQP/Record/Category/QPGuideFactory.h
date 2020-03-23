//
//  QPGuideFactory.h
//  DemoQPSDK
//
//  Created by marco on 9/27/16.
//  Copyright © 2016 lyle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//配合Swizzling，修改拍摄提示

@interface QPGuideFactory : NSObject

+ (UIView*)createRecordDown;
+ (UIView*)createViewBg;
+ (UILabel*)createYellowLabel:(NSString*)title;
+ (UILabel*)createWhiteLabel:(NSString*)title;
+ (void)layoutView:(UIView*)v v1:(UIView*)v1 v2:(UIView*)v2 v3:(BOOL)v3;

@end
