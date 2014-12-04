//
//  MELSUserManager.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSUserManager.h"
#import "MELSAPIClient.h"
#import "MELSUser.h"
#import <CLLocationManager-blocks/CLLocationManager+blocks.h>

/**
 *  コレクション名
 */
static NSString *const kMELSCollectionUserProperty = @"userProperty";

@interface MELSUserManager ()

@property (readwrite) MELSUser *user;
@property (readwrite, setter=setLoggedIn:) BOOL isLoggedIn;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSDate *lastAccessDate;

@end

@implementation MELSUserManager

//--------------------------------------------------------------//
#pragma mark Initial
//--------------------------------------------------------------//
+ (MELSUserManager*)sharedManager
{
    static MELSUserManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MELSUserManager alloc] initSharedInstance];
    });
    return sharedInstance;
}

- (id)initSharedInstance {
    self = [super init];
    if (self) {
        // 初期化処理
        self.locationManager = [CLLocationManager updateManagerWithAccuracy:50.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionWhenInUse];
    }
    return self;
}

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

//--------------------------------------------------------------//
#pragma mark -- property
//--------------------------------------------------------------//
-(BOOL)isLoggedIn
{
    //User取得済みの場合、ログインとみなす
    if (self.user) {
        return YES;
    }
    return NO;
}

//--------------------------------------------------------------//
#pragma mark Public method
//--------------------------------------------------------------//
-(void)autoLoginWithCompletion:(void (^)(NSError *))block
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    //AppUserClientの取得
    APISAppUserAPIClient *api = [[APISSession sharedSession] createAppUserAPIClient];
    [api autoLoginWithSuccess:^(APISResponseObject *response) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //TODO: ユーザ情報の取得処理
        ALog(@"%@", response.data);
        ALog(@"%@", response.location);
        
        if (block) block(nil);
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (block) block(error);
    }];
}

-(void)loginWithLoginId:(NSString *)loginId password:(NSString *)password completion:(void (^)(NSError *))block
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //AppUserClientの取得
    APISAppUserAPIClient *api = [[APISSession sharedSession] createAppUserAPIClient];
    //ログイン処理（自動ログインは常にYES）
    [api loginWithLoginId:loginId password:password autoLogin:YES success:^(APISResponseObject *response) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //TODO: ユーザ情報の取得処理
        ALog(@"%@", response.data);
        ALog(@"%@", response.location);
        
        if (block) block(nil);
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (block) block(error);
    }];
}

-(void)registWithUser:(MELSUser *)formUser completion:(void (^)(NSError *))block
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //AppUserClientの取得
    APISAppUserAPIClient *api = [[APISSession sharedSession] createAppUserAPIClient];
    
    //会員登録処理
    [api createAppUserWithLoginId:formUser.loginId password:formUser.password email:formUser.loginId attributes:nil success:^(APISResponseObject *response) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //TODO: ユーザ情報の取得処理
        ALog(@"%@", response.data);
        ALog(@"%@", response.location);
        
        if (block) block(nil);
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (block) block(error);
    }];
}

-(void)logout
{
    [[MELSAPIClient sharedClient]logout];
}

-(void)getUserProfileWithCompletion:(void (^)(NSError *))block
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    __weak typeof(self) weakSelf = self;
    [[MELSAPIClient sharedClient] getProfileAPIWithCompletion:^(NSDictionary *results, NSError *error) {
        ALog(@"%@", results);
        if (results && [results isKindOfClass:[NSDictionary class]]) {
            weakSelf.user = [[MELSUser alloc]initWithDict:results];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (block) block(error);
    }];

}

-(void)getUserPropertyWithCompletion:(void (^)(NSError *))block
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    __weak typeof(self) weakSelf = self;

    //プロファイル情報を取得
    [self getUserProfileWithCompletion:^(NSError *error) {
        if (!error) {
            NSString *conditionString = [NSString stringWithFormat:@"_id.eq.%@", weakSelf.user.objectId];
            NSArray *conditions = @[conditionString];
            //属性情報が存在するか確認
            [[MELSAPIClient sharedClient] searchDataStoreAPIWithCollection:kMELSCollectionUserProperty conditions:conditions paramerters:nil completion:^(NSDictionary *results, NSError *error) {
                ALog(@"%@", results);
                if (results && [results isKindOfClass:[NSDictionary class]]) {
                    NSArray *objs = [results objectForKey:@"_objs"];
                    if ([objs isKindOfClass:[NSArray class]] && [objs count] > 0) {
                        //属性情報が存在する場合
                        [weakSelf.user updatePropertyWithDict:objs[0]];
                    }
                }
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                if (block) block(error);
            }];
        } else {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (block) block(error);
        }
    }];

}

