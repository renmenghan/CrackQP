//
//  QPMediaRender.h
//  DemoQPSDK
//
//  Created by marco on 8/31/16.
//  Copyright © 2016 lyle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QPEventManager : NSObject

+ (instancetype)shared;

- (void)event:(NSString*)event;
@end
