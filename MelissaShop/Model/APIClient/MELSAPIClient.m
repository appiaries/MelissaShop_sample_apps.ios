//
//  MELSAPIClient.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/13.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSAPIClient.h"
#import "NSURL+dictionaryFromQueryString.h"

/**
 * Appiaries profile API callbackURL
 */
static NSString *const kAuthRequestUrl = @"https://api-oauth.appiaries.com/v1/auth";

/**
 * Appiaries profile API callbackURL
 */
static NSString *const kAuthCallbackUrl = @"http://callback/";

/**
 * Appiaries datastore JSON API URL
 */
static NSString *const kDatastoreJSONUrlBase = @"https://api-datastore.appiaries.com/v1/dat";

/**
 * Appiaries Profile API URL
 */
static NSString *const kProfileUrlBase = @"https://api-profiles.appiaries.com/v1";

/**
 * Appiaries datastore file API URL
 */
static NSString *const kDatastoreFileUrlBase = @"https://api-datastore.appiaries.com/v1/bin";

/**
 * UserDefaults key
 */
static NSString *const kUserDefaultsKeyAccessToken = @"MELSAccessToken";
static NSString *const kUserDefaultsKeyStoreToken = @"MELSStoreToken";
static NSString *const kUserDefaultsKeyTokenExpireDate = @"MELSTokenExpireDate";

/**
 * 画像を保存しているcollectionId
 */
static NSString *const kImageCollectionId = @"imageFile";


@interface MELSAPIClient ()

@property (readwrite) NSString *accessToken;
@property (readwrite) NSString *storeToken;
@property (readwrite) NSDate *tokenExpireDate;

@end

@implementation MELSAPIClient

//--------------------------------------------------------------//
#pragma mark -- initial --
//--------------------------------------------------------------//
+ (instancetype)sharedClient
{
    static MELSAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{
                                                @"Accept" : @"application/json"
                                                };
        _sharedClient = [[MELSAPIClient alloc]initWithSessionConfiguration:configuration];
        //reachability
        [_sharedClient.reachabilityManager startMonitoring];
        
        //Tokenの呼び出し
        [_sharedClient loadCredential];
    });
    
    //共通処理
    if (_sharedClient != nil) {
    }
    
    return _sharedClient;
}

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

//--------------------------------------------------------------//
#pragma mark -- public method --
//--------------------------------------------------------------//
+(NSURLRequest*)authUrlWithScope:(NSString*)scopes
{
    NSDictionary *parameters = @{@"response_type": @"token",
                                 @"client_id": MELSAPISClientId,
                                 @"scope": scopes,
                                 @"display": @"touch"
                                 };
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer]requestWithMethod:@"GET" URLString:kAuthRequestUrl parameters:parameters error:nil];
    return request;
}

+(NSString*)getImageFileUrlWithObjectId:(NSString*)objectId
{
    return [NSString stringWithFormat:@"%@/%@/%@/%@/%@/_bin", kDatastoreFileUrlBase, MELSAPISDatastoreId, MELSAPISAppId, kImageCollectionId, objectId];
}

-(BOOL)isHandleAuthCallback:(NSString *)urlString
{
    //callback URLとマッチするか調べる
    if (urlString.length < kAuthCallbackUrl.length || ![[urlString substringWithRange:NSMakeRange(0, kAuthCallbackUrl.length)] isEqualToString:kAuthCallbackUrl] ) {
        return NO;
    }
    
    //callbackの#を?に変換
    NSString *callbackUrl = [urlString stringByReplacingOccurrencesOfString:@"#" withString:@"?"];
    NSURL *url = [NSURL URLWithString:callbackUrl];
    //クエリーを分解してDictionaryに変換
    NSDictionary *parameters = [url dictionaryFromQueryString];
    ALog(@"callback url:%@", callbackUrl);
    
    //アクセストークン、ストアトークンがある場合はデータを保持する処理を行う
    if ([parameters objectForKey:@"access_token"] != nil && [parameters objectForKey:@"store_token"] != nil) {
        self.accessToken = [parameters objectForKey:@"access_token"];
        self.storeToken = [parameters objectForKey:@"store_token"];
        NSString *expiresInString = [parameters objectForKey:@"expires_in"];
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970]+[expiresInString integerValue];
        self.tokenExpireDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];

        //端末に保存
        [self saveCredential];
    } else {
        //例外処理
        return NO;
    }
    
    return YES;
}

