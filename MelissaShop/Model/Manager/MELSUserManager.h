//
//  MELSUserManager.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MELSUserAttribute;
@class CLLocation;

@interface MELSUserManager : NSObject

@property (readonly, nonatomic) MELSUserAttribute *userAttribute;
@property (readonly, nonatomic) BOOL isLoggedIn;
@property (strong, nonatomic) NSData *deviceToken;

+(MELSUserManager*)sharedManager;

/**
 *  自動ログイン処理
 *
 *  @param block NSError
 */
-(void)autoLoginWithCompletion:(void (^)(NSError *error))block;

/**
 *  ログイン処理
 *
 *  @param loginId
 *  @param password
 *  @param block    
 */
-(void)loginWithLoginId:(NSString*)loginId password:(NSString*)password completion:(void (^)(NSError *error))block;

/**
 *  ユーザ登録処理
 *
 *  @param loginId
 *  @param password
 *  @param userAttribute
 *  @param block
 */
-(void)registWithLoginId:(NSString*)loginId password:(NSString*)password attribute:(MELSUserAttribute*)userAttribute completion:(void (^)(NSError *error))block;

/**
 *  ログアウト処理
 */
-(void)logout;

/**
 *  デバイストークン情報を取得
 *
 *  @param device token
 */
-(void)lastAccessWithDevToken:(NSData*)devToken;

/**
 *  ユーザ属性情報を更新
 *
 *  @param block NSError
 */
-(void)updateUserAttribute:(MELSUserAttribute*)userAttribute completion:(void (^)(NSError *error))block;

@end
