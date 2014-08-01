//
//  MELSUserManager.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MELSUser;
@class CLLocation;

@interface MELSUserManager : NSObject

@property (readonly, nonatomic) MELSUser *user;
@property (strong, nonatomic) NSData *deviceToken;

+(MELSUserManager*)sharedManager;

/**
 *  ログインしているか判定
 *
 *  @return YES or NO
 */
-(BOOL)isLoggedIn;

/**
 *  ログアウト処理
 */
-(void)logout;

/**
 *  Profile情報を取得
 *
 *  @param block NSError
 */
-(void)getUserProfileWithCompletion:(void (^)(NSError *error))block;

/**
 *  ユーザ属性情報を取得
 *
 *  @param block NSError
 */
-(void)getUserPropertyWithCompletion:(void (^)(NSError *error))block;

/**
 *  ユーザ属性情報を作成
 *
 *  @param block NSError
 */
-(void)createUserPropertyWithCompletion:(void (^)(NSError *error))block;

/**
 *  アクセス情報を取得
 *
 *  @param device token
 */
-(void)lastAccessWithDevToken:(NSData*)devToken;

/**
 *  アクセス情報を更新
 *
 *  @param block NSError
 */
-(void)updateLastAccessWithCompletion:(void (^)(NSError *error))block;

/**
 *  ユーザ属性情報を更新
 *
 *  @param block NSError
 */
-(void)updateUserPropertyWithParameters:(NSDictionary*)parameters completion:(void (^)(NSError *error))block;

@end
