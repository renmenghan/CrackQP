//
//  RecordRequest.m
//  BabyDaily
//
//  Created by marco on 9/19/16.
//  Copyright © 2016 marco. All rights reserved.
//

#import "RecordRequest.h"

#define RECORD_CONFIG_REQUEST_URL    @"/config/index_publish"

@implementation RecordRequest


+ (void)getRecordConfigDataWithParams:(NSDictionary *)params success:(void(^)(RecordConfigResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure
{
    [[TTNetworkManager sharedInstance] getWithUrl:RECORD_CONFIG_REQUEST_URL parameters:params success:^(NSDictionary *result) {
        
        NSError *err = nil;
        
        RecordConfigResultModel *dataResult = [[RecordConfigResultModel alloc] initWithDictionary:result error:&err];
        
        if (success) {
            success(dataResult);
        }
        
    } failure:^(StatusModel *status) {
        if (failure) {
            failure(status);
        }
    }];
}
@end
