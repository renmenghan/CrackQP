//
//  QPMediaRender.h
//  DemoQPSDK
//
//  Created by marco on 8/31/16.
//  Copyright © 2016 lyle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
/**
 *  趣拍视频相关类，配合Swizzling可破解拍摄分辨率
 */

@interface QPCutVideo : NSObject

//available from 1.2.1,offset 表示scrollView中露出的内容的contentOffset归一化值
- (void)cutVideoAVAsset:(AVAsset*)asset
                  range:(CMTimeRange)range
                 offset:(CGPoint)offset
                   size:(CGSize)size
             presetName:(NSString*)preset
                  toURL:(NSURL*)url
          completeBlock:(int(^)(int i))complete;
@end
