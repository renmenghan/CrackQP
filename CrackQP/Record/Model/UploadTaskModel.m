//
//  UploadTaskModel.m
//  BabyDaily
//
//  Created by marco on 10/19/16.
//  Copyright © 2016 marco. All rights reserved.
//

#import "UploadTaskModel.h"

#define BBVideoFolder      @"bbvideos"


@implementation UploadTaskModel

- (instancetype)initModel
{
    if (self = [super init]) {
        //_shareType = -1;
        _flag = NO;
        _percent = 0.f;
        _status = BBUploadStatusInactive;
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_videoName forKey:@"videoName"];
    //[aCoder encodeObject:_videoPath forKey:@"videoPath"];
    [aCoder encodeObject:_video forKey:@"video"];
    [aCoder encodeObject:_visibilityId forKey:@"visibilityId"];
    [aCoder encodeObject:_childId forKey:@"childId"];
    [aCoder encodeObject:_ageId forKey:@"ageId"];
    [aCoder encodeObject:_mainCateId forKey:@"mainCateId"];
    [aCoder encodeObject:_subCateId forKey:@"subCateId"];
    [aCoder encodeObject:_desc forKey:@"desc"];
    [aCoder encodeObject:_cover forKey:@"cover"];
    [aCoder encodeInteger:_status forKey:@"status"];
    [aCoder encodeBool:_flag forKey:@"flag"];
    [aCoder encodeBool:_isImport forKey:@"isImport"];
    [aCoder encodeBool:_tokenUpdated forKey:@"tokenUpdated"];
    [aCoder encodeFloat:_percent forKey:@"percent"];
    [aCoder encodeDouble:_recordDate forKey:@"recordDate"];
    [aCoder encodeObject:_from forKey:@"from"];
    [aCoder encodeObject:_token forKey:@"token"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeInteger:_shareType forKey:@"shareType"];
    [aCoder encodeObject:_categoryId forKey:@"categoryId"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self != nil) {
        self.videoName=[aDecoder decodeObjectForKey:@"videoName"];
        //self.videoPath=[aDecoder decodeObjectForKey:@"videoPath"];
        self.video=[aDecoder decodeObjectForKey:@"video"];
        self.visibilityId=[aDecoder decodeObjectForKey:@"visibilityId"];
        self.childId=[aDecoder decodeObjectForKey:@"childId"];
        self.ageId=[aDecoder decodeObjectForKey:@"ageId"];
        self.mainCateId=[aDecoder decodeObjectForKey:@"mainCateId"];
        self.subCateId=[aDecoder decodeObjectForKey:@"subCateId"];
        self.desc=[aDecoder decodeObjectForKey:@"desc"];
        self.cover=[aDecoder decodeObjectForKey:@"cover"];
        self.status=[aDecoder decodeIntegerForKey:@"status"];
        self.flag=[aDecoder decodeBoolForKey:@"flag"];
        self.isImport=[aDecoder decodeBoolForKey:@"isImport"];
        self.tokenUpdated=[aDecoder decodeBoolForKey:@"tokenUpdated"];
        self.percent=[aDecoder decodeFloatForKey:@"percent"];
        self.recordDate=[aDecoder decodeDoubleForKey:@"recordDate"];
        self.from=[aDecoder decodeObjectForKey:@"from"];
        self.token=[aDecoder decodeObjectForKey:@"token"];
        self.title=[aDecoder decodeObjectForKey:@"title"];
        self.shareType=[aDecoder decodeObjectForKey:@"shareType"];
        self.categoryId=[aDecoder decodeObjectForKey:@"categoryId"];
    }
    return self;
}

- (NSString*)savedVideoPath
{
    if ([UserService sharedService].userId) {
        NSString *fileName = self.videoName;
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        docDir = [docDir stringByAppendingPathComponent:[UserService sharedService].userId];
        NSString *nFilePath = [NSString stringWithFormat:@"%@/%@",docDir,fileName];
        return nFilePath;
    }
    return nil;
}

@end