-(void)createUserPropertyWithCompletion:(void (^)(NSError *))block
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    __weak typeof(self) weakSelf = self;
    
    //プロファイル情報を取得
    [self getUserPropertyWithCompletion:^(NSError *error) {
        if (!error) {
            //属性情報が存在しない場合は作成
            if (weakSelf.user.propertyObjectId == nil) {
                NSDictionary *parameters = @{
                                             @"_id": weakSelf.user.objectId,
                                             @"address": @"",
                                             @"favoriteFood": @"",
                                             @"lastAccessDate": [NSNumber numberWithUnsignedLong:(unsigned long)[self.lastAccessDate timeIntervalSince1970]],
                                             @"lastLatitude": [NSNumber numberWithDouble:self.location.coordinate.latitude],
                                             @"lastLongitude": [NSNumber numberWithDouble:self.location.coordinate.longitude]
                                             };
                [[MELSAPIClient sharedClient] createDataStoreAPIWithCollection:kMELSCollectionUserProperty paramerters:parameters completion:^(NSDictionary *results, NSError *error) {
                    ALog(@"%@", results);
                    if (results && [results isKindOfClass:[NSDictionary class]]) {
                        NSArray *objs = [results objectForKey:@"_objs"];
                        if ([objs isKindOfClass:[NSArray class]]) {
                            [weakSelf.user updatePropertyWithDict:objs[0]];
                        }
                    }
                    //PUSH通知のセグメント項目を送る
                    [self sendPushSegemnt];

                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    if (block) block(error);
                }];
            } else {
                //更新処理
                [self updateLastAccessWithCompletion:nil];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                if (block) block(error);
            }
        } else {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (block) block(error);
        }
    }];
    
}

-(void)updateUserPropertyWithParameters:(NSDictionary*)parameters completion:(void (^)(NSError *error))block
{
    if (self.user.objectId == nil) {
        //ユーザ情報が存在しない場合はエラー
        NSError *error = nil;
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"CommonError", nill),
        };
        if (error) {
            error = [[NSError alloc] initWithDomain:MELSErrorDomain code:MELSErrorCodeNotUser userInfo:userInfo];
        }
        if (block) block(error);
        return;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //ユーザアップデート処理
    [[MELSAPIClient sharedClient] updateDataStoreAPIWithCollection:kMELSCollectionUserProperty objectId:self.user.objectId paramerters:parameters completion:^(NSDictionary *results, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //PUSH通知のセグメント項目を送る
        if ([parameters objectForKey:@"address"] != nil) {
            self.user.address = [parameters objectForKey:@"address"];
        }
        if ([parameters objectForKey:@"favoriteFood"] != nil) {
            self.user.favoriteFood = [parameters objectForKey:@"favoriteFood"];
        }
        [self sendPushSegemnt];
        
        if (block) block(error);
    }];

}

-(void)updateLastAccessWithCompletion:(void (^)(NSError *))block
{
    if (self.user.objectId == nil) {
        //ユーザ情報が存在しない場合はエラー
        NSError *error = nil;
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"CommonError", nill),
                                   };
        if (error) {
            error = [[NSError alloc] initWithDomain:MELSErrorDomain code:MELSErrorCodeNotUser userInfo:userInfo];
        }
        if (block) block(error);
        return;
    }
   
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSDictionary *parameters = @{
                                 @"lastAccessDate": [NSNumber numberWithUnsignedLong:(unsigned long)[self.lastAccessDate timeIntervalSince1970]],
                                 @"lastLatitude": [NSNumber numberWithDouble:self.location.coordinate.latitude],
                                 @"lastLongitude": [NSNumber numberWithDouble:self.location.coordinate.longitude]
                                 };
    [[MELSAPIClient sharedClient] updateDataStoreAPIWithCollection:kMELSCollectionUserProperty objectId:self.user.objectId paramerters:parameters completion:^(NSDictionary *results, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //PUSH通知のセグメント項目を送る
        [self sendPushSegemnt];
        if (block) block(error);
    }];
}

-(void)lastAccessWithDevToken:(NSData *)devToken
{
    //デバイストークン
    self.deviceToken = devToken;
    
    //最終アクセス
    self.lastAccessDate = [NSDate date];
    
    //位置情報
    __weak typeof(self) weakSelf = self;
    
    [self.locationManager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
        *stopUpdating = YES;
        
        if (!error) {
            //位置情報
            weakSelf.location = location;
        }
    }];
}

-(void)sendPushSegemnt
{
    if (self.deviceToken != nil) {
        //取得しておいたデバイストークンと同時に、住所、好きな食べ物、最終アクセス日時、位置情報を送信する
        NSDictionary *parameters = @{
                                     @"address": self.user.address ? :@"",
                                     @"favoriteFood": self.user.favoriteFood ? :@"",
                                     @"lastAccessDate": [NSNumber numberWithUnsignedLong:(unsigned long)[self.lastAccessDate timeIntervalSince1970]],
                                     @"lastLatitude": [NSNumber numberWithDouble:self.location.coordinate.latitude],
                                     @"lastLongitude": [NSNumber numberWithDouble:self.location.coordinate.longitude]
                                     };
        APISPushAPIClient *api = [[APISSession sharedSession] createPushAPIClient];
        [api registerDeviceToken:self.deviceToken attributes:parameters];
    }

}

@end
