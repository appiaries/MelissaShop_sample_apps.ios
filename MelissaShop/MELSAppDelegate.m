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
#import <appiaries/AppiariesPush.h>
#import <appiaries/AppiariesEntity.h>

@implementation MELSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //AFNetworkActivityLogger
#if defined (DEBUG)
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    [[AFNetworkActivityLogger sharedLogger] startLogging];
#endif
    
    //PUSH通知 APIS Push通知初期化
    [AppiariesPush initialize:MELSAPISDatastoreId appliId:MELSAPISAppId appliToken:MELSAPISAppToken];
    
    //PUSH通知処理
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        UIUserNotificationType types = UIUserNotificationTypeBadge |  UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    }
    NSDictionary *notificationUserInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(notificationUserInfo){
        //通知＆バッジを消す（アプリ停止時）
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        //開封通知
        [self sendOpendAPISWithUserInfo:notificationUserInfo];
    }
    
    //アプリ全体のView設定
    [self viewConfigurations];

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

// デバイストークン発行成功
- (void)application:(UIApplication*)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)devToken
{    
    const char *devTokenData = [devToken bytes];
    NSMutableString *devTokenString = [NSMutableString string];
    for (int i = 0; i < [devToken length]; i++) {
        [devTokenString appendFormat:@"%02.2hhX", devTokenData[i]];
    }
    
    ALog(@"deviceToken: %@", devTokenString);
    
    // デバイストークンをサーバに送信し、登録する
    if (devTokenString.length > 0) {
        NSDictionary *dict = @{@"key": @"all"};
        [AppiariesPush sendDeviceToken:devToken dicAttr:dict delegate:self selector:@selector(resultSendDeviceToken:)];
    }
    
    //アクセス状況を取得しておく
    [[MELSUserManager sharedManager] lastAccessWithDevToken:devToken];
}

- (void)resultSendDeviceToken:(id)entity
{
    //デバイストークンを送信した後処理を書く
//    AppiariesEntity *aEntity = (AppiariesEntity*)entity;
//    
//    ALog(@"statusCode:%ld",aEntity.statusCode);
//    ALog(@"entity:%@",aEntity.entity);
    
}

// デバイストークン発行失敗
- (void)application:(UIApplication*)app didFailToRegisterForRemoteNotificationsWithError:(NSError*)err{
    ALog(@"Errorinregistration.Error:%@",err);
    
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
    [self sendOpendAPISWithUserInfo:userInfo];

    //通知＆バッジを消す
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
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


- (void)sendOpendAPISWithUserInfo:(NSDictionary*)userInfo
{
    //APIS PUSH 開封通知を送信（userInfoのpushIdキーにトークンが入っている）
    NSString* pushId = (NSString*) [userInfo objectForKey:@"pushId"];
    if (pushId != nil) {
        [AppiariesPush sendOpened:pushId delegate:self selector:@selector(resultSendOpen:)];
    }
}

- (void)resultSendOpen:(id)entity
{
    //開封通知した後処理を書く
//    AppiariesEntity *aEntity = (AppiariesEntity*)entity;
//    
//    ALog(@"statusCode:%ld",aEntity.statusCode);
//    ALog(@"entity:%@",aEntity.entity);
}

@end
