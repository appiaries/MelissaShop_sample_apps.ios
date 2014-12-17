//
//  MELSAppDelegate.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/08.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSAppDelegate.h"
#import "MELSUserManager.h"
#import <AFNetworkActivityLogger/AFNetworkActivityLogger.h>

@implementation MELSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //AFNetworkActivityLogger
#if defined (DEBUG)
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    [[AFNetworkActivityLogger sharedLogger] startLogging];
#endif
    
    //AppiariesSDKのセッションを初期化する
    [[APISSession sharedSession] configureWithDatastoreId:MELSAPISDatastoreId applicationId:MELSAPISAppId applicationToken:MELSAPISAppToken];
    
    //PUSH通知処理
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        // iOS8以降のプッシュ通知登録処理
        UIUserNotificationType types = UIUserNotificationTypeBadge |  UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    } else {
        // iOS8以前のプッシュ通知登録処理
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    }
    
    NSDictionary *notificationUserInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(notificationUserInfo){
        //開封通知
        [self showPushNotificationAlertViewIfNeeded:notificationUserInfo];
    }
    
    //アプリ全体のView設定
    [self viewConfigurations];
    
    //自動ログイン処理
    [[MELSUserManager sharedManager] autoLoginWithCompletion:^(NSError *error) {
        //ログイン出来なかった場合にログイン画面への遷移
        if (error) {
            UIViewController *viewController = [[UIStoryboard storyboardWithName:MELSStoryboardMain bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:MELSStoryboardIDLogin];
            [self.window.rootViewController presentViewController:viewController animated:YES completion:nil];
        }
    }];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// ユーザ通知設定登録完了時ハンドラ (iOS8用)
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
#endif

// デバイストークン発行成功
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // デバイストークン登録APIの実行
    APISPushAPIClient *api = [[APISSession sharedSession] createPushAPIClient];
    [api registerDeviceToken:deviceToken attributes:nil];
    
    //アクセス状況を取得しておく
    [[MELSUserManager sharedManager] lastAccessWithDevToken:deviceToken];
}

// デバイストークン発行失敗
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    ALog(@"Errorinregistration.Error:%@",error);
    
    //アクセス状況を取得しておく
    [[MELSUserManager sharedManager] lastAccessWithDevToken:nil];
}

//アプリがフォアグラウンド or バックグラウンドでのリモート通知処理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState == UIApplicationStateActive)
    {
        //フォアグラウンド
        ALog(@"remote norification foreground");
    } else if (application.applicationState == UIApplicationStateInactive){
        //バックグラウンド
        ALog(@"remote norification background");
    }
    
    //開封通知
    [self showPushNotificationAlertViewIfNeeded:userInfo];
}

#pragma mark private method

- (void)viewConfigurations
{
    //NavigationBarの共通処理
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [UINavigationBar appearance].barTintColor = [UIColor blackColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    //TabBarの共通処理
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)showPushNotificationAlertViewIfNeeded:(NSDictionary*)userInfo
{
    //通知＆バッジを消す
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    if (!aps) {
        return;
    }
    
    //プッシュ通知メッセージを表示
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AlertTitle", nil)
                                                    message:aps[@"alert"]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    //APIS PUSH 開封通知を送信（userInfoのpushIdキーにトークンが入っている）
    NSString* pushId = (NSString*) [userInfo objectForKey:@"pushId"];
    if (pushId != nil) {
        APISPushAPIClient *api = [[APISSession sharedSession] createPushAPIClient];
        [api notifyMessageOpenedWithPushId:[pushId integerValue]];
    }
}

@end
