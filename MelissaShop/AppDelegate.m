//
//  AppDelegate.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/08.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "AppDelegate.h"
#import "AppInfo.h"
#import "Coupon.h"
#import "Device.h"
#import "Information.h"
#import "Image.h"
#import "Shop.h"
#import "User.h"
#import "Constants.h"
#import "DataManager.h"
#import <AFNetworkActivityLogger/AFNetworkActivityLogger.h>
#import <CLLocationManager-blocks/CLLocationManager+blocks.h>

@interface AppDelegate ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation AppDelegate

#pragma mark - Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef DEBUG
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    [[AFNetworkActivityLogger sharedLogger] startLogging];
#endif
    
    // SDK初期化
    baas.config.applicationID = kApplicationID;
    baas.config.applicationToken = kApplicationToken;
    baas.config.datastoreID = kDatastoreID;
    [baas activate]; //@note 自動ログインが有効な場合は、このタイミングで自動的にセッションにログイン情報が再格納される

    // モデルクラスの登録
    [baas registerClasses:@[
            [AppInfo class], [Coupon class], [Device class], [Image class],
            [Information class], [Shop class], [User class]
    ]];

    // プッシュ通知処理
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        // iOS8以降のプッシュ通知登録処理
        UIUserNotificationType types = UIUserNotificationTypeBadge |  UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    } else {
        // iOS8以前のプッシュ通知登録処理
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                (UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    }
    
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    [self handlePushIfNeeded:userInfo];

    // アプリ全体のView設定
    [self setupGlobalAppearances];

    [self.window makeKeyAndVisible];

    // ロケーション・サービス
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        self.locationManager = [CLLocationManager updateManagerWithAccuracy:50.0
                                                                locationAge:15.0
                                                    authorizationDesciption:CLLocationUpdateAuthorizationDescriptionWhenInUse];
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }

    // ユーザ情報、デバイス情報の更新
    if (!baas.session.isLoggedIn) { // 未ログインの場合

        // ログイン画面へ遷移
        UIViewController *viewController = [[UIStoryboard storyboardWithName:MELSStoryboardMain bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:MELSStoryboardIDLogIn];
        [self.window.rootViewController presentViewController:viewController animated:YES completion:nil];

    } else { // ログイン済みの場合

        if (baas.session.user.email != nil) { // ユーザ属性を取得済みの場合
            [self updateUserAttributesIfNeeded];

        } else { // ユーザ属性を取得済みでない場合

            // ユーザ情報を再取得
            [baas.user fetch:baas.session.user block:^(ABResult *ret, ABError *err){
                if (err == nil) {
                    [self updateUserAttributesIfNeeded];
                }
            }];
        }
    }

    return YES;
}
							
// ユーザ通知設定登録完了時ハンドラ (iOS8用)
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
#endif

// デバイストークン発行成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [DataManager sharedManager].deviceToken = deviceToken; //NOTE: リトライ用に保持しておく
    [self registerDeviceTokenIfNeeded];
}

// デバイストークン発行失敗
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [baas.session invalidateDevice];
    [[[UIAlertView alloc] initWithTitle:@"ERROR"
                                message:[NSString stringWithFormat:@"Failed to register for remote notfication. [reason:%@]", error.localizedDescription]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil
    ] show];
}

// リモート通知受信
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self handlePushIfNeeded:userInfo];
}

#pragma mark - Private methods
- (void)registerDeviceTokenIfNeeded {
    NSData *deviceToken = [DataManager sharedManager].deviceToken;
    if (deviceToken == nil) {
        [[[UIAlertView alloc] initWithTitle:@"ERROR"
                                    message:@"Insufficient device information (DeviceManager.device not found)"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
        ] show];
        return;
    }

    if (baas.session.device != nil) {
        Device *device = [Device deviceWithRawDeviceToken:deviceToken];
        [device registerWithBlock:^(ABResult *ret, ABError *err){
            if (err != nil) {
                [[[UIAlertView alloc] initWithTitle:@"ERROR"
                                            message:[NSString stringWithFormat:@"Failed to register for remote notfication. [reason:%@]", err.localizedDescription]
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil
                ] show];
            }
        }];
    }
}

- (void)updateUserAttributesIfNeeded {
    [self.locationManager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating){
        *stopUpdating = YES;
        if (error == nil) {
            // 最終アクセス日時や現在位置情報などのユーザ属性を更新する
            User *user = (User *)[baas.session.user copy];
            user.lastLocation = location; // 現在位置をセット
            user.lastAccessDate = [NSDate date]; // 最終アクセス日時を現在時刻をセット
            [user saveWithBlock:^(ABResult *ret, ABError *err){
                if (err == nil) {
                    // 更新したユーザ情報をセッションにセットする
                    User *updatedUser = ret.data;
                    [baas.session storeUser:updatedUser isPermanently:YES];

                    // デバイス情報を登録
                    [self registerDeviceTokenIfNeeded];
                }
            }];
        }
    }];
}

- (void)handlePushIfNeeded:(NSDictionary *)userInfo
{
    ABPushMessage *message = [ABPushMessage messageWithDictionary:userInfo];
    if (!message) return;

    //通知のバッジを消す
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    //プッシュ通知メッセージを表示
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AlertTitle", nil)
                                message:message.message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil
    ] show];

    //開封通知を送信
    [message openWithBlock:^(ABResult *result, ABError *error){
        if (error == nil) {
            NSLog(@"開封通知を送信しました。 [pushId:%lld]", message.pushId);
        } else {
            [[[UIAlertView alloc] initWithTitle:@"ERROR"
                                        message:error.description
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil
            ] show];
        }
    }];
}

- (void)setupGlobalAppearances
{
    //NavigationBarの共通処理
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [UINavigationBar appearance].barTintColor = [UIColor blackColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};

    //TabBarの共通処理
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
}

@end
