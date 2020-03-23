//
//  UploadTaskModel.h
//  BabyDaily
//
//  Created by marco on 10/19/16.
//  Copyright © 2016 marco. All rights reserved.
//

#import "FDShareModel.h"

typedef NS_ENUM(NSUInteger, BBUploadStatus) {
    BBUploadStatusInactive,
    BBUploadStatusWaiting,
    BBUploadStatusUploading,
    BBUploadStatusSuccess,
    BBUploadStatusFailed,
    BBUploadStatusCanceled
};

typedef NS_ENUM(NSUInteger, ShareType) {
    ShareTypeNone,
    ShareTypeTimeline,
    ShareTypeWeixin,
    ShareTypeWeibo,
    ShareTypeQQ,
    ShareTypeQzone
};

@interface UploadTaskModel : BaseModel<NSCoding>

@property (nonatomic, strong) NSString *videoName;


//七牛视频key
@property (nonatomic, strong) NSString *video;

//发布信息
@property (nonatomic, strong) NSString *visibilityId;
//@property (nonatomic, strong) NSString *visibilityName;

@property (nonatomic, strong) NSString *childId;
//@property (nonatomic, strong) NSString *childName;

@property (nonatomic, strong) NSString *ageId;
//@property (nonatomic, strong) NSString *ageName;

@property (nonatomic, strong) NSString *mainCateId;
//@property (nonatomic, strong) NSString *mainCateName;

@property (nonatomic, strong) NSString *subCateId;
//@property (nonatomic, strong) NSString *subCateName;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *cover;

@property (nonatomic, copy) NSString *title;

//上传完之后的share信息
@property (nonatomic, strong) FDShareModel <Optional>*share;

@property (nonatomic, assign) BBUploadStatus status;

//是否取消标识
@property (nonatomic, assign) BOOL flag;

//是否是导入视频
@property (nonatomic, assign) BOOL isImport;

//上传进度
@property (nonatomic, assign) float percent;

@property (nonatomic, assign) NSTimeInterval recordDate;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, assign) BOOL tokenUpdated;

@property (nonatomic, assign) ShareType shareType;


//分享类型 0:timeline 1:weixin 2:weibo
//@property (nonatomic, assign) int shareType;

- (instancetype)initModel;

- (NSString*)savedVideoPath;

@end
