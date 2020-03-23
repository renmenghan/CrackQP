//
//  QPSDKManager.h
//  BabyDaily
//
//  Created by marco on 9/5/16.
//  Copyright © 2016 marco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VisibilityInfoModel.h"
#import "DSPublishCategoryModel.h"

@interface QPRecordCofig : NSObject

@property (nonatomic, assign) BOOL enbaleImport;
@property (nonatomic, assign) BOOL enableMoreMusic;
@property (nonatomic, assign) BOOL enableBeauty;
@property (nonatomic, assign) BOOL enableVideoEffect;
@property (nonatomic, assign) BOOL enableWatermark;
@property (nonatomic, assign) CGFloat MinDuration;
@property (nonatomic, assign) CGFloat MaxDuration;
@property (nonatomic, assign) NSUInteger bitRate;

@property (nonatomic, assign) BOOL showCategory;
@property (nonatomic, strong) NSArray<VisibilityInfoModel> *visibility;
@property (nonatomic, strong) DSPublishCategoryModel<Optional> *mainCategory;
@property (nonatomic, strong) DSPublishCategoryModel<Optional> *subCategory;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, strong) NSString *tag;
//@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, assign) BOOL isImport;


+ (instancetype)defaultConfig;
@end

//@class QPSDKManager;
//
//@protocol QPSDKManagerDelegate <NSObject>
//
//- (void)QPSDKManager:(QPSDKManager*)manager compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath;
//
//- (void)QPSDKManagerDidCancel:(QPSDKManager*)manager;
//
//
//@end

@interface QPSDKManager : NSObject

//@property (nonatomic, weak) id<QPSDKManagerDelegate> delegate;

@property (nonatomic, strong) QPRecordCofig *recordConfig;


+ (instancetype)sharedManager;

- (void)allQuPaiVideo;

- (UIViewController*)createRecordViewControllerWithConfigure:(QPRecordCofig*)config;


@end
