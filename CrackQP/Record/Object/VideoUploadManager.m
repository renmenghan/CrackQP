//
//  VideoUploadManager.m
//  BabyDaily
//
//  Created by marco on 10/19/16.
//  Copyright © 2016 marco. All rights reserved.
//

#import "VideoUploadManager.h"
#import "QiNiuTool.h"
#import "PublishRequest.h"
#import "PublishVideoViewController.h"

#define DraftPlistName     @"bbdrafts.plist"

NSString *const videoUploadTaskEnqueueNotification = @"videoUploadTaskEnqueueNotification";
//NSString *const videoUploadTaskDequeueNotification = @"videoUploadTaskDequeueNotification";
NSString *const videoUploadTaskFinishNotification = @"videoUploadTaskFinishNotification";
NSString *const videoUploadTaskCancelNotification = @"videoUploadTaskCancelNotification";

@interface VideoUploadManager ()
@property (nonatomic, assign) BOOL isUploading;

//@property (nonatomic, strong) NSMutableArray *draftTasks;
@property (nonatomic, strong) NSMutableArray *activitedTasks;
@property (nonatomic, strong) NSMutableArray *historyTasks;

//@property (nonatomic, assign) NSInteger currentIndex;
//@property (nonatomic, assign) NSInteger nextIndex;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSDate *lastTokenUpdateDate;
@property (nonatomic, assign) BOOL needUpdateToken;


@property (nonatomic, weak) UploadTaskModel *currentTask;
@property (nonatomic, weak) UploadTaskModel *nextTask;
@end

@implementation VideoUploadManager

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)sharedManager
{
    static VideoUploadManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VideoUploadManager alloc] init];
    });
    return instance;
}

- (void)stopAndClear
{
    if (self.isUploading) {
        self.currentTask.flag = YES;
        self.nextTask = nil;
    }
    self.needUpdateToken = YES;
    self.lastTokenUpdateDate = [NSDate dateWithTimeIntervalSince1970:0];
    [self.activitedTasks removeAllObjects];
    [self.historyTasks removeAllObjects];
}

- (void)userLogin
{
    [self.activitedTasks removeAllObjects];
    [self loadUnfinishedTask];
}

- (void)userLogout
{
    [self stopAndClear];
}

- (instancetype)init
{
    if (self = [super init]) {
        _isUploading = NO;
        _activitedTasks = [NSMutableArray array];
        _lastTokenUpdateDate = [NSDate dateWithTimeIntervalSince1970:0];
        [self loadUnfinishedTask];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:kNOTIFY_USER_LOGOUT_COMPLETED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kNOTIFY_USER_LOGIN_COMPLETED object:nil];

    }
    return self;
}


- (void)loadUnfinishedTask
{
    if (!IsEmptyString([UserService sharedService].userId)) {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *userFolder = [documentsDirectory stringByAppendingPathComponent:[UserService sharedService].userId];
        
        NSString *plistPath = [userFolder stringByAppendingPathComponent:DraftPlistName];
        self.historyTasks = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
        for (UploadTaskModel *task in self.historyTasks) {
            task.status = BBUploadStatusInactive;
            task.flag = NO;
            task.percent = 0.f;
        }
        if (!self.historyTasks) {
            self.historyTasks = [NSMutableArray array];
        }
    }
}

- (void)saveUnfinishedTask:(NSArray*)tasks
{
    if (!IsEmptyString([UserService sharedService].userId)) {

        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *userFolder = [documentsDirectory stringByAppendingPathComponent:[UserService sharedService].userId];
        NSString *plistPath = [userFolder stringByAppendingPathComponent:DraftPlistName];

        BOOL success = [NSKeyedArchiver archiveRootObject:tasks toFile:plistPath];
        NSLog(@"save:%@",success?@"success":@"failed");
    }
}

- (void)synchronize
{
    NSMutableArray *tasks = [NSMutableArray arrayWithArray:self.historyTasks];
    [tasks addObjectsFromSafeArray:self.activitedTasks];
    [self saveUnfinishedTask:tasks];
}

