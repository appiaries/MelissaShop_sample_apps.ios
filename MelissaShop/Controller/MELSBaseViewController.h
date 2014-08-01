//
//  MELSBaseViewController.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/17.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MELSBaseViewController : UIViewController

/**
 *  共通ログイン処理
 */
-(void)login;

/**
 *  共通ログアウト処理
 *
 *  @param block
 */
-(void)logoutWithCompletion:(void(^)(void))block;

/**
 *  共通エラー処理
 *
 *  @param NSError
 *  @param block
 */
-(void)displayError:(NSError*)error completion:(void(^)(void))block;

@end
