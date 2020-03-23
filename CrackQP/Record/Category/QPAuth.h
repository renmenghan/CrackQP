//
//  QPAuth.h
//  XMQuPaiSDK
//
//  Created by marco on 9/27/16.
//  Copyright © 2016 marco. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 趣拍1.2.1 license机制：先调用validateLicenseIfNeeded，该方法会先调用readLicenseInfoFromDisk，
 如果disk不存在license，则调用validateLicense；如果存在，检查validateFailed，表示上次validate
 成功还是失败，如果是NO（成功），获取当前时间戳与validateTime进行比较；如果是YES（失败），则验证license。
 验证成功，调用validateSuccess，保存；验证失败，调用validateFailed。无论失败还是成功，
 都会调用saveLicenseInfoToDisk，保存信息。
 
 void -[QPAuth validateSuccess](void * self, void * _cmd) {
 esi = [[NSMutableDictionary dictionary] retain];
 var_14 = esi;
 edi = [[self currentTimestamp] retain];
 var_10 = @selector(setValue:forKey:);
 [esi setValue:edi forKey:@"validateTime"];
 [edi release];
 edi = [[NSNumber numberWithInt:0x0] retain];
 [esi setValue:edi forKey:@"attemptCount"];
 [edi release];
 esi = [[NSNumber numberWithBool:0x0] retain];
 [var_14 setValue:esi forKey:@"validateFailed"];
 [esi release];
 [var_14 setValue:@"" forKey:@"validateFailedTitle"];
 [self saveLicenseInfoToDisk:var_14];
 *_validationType = 0xc8;
 eax = [var_14 release];
 return;
 }
 
 */

//extern int validationType;

@interface QPAuth : NSObject
- (void)validateFailed:(NSError*)errorInfo;
- (void)validateSuccess;
- (void)validateLicense;
- (void)validateLicenseIfNeeded;

- (NSDictionary*)configureParamsForAuth;
/*
 bundleId = "com.duanqu.sdk";
 nonce = "974579ED-54D4-4B94-82FC-CA742041C686";
 platform = 1;
 sdkVersion = "1.2.0.2";
 sdkVersionCode = 102;
 sign = "4FW887Y9Xcx+IDlhyBcexA==";
 time = 1475173506120;
 */


- (NSDictionary*)readLicenseInfoFromDisk;
/*
 attemptCount = 0;
 validateFailed = 0;
 validateFailedTitle = "";
 validateTime = 1475171698192;
 
 */

- (NSString*)qpCreateCUID;
- (NSNumber*)currentTimestamp;
- (NSString*)qpHmacSha1:(NSString*)cuid data:(NSString*)data;

@end
