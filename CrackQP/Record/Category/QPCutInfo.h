//
//  QPCutInfo.h
//  BabyDaily
//
//  Created by marco on 10/12/16.
//  Copyright © 2016 marco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface QPCutInfo : NSObject

@property (nonatomic, assign) CGFloat startTime;
@property (nonatomic, assign) CGFloat endTime;
@property (nonatomic, assign) CGFloat offsetTime;
@property (nonatomic, assign) CGFloat playTime;

@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, assign) int dragRight;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *cutUrl;
@property (nonatomic, assign) float videoDuration;
@property (nonatomic, assign) float cutMaxDuration;
@property (nonatomic, assign) float cutMinDuration;
@property (nonatomic, assign) int thumbnailCount;
@property (nonatomic, strong) NSString *localIdentifier;

@end