- (void)enqueueUploadTask:(UploadTaskModel*)task
{
//    if (task.video) {
//        task.status = BBUploadStatusSuccess;
//        [self publishTask:task];
//    }else{
        task.status = BBUploadStatusWaiting;
        [self.activitedTasks addSafeObject:task];
        if ([self isHistoryTask:task]) {
            [self.historyTasks removeObject:task];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:videoUploadTaskEnqueueNotification object:nil];
        [self synchronize];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startUploadTaskIfNeed:task];
        });
    //}
    
}

- (void)activateUploadTask:(UploadTaskModel*)task
{
    if (![self isActivatedTask:task]) {
        return;
    }

    if (task.status == BBUploadStatusFailed||
        task.status == BBUploadStatusCanceled) {

        NSInteger index = [self.activitedTasks indexOfObject:task];
        if (index != NSNotFound) {
            if (self.isUploading) {
                self.nextTask = task;
            }else{
                [self startUploadTaskIfNeed:task];
            }
        }
    }
}

- (void)deactivateUploadTask:(UploadTaskModel*)task
{
    if (![self isActivatedTask:task]) {
        return;
    }
    if (task.status == BBUploadStatusCanceled) {
        task.status = BBUploadStatusInactive;
        [self.historyTasks addSafeObject:task];
        [self.activitedTasks removeObject:task];
        [self synchronize];
    }
}


- (void)startUploadTaskIfNeed:(UploadTaskModel*)task
{
    if (!self.isUploading) {
        
        if (![self isActivatedTask:task]) {
            return;
        }
        
        //设置currentIndex
        self.currentTask = task;
        
        [self searchNextTask:task];
        
        //上传
        if (IsEmptyString(task.video)) {
            //复位
            task.flag = NO;
            task.percent = 0.f;
            
            [self refreshTokenIfNeed:^(BOOL success) {
                if (success) {
                    [self uploadTask:task];
                }else{
                    task.status = BBUploadStatusFailed;
                    [self finishUploadTask:task];
                }
            }];
            
        }else{
            [self publishTask:task];
        }
    }
}

- (void)uploadNext
{
    if (self.nextTask) {
        [self startUploadTaskIfNeed:self.nextTask];
    }
}

- (void)searchNextTask:(UploadTaskModel*)task
{
    if (![self isActivatedTask:task]) {
        return;
    }

    self.nextTask = nil;
    NSInteger index = [self.activitedTasks indexOfObject:task];

    //搜索下个任务
    for (NSInteger i = index+1; i < self.activitedTasks.count; i++) {
        UploadTaskModel *t = [self.activitedTasks safeObjectAtIndex:i];
        if (t.status == BBUploadStatusWaiting) {
            self.nextTask = t;
            return;
        }
    }
}

- (BOOL)isActivatedTask:(UploadTaskModel*)task
{
    return [self.activitedTasks containsObject:task];
//    BOOL isActivated = NO;
//    for (UploadTaskModel *model in self.activitedTasks) {
//        if ([model.videoName isEqualToString:task.videoName]) {
//            isActivated = YES;
//        }
//    }
//    return isActivated;
}

- (BOOL)isHistoryTask:(UploadTaskModel*)task
{
    return [self.historyTasks containsObject:task];
//    BOOL isLast = NO;
//    for (UploadTaskModel *model in self.historyTasks) {
//        if ([model.videoName isEqualToString:task.videoName]) {
//            isLast = YES;
//        }
//    }
//    return isLast;
}


- (void)cancelUploadTask:(UploadTaskModel*)task
{
    if (![self isActivatedTask:task]) {
        return;
    }
    
    if (task.status == BBUploadStatusUploading) {
        task.flag = YES;
    }else if (task.status == BBUploadStatusWaiting) {
        
        if (self.nextTask == task) {
            [self searchNextTask:task];
        }
        task.status = BBUploadStatusCanceled;
        [self finishUploadTask:task];
    }else if (task.status == BBUploadStatusFailed||
              task.status == BBUploadStatusCanceled) {
        task.status = BBUploadStatusCanceled;
        [self finishUploadTask:task];
    }
}

- (void)deleteHistoryTask:(UploadTaskModel*)task
{
    [self.historyTasks removeObject:task];
    [self deleteVideoAtPath:[task savedVideoPath]];
    [self synchronize];
}

