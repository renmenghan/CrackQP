//
//  QPMediaRender.h
//  DemoQPSDK
//
//  Created by marco on 8/31/16.
//  Copyright © 2016 lyle. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  趣拍视频合成导出相关类，配合Swizzling可破解合成前的权限检查
 */
@interface QPMediaRender : NSObject

- (BOOL)checkAuth;

@end
