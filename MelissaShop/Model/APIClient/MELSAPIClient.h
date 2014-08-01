//
//  MELSAPIClient.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/13.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface MELSAPIClient : AFHTTPSessionManager

/**
 *  class method for singleton
 *
 *  @return MELSAPIClient
 */
+ (instancetype)sharedClient;

/**
 *  accessToken
 */
@property (nonatomic,readonly) NSString *accessToken;

/**
 *  storeToken
 */
@property (nonatomic,readonly) NSString *storeToken;

/**
 *  トークンの有効期限
 */
@property (nonatomic,readonly) NSDate *tokenExpireDate;


/**
 *  OAuth requestのURLを生成して返す
 *
 *  @param scopes Profile APIで指定されているスコープ
 */
+(NSURLRequest*)authUrlWithScope:(NSString*)scopes;

/**
 *  画像を保存しているファイルAPIからURLを取得
 *
 *  @param objectId imageFileのオブジェクトID
 *
 *  @return 画像URL
 */
+(NSString*)getImageFileUrlWithObjectId:(NSString*)objectId;

/**
 *  CallbackのURLを判定して、accessToken, storeTokenを取得
 *
 *  @param url Callback URL
 *
 *  @return Callbackの処理がされたか否か
 */
-(BOOL)isHandleAuthCallback:(NSString*)urlString;

/**
 *  ログアウト処理
 */
-(void)logout;

/**
 *  DataStore API 検索
 *
 *  @param collection コレクション名
 *  @param conditions 検索条件
 *  @param parameters クエリー
 *  @param block      block NSDictionary, NSError
 */
-(void)searchDataStoreAPIWithCollection:(NSString *)collectionId conditions:(NSArray *)conditions paramerters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *results, NSError *error))block;

/**
 *  Datastore API 作成
 *
 *  @param collectionId     コレクション名
 *  @param parameters       Jsonにシリアライズされるオブジェクト
 *  @param block            block NSDictionary, NSError
 */
-(void)createDataStoreAPIWithCollection:(NSString *)collectionId paramerters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *results, NSError *error))block;

/**
 *  Datastore API 更新
 *
 *  @param collectionId     コレクション名
 *  @param objectId         オブジェクトID
 *  @param parameters       更新されるJsonにシリアライズされるオブジェクト
 *  @param block            block NSDictionary, NSError
 */
-(void)updateDataStoreAPIWithCollection:(NSString *)collectionId objectId:(NSString*)objectId paramerters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *results, NSError *error))block;

/**
 *  Profile APIからユーザ情報を取得
 *
 *  @param block block NSDictionary, NSError
 */
-(void)getProfileAPIWithCompletion:(void (^)(NSDictionary *results, NSError *error))block;

@end
