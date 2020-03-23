//
//  QPSDKManager.m
//  BabyDaily
//
//  Created by marco on 9/5/16.
//  Copyright © 2016 marco. All rights reserved.
//

#import "QPSDKManager.h"
#import <QPSDK/QPSDK.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PublishVideoViewController.h"
#import "ALAssetsLibrary+ZHExpand.h"


@interface QPSDKManager ()<TTAlertViewDelegate>

@end

@implementation QPRecordCofig

- (instancetype)init
{
    if (self = [super init]) {
        _enbaleImport = YES;
        _enableMoreMusic = YES;
        _enableBeauty = YES;
        _enableVideoEffect = YES;
        _enableWatermark = NO;
        
        _MinDuration = 1;
        _MaxDuration = 8*60;
        _bitRate = 500000;
        _isImport = NO;
    }
    return self;
}

+ (instancetype)defaultConfig
{
    return [[self alloc]init];
}

@end


@interface QPSDKManager (){
    BOOL _down;
    
}
@property (nonatomic, weak) UIViewController *effectViewController;
@property (nonatomic, weak) UIViewController *recordViewController;
@end

@implementation QPSDKManager

+ (instancetype)sharedManager
{
    static QPSDKManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QPSDKManager alloc] init];
    });
    return instance;
}

- (UIViewController*)recordViewController
{
    if (!_recordViewController) {
        [self createRecordViewControllerWithConfigure:[QPRecordCofig defaultConfig]];
    }
    return _recordViewController;
}

