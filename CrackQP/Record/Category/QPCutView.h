//
//  QPMediaRender.h
//  DemoQPSDK
//
//  Created by marco on 8/31/16.
//  Copyright © 2016 lyle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  趣拍视频相关类，配合Swizzling可破解拍摄分辨率
 */

@interface QPCutView : UIView

@property (nonatomic, strong) UIView *viewTop;
@property (nonatomic, strong) UIView *viewCenter;
@property (nonatomic, strong) UIScrollView *scrollViewPlayer;
@property (nonatomic, strong) UIImageView *imageViewPlayFlag;
@property (nonatomic, strong) UIView *viewBottom;
@property (nonatomic, strong) UIView *viewCutInfo;

@property (nonatomic, strong) UILabel *labelCutLeft;
@property (nonatomic, strong) UILabel *labelCutRight;
@property (nonatomic, strong) UIView *labelCutMiddle;
@property (nonatomic, strong) UIView *viewProgress;
@property (nonatomic, strong) UIView *collectionView;

@end