- (void)saveAsHistoryTask:(UploadTaskModel*)task
{
    [self.historyTasks addSafeObject:task];
    [self synchronize];
}


- (void)deleteActivatedTask:(UploadTaskModel*)task
{
    [self.activitedTasks removeObject:task];
    [self deleteVideoAtPath:[task savedVideoPath]];
    [self synchronize];
}

- (void)deleteVideoAtPath:(NSString*)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:path error:nil];
}

- (void)uploadTask:(UploadTaskModel*)task
{
    self.isUploading = YES;
    task.status = BBUploadStatusUploading;
    [QiNiuTool simpleUploadFile:[task savedVideoPath] token:self.token progressHandler:^(NSString *key, float percent) {
        
        task.percent = percent;
        
    } cancellationSignal:^BOOL(){
        BOOL flag = task.flag;
        return flag;
    } complete:^(int statusCode,NSDictionary *resp){
        if (statusCode == kQNRequestCancelled) {
            task.status = BBUploadStatusFailed;
            [self finishUploadTask:task];
        }else if (statusCode == kQNInvalidToken||statusCode == 401) {
            self.needUpdateToken = YES;
            [self refreshTokenIfNeed:^(BOOL success) {
                task.status = BBUploadStatusFailed;
                [self finishUploadTask:task];
            }];
        }else {
            if (!resp) {
                task.status = BBUploadStatusFailed;
                [self finishUploadTask:task];
            }else{
                task.video = [resp objectForKey:@"key"];
                [self publishTask:task];
            }
        }
    }];
}

- (void)stopAllTasks
{
    if (!self.nextTask) {
        
    }
}


- (void)refreshTokenIfNeed:(void(^)(BOOL success))complete
{
    NSTimeInterval lifetime = [[NSDate date] timeIntervalSinceDate:self.lastTokenUpdateDate];
    if (lifetime >= 3600 || self.needUpdateToken) {
        [PublishRequest getUploadTokenWithParams:nil success:^(PVUploadTokenResultModel *resultModel) {
            self.token = resultModel.token;
            self.lastTokenUpdateDate = [NSDate date];
            self.needUpdateToken = NO;
            if(complete) complete(YES);
        } failure:^(StatusModel *status) {
            if(complete) complete(NO);
        }];
    }else{
        if(complete) complete(YES);
    }
}

- (void)publishTask:(UploadTaskModel*)task
{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setSafeObject:task.title forKey:@"title"];
    [params setSafeObject:task.cover forKey:@"cover"];
    [params setSafeObject:task.video forKey:@"video"];
    [params setSafeObject:task.desc forKey:@"content"];
//    [params setSafeObject:task.childId forKey:@"children"];
//    [params setSafeObject:task.mainCateId forKey:@"mainCategory"];
//    [params setSafeObject:task.subCateId forKey:@"subCategory"];
    [params setSafeObject:task.visibilityId forKey:@"visible"];
    [params setSafeObject:task.categoryId forKey:@"categoryId"];
//    [params setSafeObject:task.ageId forKey:@"age"];
    
    [PublishRequest publishVideoWithParams:params success:^(PublishResultModel *resultModel){
        task.share = resultModel.share;
        task.status = BBUploadStatusSuccess;
        [self finishUploadTask:task];
    } failure:^(StatusModel *status) {
        task.status = BBUploadStatusFailed;
        [self finishUploadTask:task];
    }];
}

//上传结果处理
- (void)finishUploadTask:(UploadTaskModel*)task
{
    if(task.status == BBUploadStatusSuccess||
       task.status == BBUploadStatusCanceled)
    {
        if (task.status == BBUploadStatusSuccess) {
            [self deleteActivatedTask:task];
            [[NSNotificationCenter defaultCenter]postNotificationName:videoUploadTaskFinishNotification object:task];

        }else{
            [self deactivateUploadTask:task];
            [[NSNotificationCenter defaultCenter]postNotificationName:videoUploadTaskCancelNotification object:nil];
        }
    }
    self.isUploading = NO;
    [self uploadNext];
}
@end
