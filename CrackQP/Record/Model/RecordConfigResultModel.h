//
//  RecordConfigResultModel.h
//  BabyDaily
//
//  Created by marco on 9/19/16.
//  Copyright © 2016 marco. All rights reserved.
//

#import "RecordConfigModel.h"

@interface RecordConfigResultModel : BaseModel

@property (nonatomic, strong) RecordConfigModel *config;
@property (nonatomic, copy) NSString <Optional>*microfilmLink;
@end
