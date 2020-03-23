//
//  NSArray+NullCheck.m
//  HongBao
//
//  Created by Ivan on 17/10/13.
//  Copyright © 2017年 ivan. All rights reserved.
//

#import "QPAuth+Swizzling.h"
#import <objc/runtime.h>


@implementation QPAuth (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(validateFailed:);
        SEL swizzledSelector = @selector(validateFailedX);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        //交换实现
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
        
        
        SEL oAuthSelector = @selector(configureParamsForAuth);
        SEL sAuthSelector = @selector(configureParamsForAuthX);
        
        Method oAuthMethod = class_getInstanceMethod(class, oAuthSelector);
        Method sAuthMethod = class_getInstanceMethod(class, sAuthSelector);
        //交换实现
        method_exchangeImplementations(oAuthMethod, sAuthMethod);
    });
    
   
}

#pragma mark - Method Swizzling

- (void)validateFailedX {
    //以下两种方式均能破解license限制
    //validationType = 0xc8;
    [self validateSuccess];
}

//support ios 7
- (NSDictionary*)configureParamsForAuthX
{
    id objects[6];
    id keys[6];
    
    objects[0] = [NSNumber numberWithInteger:0x66];
    objects[1] = @"1.2.0.2";
    objects[2] = [NSNumber numberWithInteger:0x1];
    objects[3] = [[NSBundle mainBundle] bundleIdentifier];
    objects[4] = [self qpCreateCUID];
    objects[5] = [self currentTimestamp];
    
    keys[0] = @"sdkVersionCode";
    keys[1] = @"sdkVersion";
    keys[2] = @"platform";
    keys[3] = @"bundleId";
    keys[4] = @"nonce";
    keys[5] = @"time";
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys count:6];
    NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSURLComponents *components = [[NSURLComponents alloc] init];
    NSMutableArray *coms = [NSMutableArray array];
    
    NSArray *ebx = [dict allKeys];
    NSArray *sortedebx = [ebx sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [(NSString*)obj1 compare:(NSString*)obj2];
    }];
    
    NSString *query;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0f) {
        for (NSString *key in sortedebx) {
            NSString *value;
            NSURLQueryItem *item;
            value = [dict objectForKey:key];
            if ([value isKindOfClass:[NSNumber class]]) {
                value = [(NSNumber*)value stringValue];
            }
            item =  [NSURLQueryItem queryItemWithName:key value:value];
            if(item)[coms addObject:item];
        }
        components.queryItems = coms;
        query = [components query];
    }else{
        for (NSString *key in sortedebx) {
            NSString *value;
            value = [dict objectForKey:key];
            if ([value isKindOfClass:[NSNumber class]]) {
                value = [(NSNumber*)value stringValue];
            }
            [coms addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
        query = [coms componentsJoinedByString:@"&"];
    }
    
    NSString *sha = [self qpHmacSha1: objects[4] data:query];
    NSDictionary *sign = @{@"sign":sha};
    [mdict addEntriesFromDictionary:sign];
    return mdict;
}
@end
