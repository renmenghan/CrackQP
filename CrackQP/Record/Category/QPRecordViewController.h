//
//  QPRecordViewController.h
//  BabyDaily
//
//  Created by marco on 8/26/16.
//  Copyright © 2016 marco. All rights reserved.
//

/**
 *  趣拍视频录制VC
 *
 *  @description 配合Swizzling绕过拍摄页面认证检查
 */

#import <UIKit/UIKit.h>
#import "QPVideo.h"

@interface QPRecordViewController : UIViewController

@property (nonatomic, strong) QPVideo*video;

- (void)checkAuth;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
//- (void)finishRecord;
@end