- (UIViewController*)createRecordViewControllerWithConfigure:(QPRecordCofig *)config
{
    _recordConfig = config;
    
    QupaiSDK *sdk = [QupaiSDK shared];
    [sdk setDelegte:(id<QupaiSDKDelegate>)self];
    
    /* 可选设置 */
    [sdk setEnableImport:config.enbaleImport];
    [sdk setEnableMoreMusic:config.enableMoreMusic];
    [sdk setEnableBeauty:config.enableBeauty];
    [sdk setEnableVideoEffect:config.enableVideoEffect];
    [sdk setEnableWatermark:config.enableWatermark];
    [sdk setTintColor:[UIColor colorWithRed:0/255.0 green:200/255.0 blue:200/255.0 alpha:1]];
    [sdk setThumbnailCompressionQuality:0.3];
    [sdk setWatermarkImage:NO ? [UIImage imageNamed:@"watermask"] : nil];
    [sdk setWatermarkPosition:QupaiSDKWatermarkPositionTopRight];
    [sdk setCameraPosition:NO ? QupaiSDKCameraPositionFront : QupaiSDKCameraPositionBack];
    
    /* 基本设置 */
    UIViewController *recordController = [sdk createRecordViewControllerWithMinDuration:config.MinDuration
                                                                            maxDuration:config.MaxDuration
                                                                                bitRate:config.bitRate];
//    NSLog(@"recordController subviews4:%@",recordController.view.subviews[4].subviews);
    NSLog(@"recordController subviews:%@",recordController.view.subviews);
    
    UIView *previewView = recordController.view.subviews[0];
    UIView *progressBackView = recordController.view.subviews[3];
    UIView *topToolView = recordController.view.subviews[2];
    UIView *bottomToolView = recordController.view.subviews[4];
    UIView *progressView = [recordController.view.subviews lastObject];
    
    topToolView.alpha = 0.4;
    
    CGRect framePre = previewView.frame;
    CGRect framePro = progressBackView.frame;
    
    framePre.origin.y = 0;
    framePre.size.height = framePro.size.width *4/3.;
    previewView.frame = framePre;
    
    framePro.size.height = 10;
    framePro.origin.y = framePre.origin.y + framePre.size.height;
    progressView.frame = framePro;
    progressBackView.frame = framePro;
    
    //修改 GPUImageView同级backView的尺寸
    UIView *gpuView = previewView.subviews[0];
    UIView *backView = previewView.subviews[1];
    CGRect frameGpu = gpuView.frame;
    CGRect frameGpuback = backView.frame;
    frameGpu.size = framePre.size;
    frameGpuback.size = framePre.size;
    gpuView.frame = frameGpu;
    backView.frame = frameGpuback;
    
    //修改 backView上maskView的尺寸
    UIView *backViewMask = previewView.subviews[1].subviews[0];
    CGRect frameBackMask = backViewMask.frame;
    frameBackMask.size = framePre.size;
    backViewMask.frame = frameBackMask;
    
    CGRect frameBottom = bottomToolView.frame;
    frameBottom.origin.y = CGRectGetMaxY(progressBackView.frame);
    frameBottom.size.height = CGRectGetHeight([UIScreen mainScreen].bounds) - frameBottom.origin.y;
    bottomToolView.frame = frameBottom;
//
//    NSLog(@"preview subviews:%@",previewView.subviews);
//    NSLog(@"2 recordController subviews:%@",recordController.view.subviews);
    
    
    UIButton *beautyButton = topToolView.subviews[3];
    UIButton *countdownButton = topToolView.subviews[2];
    //UIButton *cancelButton = topToolView.subviews[0];


    UIButton *torchButton = [[UIButton alloc]initWithFrame:CGRectMake(beautyButton.frame.origin.x - 54, beautyButton.frame.origin.y, 36, 50)];
    [torchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [torchButton setImage:[UIImage imageNamed:@"QPSDK.bundle/record_ico_flashlight"] forState:UIControlStateNormal];
    [torchButton setImage:[UIImage imageNamed:@"QPSDK.bundle/record_ico_flashlight_1"] forState:UIControlStateSelected];
    [torchButton addTarget:self action:@selector(torchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [topToolView addSubview:torchButton];
   
    [countdownButton addTarget:self action:@selector(countdownButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    
    
//    //勾
    UIButton *recordButton = (UIButton*)[bottomToolView.subviews objectAtIndex:1];
    UIButton *rightButton = (UIButton*)[bottomToolView.subviews objectAtIndex:0];
    UIButton *leftButton = (UIButton*)[bottomToolView.subviews objectAtIndex:2];
//
//    //调
    if (IS_IPHONE4) {
        recordButton.width = 40;
        recordButton.height = 40;
        recordButton.centerX = SCREEN_WIDTH/2;
    }
    recordButton.centerY = bottomToolView.height/2;
    rightButton.centerY = recordButton.centerY;
    leftButton.centerY = recordButton.centerY;
//
//    //去
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored"-Wundeclared-selector"
//    
//    [recordButton removeTarget:recordController.view action:@selector(buttonRecordDownAction:) forControlEvents:UIControlEventTouchDown];
//    [recordButton removeTarget:recordController.view action:@selector(buttonRecordUpAction:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
//    
//#pragma clang diagnostic pop
//    
//    //加
//    [recordButton addTarget:self action:@selector(longButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [recordButton addTarget:self action:@selector(recordButtonDown:) forControlEvents:UIControlEventTouchDown];

    
    
//    UIButton *longButton = [[UIButton alloc]initWithFrame:CGRectMake(recordButton.frame.origin.x, recordButton.frame.origin.y + recordButton.frame.size.height+10, 100, 32)];
//    longButton.layer.borderColor = [UIColor purpleColor].CGColor;
//    longButton.layer.cornerRadius = 4;
//    longButton.layer.borderWidth = 1;
//    [longButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [longButton setTitle:@"点击拍摄" forState:UIControlStateNormal];
//    [longButton setTitle:@"点击停止" forState:UIControlStateSelected];
//    [longButton addTarget:self action:@selector(longButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomToolView addSubview:longButton];
    
    
    //下一步按钮
//    UIButton *button2 = (UIButton*)[recordController.view.subviews[4].subviews objectAtIndex:2];
//    [button2 addTarget:self action:@selector(nextButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    NSLog(@"button2,target:%@,%@  all:%lx",recordButton.allTargets,[recordButton actionsForTarget:recordController.view forControlEvent:UIControlEventTouchUpOutside],(unsigned long)recordButton.allControlEvents);
    _recordViewController = recordController;
    return recordController;
}

- (void)qupaiSDK:(id<QupaiSDKDelegate>)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath
{
    
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    switch (status) {
        case ALAuthorizationStatusAuthorized:
            
            break;
        case ALAuthorizationStatusNotDetermined:
            
            break;
        case ALAuthorizationStatusDenied:
        case ALAuthorizationStatusRestricted:
            
            break;
        default:
            break;
    }

    if (videoPath) {
        NSLog(@"Qupai SDK compelete %@",videoPath);

        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library zh_saveVideoWithVideoPath:videoPath toAlbum:@"小爱豆" saveSuccessBlock:^(ALAssetsGroup *group, NSURL *assetURL, ALAsset *asset) {
            
        } saveFaieldBlock:^(NSError *error) {
            
        }];
        
//        if (thumbnailPath) {
//            UIImageWriteToSavedPhotosAlbum([UIImage imageWithContentsOfFile:thumbnailPath], nil, nil, nil);
//        }
        
        PublishVideoViewController *vc = [[PublishVideoViewController alloc]init];
        vc.videoPath = videoPath;
        vc.coverPath = thumbnailPath;
        vc.isImport = self.recordConfig.isImport;
        vc.showCategory = self.recordConfig.showCategory;
        vc.visibility = self.recordConfig.visibility;
        vc.mainCategory = self.recordConfig.mainCategory;
        vc.subCategory = self.recordConfig.subCategory;
        vc.tag = self.recordConfig.tag;
        //vc.token = self.recordConfig.token;
        vc.from = self.recordConfig.from;
        vc.recordDate = [[NSDate date] timeIntervalSince1970];
        vc.categoryId = self.recordConfig.categoryId;
        [_recordViewController.navigationController pushViewController:vc animated:YES];
        
    }else{
        [_recordViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (NSArray *)qupaiSDKMusics:(id<QupaiSDKDelegate>)sdk
{
    NSString *baseDir = [[NSBundle mainBundle] bundlePath];
    NSString *configPath = [[NSBundle mainBundle] pathForResource:_down ? @"music2" : @"music1" ofType:@"json"];
    NSData *configData = [NSData dataWithContentsOfFile:configPath];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingAllowFragments error:nil];
    NSArray *items = dic[@"music"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *item in items) {
        NSString *path = [baseDir stringByAppendingPathComponent:item[@"resourceUrl"]];
        QPEffectMusic *effect = [[QPEffectMusic alloc] init];
        effect.name = item[@"name"];
        effect.eid = [item[@"id"] intValue];
        effect.musicName = [path stringByAppendingPathComponent:@"audio.mp3"];
        effect.icon = [path stringByAppendingPathComponent:@"icon.png"];
        [array addObject:effect];
    }
    return array;
}

- (void)qupaiSDKShowMoreMusicView:(id<QupaiSDKDelegate>)sdk viewController:(UIViewController *)viewController
{
    //QPMoreMusicViewController *music = [[QPMoreMusicViewController alloc] initWithNibName:@"QPMoreMusicViewController" bundle:nil];
    //[viewController presentViewController:music animated:YES completion:nil];
    if (_down) {
        self.effectViewController = viewController;
        TTAlertView *alert = [[TTAlertView alloc]initWithTitle:@"提示" message:@"没有更多音乐" containerView:nil delegate:self confirmButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    _down = YES;
    QupaiSDK *qupaisdk = [QupaiSDK shared];
    [qupaisdk updateMoreMusic];
    //强制加载音乐
    [viewController viewWillAppear:NO];
}

- (void)longButtonTapped:(UIButton*)button
{
    button.selected = !button.selected;
    id target = self.recordViewController.view;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    if (button.selected) {
        [target performSelector:@selector(buttonRecordDownAction:) withObject:nil];
        
    }else{
        [target performSelector:@selector(buttonRecordUpAction:) withObject:nil];
        
        //        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        //        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        //            [target performSelector:@selector(buttonAction:) withObject:[self.recordViewController.view.subviews[4].subviews objectAtIndex:2]];
        //        });
    }
#pragma clang diagnostic pop
}

- (void)recordButtonDown:(UIButton*)button
{
    self.recordConfig.isImport = NO;
}

- (void)countdownButtonTapped:(UIButton*)button
{
    self.recordConfig.isImport = NO;
}


- (void)torchButtonTapped:(UIButton*)button
{
    button.selected = !button.selected;
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        [device lockForConfiguration:nil];
        if ( [device hasTorch] ) {
            if ( button.selected ) {
                [device setTorchMode:AVCaptureTorchModeOn];
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
            }
        }
        [device unlockForConfiguration];
    }
}

#pragma mark -TTAlertViewDelegate
- (void)alertView:(TTAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //强制刷新播放
    [self.effectViewController viewWillAppear:NO];
}

#pragma mark -Private
- (void)allQuPaiVideo
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    docDir = [docDir stringByAppendingString:@"/com.duanqu.qupaisdk"];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docDir error:nil];
    NSLog(@"tmplist:%@",tmplist);
}

//- (void)saveVideoToDocuments:(NSString*)oFilePath
//{
//    NSString *fileName = oFilePath.lastPathComponent;
//    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    docDir = [docDir stringByAppendingPathComponent:BBVideoFolder];
//    NSString *nFilePath = [NSString stringWithFormat:@"%@/%@",docDir,fileName];
//    [[NSFileManager defaultManager] copyItemAtPath:nFilePath toPath:oFilePath error:nil];
//}

@end
