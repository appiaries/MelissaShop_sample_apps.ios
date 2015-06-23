//
//  BaseViewController.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/17.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
#pragma mark - Actions
// 共通ログイン処理
- (void)login;
// 共通ログアウト処理
- (void)logoutWithCompletion:(void(^)(ABError *error))block;
// 共通エラー処理
- (void)displayError:(NSError *)error completion:(void(^)(void))block;

@end
