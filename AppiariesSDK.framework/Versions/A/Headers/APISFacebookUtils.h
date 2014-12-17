//
//  APISFacebookUtils.h
//  AppiariesSDK
//
//  Created by Appiaries Corporation on 2014/10/11.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APISSession.h"
#import "APISInternalConstants.h"
#import "APISConstants.h"


@class FBSession;

typedef int APISSessionDefaultAudience;

/**
 * Facebook連携ユーティリティ
 * @discussion アピアリーズの会員情報とFacebookのアカウントを連携させる際に使用します。
 * @warning 本クラスを使用するには、別途 Facebook SDK をプロジェクトに組み込む必要があります。
 * @since AppiariesSDK 1.3.0
 */
@interface APISFacebookUtils : NSObject
#pragma mark - Initialization
/** @name Initialization */
/**
 * Facebook連携ユーティリティ初期化
 * @brief Facebook連携用ユーティリティを初期化します。
 * @warning 本クラスの各メソッドを使用する前に initializeFacebook (または initializeFacebookWithUrlSchemeSuffix:) を必ず実行してください。
 * @since AppiariesSDK 1.3.0
 */
+ (void)initializeFacebook;
/**
 * Facebook連携ユーティリティ初期化
 * @brief Facebook連携用ユーティリティを初期化します。
 * @param urlSchemeSuffix URLスキーム・サフィックス
 * @warning 本クラスの各メソッドを使用する前に initializeFacebook (または initializeFacebookWithUrlSchemeSuffix:) を必ず実行してください。
 * @since AppiariesSDK 1.3.0
 */
+ (void)initializeFacebookWithUrlSchemeSuffix:(NSString *)urlSchemeSuffix;

#pragma mark - Public methods (LogIn)
/** @name Public methods (LogIn) */
/**
 * Facebookアカウントを使用して会員ログインする
 * @brief Facebookアカウントを使用してアプリにします。会員が作成されていない場合は新規作成されます。
 * @param permissions Facebookログイン時にアクセス許可を求めるパーミッションのリスト
 * @param autoLogin 自動ログインフラグ（YES=自動ログインする）
 * @param block コールバック・ブロック
 * @since AppiariesSDK 1.3.0
 */
+ (void)logInWithPermissions:(NSArray *)permissions
                   autoLogin:(BOOL)autoLogin
                       block:(APISGenericCallbackBlock)block;
/**
 * Facebookアカウントを使用して会員ログインする
 * @brief Facebookアカウントを使用してアプリにします。会員が作成されていない場合は新規作成されます。
 * @param permissions Facebookログイン時にアクセス許可を求めるパーミッションのリスト
 * @param autoLogin 自動ログインフラグ（YES=自動ログインする）
 * @param target    コールバック先オブジェクト
 * @param selector  コールバックハンドラ
 * @since AppiariesSDK 1.3.0
 */
+ (void)logInWithPermissions:(NSArray *)permissions
                   autoLogin:(BOOL)autoLogin
                      target:(id)target
                    selector:(SEL)selector;
/**
 * Facebookアカウントを使用して会員ログインする
 * @brief Facebookアカウントを使用してアプリにします。会員が作成されていない場合は新規作成されます。
 * @param facebookId FacebookアカウントのID
 * @param accessToken Facebookから発行されたアクセストークン
 * @param expirationDate Facebookから発行されたアクセストークンの有効期限
 * @param autoLogin 自動ログインフラグ（YES=自動ログインする）
 * @param block コールバック・ブロック
 * @since AppiariesSDK 1.3.0
 */
+ (void)logInWithFacebookId:(NSString *)facebookId
                accessToken:(NSString *)accessToken
             expirationDate:(NSDate *)expirationDate
                  autoLogin:(BOOL)autoLogin
                      block:(APISGenericCallbackBlock)block;
/**
 * Facebookアカウントを使用して会員ログインする
 * @brief Facebookアカウントを使用してアプリにします。会員が作成されていない場合は新規作成されます。
 * @param facebookId FacebookアカウントのID
 * @param accessToken Facebookから発行されたアクセストークン
 * @param expirationDate Facebookから発行されたアクセストークンの有効期限
 * @param autoLogin 自動ログインフラグ（YES=自動ログインする）
 * @param target    コールバック先オブジェクト
 * @param selector  コールバックハンドラ
 * @since AppiariesSDK 1.3.0
 */
+ (void)logInWithFacebookId:(NSString *)facebookId
                accessToken:(NSString *)accessToken
             expirationDate:(NSDate *)expirationDate
                  autoLogin:(BOOL)autoLogin
                     target:(id)target
                   selector:(SEL)selector;
/**
 * FacebookリクエストURLハンドラ
 * @brief [UIApplicationDelegate application:openURL:sourceApplication:annotation:] に渡されるURLの内、Facebook SDK 内で処理するリクエストを捕捉するために使用します。
 * @param url [UIApplicationDelegate application:openURL:sourceApplication:annotation:] に渡されるURL
 * @return @see [FBSession handleOpenURL:]
 * @since AppiariesSDK 1.3.0
 */
+ (BOOL)handleOpenURL:(NSURL *)url;

#pragma mark - Public methods (Misc)
/** @name Public methods (Misc) */
/**
 * FBSessionを返す
 * @brief FBSession インスタンスを返します。
 * @return FBSession インスタンス
 * @since AppiariesSDK 1.3.0
 */
+ (FBSession *)session;

@end
