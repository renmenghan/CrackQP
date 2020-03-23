//
//  RecordConfigModel.h
//  BabyDaily
//
//  Created by marco on 9/19/16.
//  Copyright © 2016 marco. All rights reserved.
//

#import "BaseModel.h"
#import "VisibilityInfoModel.h"


@interface RecordConfigModel : BaseModel


//@property (nonatomic, assign) BOOL showCategory;
@property (nonatomic, strong) NSArray<VisibilityInfoModel> *visibility;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, assign) BOOL enableImport;
@property (nonatomic, assign) NSUInteger bitRate;
@end
