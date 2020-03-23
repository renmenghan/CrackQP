//
//  QPSave.h
//  DemoQPSDK
//
//  Created by marco on 9/27/16.
//  Copyright © 2016 lyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QPSave : NSObject

//配合Swizzling，关闭拍摄提示
- (BOOL)recordGuide;
@end
