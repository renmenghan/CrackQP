//
//  NSArray+NullCheck.h
//  HongBao
//
//  Created by Ivan on 15/10/13.
//  Copyright © 2015年 ivan. All rights reserved.
//
#import "ALAssetsLibrary+ZHExpand.h"
#import "ZHBlock.h"

@implementation ALAssetsLibrary (ZHExpand)

/**
 *  创建本地相册
 *
 *  @param name                        相册名称
 *  @param enumerateGroupsFailureBlock 遍历相册分组失败回调
 *  @param hasGroup                    本地已经存在该相册，请重新命名
 *  @param createSuccessedBlock        创建相册成功回调
 *  @param createFaieldBlock           创建相册失败回调
 */
- (void)zh_createAssetsGroupWithName:(NSString*)name
         enumerateGroupsFailureBlock:(void (^) (NSError *error))enumerateGroupsFailureBlock
                 hasTheNewGroupBlock:(void (^) (ALAssetsGroup *group))hasGroup
                createSuccessedBlock:(void (^) (ALAssetsGroup *group))createSuccessedBlock
                   createFaieldBlock:(void (^) (NSError *error))createFaieldBlock
{
    
    __block BOOL hasTheNewGroup = NO;
    
    [self enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        hasTheNewGroup = [name isEqualToString:[group valueForProperty:ALAssetsGroupPropertyName]];
        if (hasTheNewGroup) {
            
            [ZHBlock dispatchOnMainThread:^{
                
                hasGroup(group);
            }];
            *stop = YES;
        }
        if (!group && !hasTheNewGroup && !*stop) {//遍历完毕，本地没有该文件夹，非手动停止的遍历
            
            [self addAssetsGroupAlbumWithName:name resultBlock:^(ALAssetsGroup *agroup) {
                
                [ZHBlock dispatchOnMainThread:^{
                    
                    createSuccessedBlock(agroup);
                }];
            } failureBlock:^(NSError *error) {
                
                [ZHBlock dispatchOnMainThread:^{
                    
                    createFaieldBlock(error);
                }];
            }];
        }
    } failureBlock:^(NSError *error) {
        
        [ZHBlock dispatchOnMainThread:^{
            
            enumerateGroupsFailureBlock(error);
        }];
    }];
}

/**
 *  保存视频到指定相册（直接调用可保存到指定分组）
 *
 *  @param path             视频路径
 *  @param name             相册名称
 *  @param saveSuccessBlock 保存成功回调
 *  @param saveFaieldBlock  保存失败回调
 */
- (void)zh_saveVideoWithVideoPath:(NSString*)path
                          toAlbum:(NSString*)name
                 saveSuccessBlock:(void (^) (ALAssetsGroup *group, NSURL *assetURL, ALAsset *asset))saveSuccessBlock
                  saveFaieldBlock:(void (^) (NSError *error))saveFaieldBlock
{
    
    [self writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:path] completionBlock:^(NSURL *assetURL, NSError *error) {//先添加到公众相册
        
        if (error) {
            [ZHBlock dispatchOnMainThread:^{
                
                saveFaieldBlock(error);
            }];
            return;
        }
        
        [self zh_addVideoToAssetGroupWithAssetUrl:assetURL toAlbum:name addSuccessBlock:^(ALAssetsGroup *targetGroup, NSURL *currentAssetUrl, ALAsset *currentAsset) {
            
            [ZHBlock dispatchOnMainThread:^{
                
                saveSuccessBlock(targetGroup,currentAssetUrl,currentAsset);
            }];
        } addFaieldBlock:^(NSError *error) {
            
            [ZHBlock dispatchOnMainThread:^{
                
                saveFaieldBlock(error);
            }];
        }];
    }];
}

/**
 *  添加相册视频到指定分组
 *
 *  @param assetURL        视频在相册的URL
 *  @param name            指定分组名称
 *  @param addSuccessBlock 添加成功回调
 *  @param addFaieldBlock  添加失败回调
 */
- (void)zh_addVideoToAssetGroupWithAssetUrl:(NSURL*)assetURL
                                    toAlbum:(NSString*)name
                            addSuccessBlock:(void (^) (ALAssetsGroup *targetGroup, NSURL *currentAssetUrl, ALAsset *currentAsset))addSuccessBlock
                             addFaieldBlock:(void (^) (NSError *error))addFaieldBlock
{
    
    [self zh_createAssetsGroupWithName:name enumerateGroupsFailureBlock:^(NSError *error) {
        
        if (error) {
            [ZHBlock dispatchOnMainThread:^{
                
                addFaieldBlock(error);
            }];
            return ;
        }
    } hasTheNewGroupBlock:^(ALAssetsGroup *group) {
        
        [self assetForURL:assetURL resultBlock:^(ALAsset *asset) {//得到视频的ALAsset实例
            
            [group addAsset:asset];//添加视频到指定相册分组
            [ZHBlock dispatchOnMainThread:^{
                
                addSuccessBlock(group,assetURL,asset);
            }];
        } failureBlock:^(NSError *error) {
            
            if (error) {
                [ZHBlock dispatchOnMainThread:^{
                    
                    addFaieldBlock(error);
                }];
                return ;
            }
        }];
    } createSuccessedBlock:^(ALAssetsGroup *group) {
        
        [self assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            
            [group addAsset:asset];
            [ZHBlock dispatchOnMainThread:^{
                
                addSuccessBlock(group,assetURL,asset);
            }];
        } failureBlock:^(NSError *error) {
            
            if (error) {
                [ZHBlock dispatchOnMainThread:^{
                    
                    addFaieldBlock(error);
                }];
                return ;
            }
        }];
    } createFaieldBlock:^(NSError *error) {
        
        if (error) {
            [ZHBlock dispatchOnMainThread:^{
                
                addFaieldBlock(error);
            }];
            return ;
        }
    }];
}

@end