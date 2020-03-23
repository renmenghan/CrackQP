//
//  VisibilityInfoModel.h
//  BabyDaily
//
//  Created by marco on 9/19/16.
//  Copyright © 2016 marco. All rights reserved.
//

#import "BaseModel.h"

@protocol VisibilityInfoModel <NSObject>

@end

@interface VisibilityInfoModel : BaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) BOOL isDefault;

@end
