//
//  VideoUploadManager.h
//  BabyDaily
//
//  Created by marco on 10/19/16.
//  Copyright © 2016 marco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadTaskModel.h"

extern NSString *const videoUploadTaskEnqueueNotification;
//extern NSString *const videoUploadTaskDequeueNotification;
extern NSString *const videoUploadTaskFinishNotification;
extern NSString *const videoUploadTaskCancelNotification;


@interface VideoUploadManager : NSObject

//@property (nonatomic, strong) NSString *token;
//@property (nonatomic, strong) NSString *from;

@property (nonatomic, assign, readonly) BOOL isUploading;

@property (nonatomic, strong, readonly) NSMutableArray *activitedTasks;
@property (nonatomic, strong, readonly) NSMutableArray *historyTasks;


+ (instancetype)sharedManager;


/*
 将任务加入队列，如果当前没有活动的任务，就立即上传；否则就等待
 */
- (void)enqueueUploadTask:(UploadTaskModel*)task;


/*
 激活已在队列的任务，仅对运行过但是失败的任务有效
 */
- (void)activateUploadTask:(UploadTaskModel*)task;

/*
 将取消的任务转为非活动任务
 */
- (void)deactivateUploadTask:(UploadTaskModel*)task;

/*
 取消已在队列的任务
 */
- (void)cancelUploadTask:(UploadTaskModel*)task;


/*
 删除历史任务，非活动任务
 */
- (void)deleteHistoryTask:(UploadTaskModel*)task;

/*
 保存为草稿
 */
- (void)saveAsHistoryTask:(UploadTaskModel*)task;

/*
 停止并清理所有任务
 */
- (void)stopAndClear;

/*
 更新token
 */
- (void)refreshTokenIfNeed:(void(^)(BOOL success))complete;

@end
