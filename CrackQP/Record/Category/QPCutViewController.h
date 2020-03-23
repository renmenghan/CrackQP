//
//  QPAuth.h
//  XMQuPaiSDK
//
//  Created by marco on 9/27/16.
//  Copyright © 2016 marco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface QPCutViewController : UIViewController


- (void)onClickButtonNextAction:(id)sender;

- (void)finishCutVideo;
- (CGRect)videoFitRectByAVAsset:(AVAsset*)asset;
- (void)setAVPlayerByPlayerItem:(AVPlayerItem*)item;
@end
