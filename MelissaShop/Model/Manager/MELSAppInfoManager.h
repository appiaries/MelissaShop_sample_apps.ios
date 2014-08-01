//
//  MELSAppInfoManager.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/29.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MELSAppInfo;

@interface MELSAppInfoManager : NSObject

/**
 *  class method for singleton
 *
 *  @return MELSAppInfoManager
 */
+(MELSAppInfoManager*)sharedManager;

/**
 *  取得したMELSAppInfo
 */
@property (readonly, nonatomic) MELSAppInfo *appInfo;

/**
 *  Appinfoデータを取得する
 *
 *  @param appInfoNumber コンテンツ識別番号
 *  @param block NSError
 */

-(void)getAppInfoWithAppInfoNumber:(NSUInteger)appInfoNumber completion:(void (^)(NSError *error))block;

@end