-(void)logout
{
    self.accessToken = nil;
    self.storeToken = nil;
    [self removeCredential];
}

-(void)searchDataStoreAPIWithCollection:(NSString *)collectionId conditions:(NSArray *)conditions paramerters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *results, NSError *error))block
{
    //ヘッダを設定するための共通処理を呼び出す
    [self setHeader];
    
    //検索条件
    NSMutableString *conditionString = [[NSMutableString alloc]init];
    if (conditions != nil) {
        //検索条件は「;」で区切って、文字列にします。
        for (NSString *v in conditions) {
            [conditionString appendString:v];
            [conditionString appendString:@";"];
        }
    }
    
    //URLを生成
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/-;%@", kDatastoreJSONUrlBase, MELSAPISDatastoreId, MELSAPISAppId, collectionId, conditionString];

    //HTTP呼び出し
    [self GET:urlString parameters:parameters
      success:^(NSURLSessionDataTask *task, id responseObject) {
          //成功の場合
          NSDictionary *results = nil;
          if ([responseObject isKindOfClass:[NSDictionary class]]){
              results = (NSDictionary*)responseObject;
          }
          if (block) block(results, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          //失敗の場合
          if (block) block(nil, error);
      }
     ];
}

-(void)createDataStoreAPIWithCollection:(NSString *)collectionId paramerters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *, NSError *))block
{
    //Jsonにシリアライズする
    self.requestSerializer = [AFJSONRequestSerializer serializer];

    [self setHeader];

    //URLを生成
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@", kDatastoreJSONUrlBase, MELSAPISDatastoreId, MELSAPISAppId, collectionId];
    
    [self POST:urlString parameters:parameters
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSDictionary *results = nil;
          if ([responseObject isKindOfClass:[NSDictionary class]]){
              results = (NSDictionary*)responseObject;
          }
          if (block) block(results, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          if (block) block(nil, error);
      }
     ];
}

-(void)updateDataStoreAPIWithCollection:(NSString *)collectionId objectId:(NSString*)objectId paramerters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *, NSError *))block
{
    //Jsonにシリアライズする
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self setHeader];
    
    //URLを生成
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@?proc=patch", kDatastoreJSONUrlBase, MELSAPISDatastoreId, MELSAPISAppId, collectionId, objectId];
    
    [self POST:urlString parameters:parameters
       success:^(NSURLSessionDataTask *task, id responseObject) {
           NSDictionary *results = nil;
           if ([responseObject isKindOfClass:[NSDictionary class]]){
               results = (NSDictionary*)responseObject;
           }
           if (block) block(results, nil);
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           if (block) block(nil, error);
       }
     ];
}

-(void)getProfileAPIWithCompletion:(void (^)(NSDictionary *, NSError *))block
{
    [self setHeader];
    
    //URLを生成
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@", kProfileUrlBase, MELSAPISDatastoreId, MELSAPISAppId];
    
    [self GET:urlString parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSDictionary *results = nil;
          if ([responseObject isKindOfClass:[NSDictionary class]]){
              results = (NSDictionary*)responseObject;
          }
          if (block) block(results, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          if (block) block(nil, error);
      }
     ];
}

#pragma mark --- private method

-(void)setHeader
{
    if (self.storeToken.length > 0) {
        [self.requestSerializer setValue:self.storeToken forHTTPHeaderField:@"X-APPIARIES-TOKEN"];
    }
    if (self.accessToken.length > 0) {
        [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",self.accessToken] forHTTPHeaderField:@"Authorization"];
    }
}

-(void)saveCredential
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.accessToken forKey:kUserDefaultsKeyAccessToken];
    [userDefaults setObject:self.storeToken forKey:kUserDefaultsKeyStoreToken];
    [userDefaults setObject:self.tokenExpireDate forKey:kUserDefaultsKeyTokenExpireDate];
    [userDefaults synchronize];
}

-(void)loadCredential
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:kUserDefaultsKeyAccessToken];
    self.storeToken = [userDefaults objectForKey:kUserDefaultsKeyStoreToken];
    self.tokenExpireDate = [userDefaults objectForKey:kUserDefaultsKeyTokenExpireDate];
}

-(void)removeCredential
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kUserDefaultsKeyAccessToken];
    [userDefaults removeObjectForKey:kUserDefaultsKeyStoreToken];
    [userDefaults removeObjectForKey:kUserDefaultsKeyTokenExpireDate];
    [userDefaults synchronize];
}

@end
