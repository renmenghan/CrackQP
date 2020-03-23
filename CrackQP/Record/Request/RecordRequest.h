//
//  RecordRequest.h
//  BabyDaily
//
//  Created by marco on 9/19/16.
//  Copyright © 2016 marco. All rights reserved.
//

#import "BaseRequest.h"
#import "RecordConfigResultModel.h"

@interface RecordRequest : BaseRequest


+ (void)getRecordConfigDataWithParams:(NSDictionary *)params success:(void(^)(RecordConfigResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure;

@end
