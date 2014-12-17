//
//  MELSUserManager.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSUserManager.h"
#import "MELSUserAttribute.h"
#import <CLLocationManager-blocks/CLLocationManager+blocks.h>

@interface MELSUserManager ()

@property (readwrite) BOOL isLoggedIn;
@property (readwrite) MELSUserAttribute *userAttribute;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL isSendDeviceToken;

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
    if ([APISSession sharedSession].isLoggedIn) {
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
        ALog(@"%@", response.data);
        //属性データを変換して保持する
        if ([response.data objectForKey:@"_id"] != nil) {
            [self successLoginWithAttribute:response.data];
        }
        if (block) block(nil);
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        ALog(@"%@", error);
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
        ALog(@"%@", response.data);
        //属性データを変換して保持する
        if ([response.data objectForKey:@"_id"] != nil) {
            [self successLoginWithAttribute:response.data];
        }
        if (block) block(nil);
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        ALog(@"%@", error);
        if (block) block(error);
    }];
}

-(void)registWithLoginId:(NSString *)loginId password:(NSString *)password attribute:(MELSUserAttribute *)userAttribute completion:(void (^)(NSError *))block
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //AppUserClientの取得
    APISAppUserAPIClient *api = [[APISSession sharedSession] createAppUserAPIClient];
    
    //その他属性をNSDictionaryに変換
    NSDictionary *attributes = [userAttribute dictionaryWithUserAttribute];
    
    //会員登録処理
    [api createAppUserWithLoginId:loginId password:password email:loginId attributes:attributes success:^(APISResponseObject *response) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        ALog(@"%@", response.data);
        
        //属性データを変換して保持する
        if ([response.data objectForKey:@"_id"] != nil) {
            [self successLoginWithAttribute:response.data];
        }
        if (block) block(nil);
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        ALog(@"%@", error);
        if (block) block(error);
    }];
}

-(void)logout
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //AppUserClientの取得
    APISAppUserAPIClient *api = [[APISSession sharedSession] createAppUserAPIClient];
    [api logoutWithSuccess:^(APISResponseObject *response) {
        //ログアウト後、属性情報などを端末から削除
        [APISSession sharedSession].appUser = nil;
        self.userAttribute = nil;
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        ALog(@"%@", error);
    }];
}

-(void)updateUserAttribute:(MELSUserAttribute *)userAttribute completion:(void (^)(NSError *))block
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //AppUser情報をコピー
    APISAppUser *appUser = [[APISSession sharedSession].appUser copy];
    
    //その他属性をNSDictionaryに変換してセット
    [self.userAttribute updateIfExistsUserAttribute:userAttribute];
    [appUser setAttributes:[self.userAttribute dictionaryWithUserAttribute]];
    
    //AppUserClientの取得
    APISAppUserAPIClient *api = [[APISSession sharedSession] createAppUserAPIClient];
    [api updateAppUser:appUser
        success:^(APISResponseObject *response) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            //属性データを変換して保持する
            if ([response.data objectForKey:@"_id"] != nil) {
                [self successLoginWithAttribute:response.data];
            }
            if (block) block(nil);
        
        } failure:^(NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (block) block(error);
        }
    ];
}

-(void)lastAccessWithDevToken:(NSData *)devToken
{
    //デバイストークンを保持
    self.deviceToken = devToken;
    
    if (!self.isLoggedIn
        || (!self.isSendDeviceToken && self.userAttribute)) {
        //会員じゃない場合と未送信かつ属性がとれている場合に送信
        [self sendPushSegemnt:self.deviceToken];
    }
}

-(void)sendPushSegemnt:(NSData*)devToken
{
    if (devToken != nil) {
        //取得しておいたデバイストークンと同時に、住所、好きな食べ物、最終アクセス日時、位置情報を送信する
        NSDictionary *parameters = [self.userAttribute dictionaryWithUserAttribute];
        APISPushAPIClient *api = [[APISSession sharedSession] createPushAPIClient];
        [api registerDeviceToken:devToken attributes:parameters];
        self.isSendDeviceToken = YES;
    }

}

-(void)successLoginWithAttribute:(NSDictionary*)attribute
{
    if ([APISSession sharedSession].isLoggedIn) {
        if ([attribute objectForKey:@"email"] != nil) {
            //属性情報が入っている場合
            self.userAttribute = [[MELSUserAttribute alloc]initWithDict:attribute];
            [self setUserAttributeOther];
        } else {
            //属性情報が入っていない場合は会員情報を取得
            __weak typeof(self) weakSelf = self;
            APISAppUserAPIClient *api = [[APISSession sharedSession] createAppUserAPIClient];
            [api retrieveAppUserWithId:[APISSession sharedSession].appUser.id success:^(APISResponseObject *response) {
                weakSelf.userAttribute = [[MELSUserAttribute alloc]initWithDict:response.data];
                [weakSelf setUserAttributeOther];
            } failure:^(NSError *error) {
            }];
        }
    }
}

-(void)setUserAttributeOther
{
    if (self.userAttribute) {
        //最終アクセス日時を更新
        self.userAttribute.lastAccessDate = [NSDate date];
        //位置情報
        __weak typeof(self) weakSelf = self;
        [self.locationManager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
            *stopUpdating = YES;
            if (!error) {
                //位置情報
                weakSelf.userAttribute.lastLocation = location;
            }
            //属性情報の更新をする
            [weakSelf updateUserAttribute:weakSelf.userAttribute completion:nil];
            
            //デバイストークン情報を送信
            [weakSelf sendPushSegemnt:weakSelf.deviceToken];
        }];
    }
}

@end
