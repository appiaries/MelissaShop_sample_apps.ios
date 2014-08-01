//
//  AppiariesPush.h
//  appiaries
//
//  Created by t_kaifuku on 2014/04/15.
//  Copyright (c) 2014年 t_kaihuku. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * appiaries push 通知オブジェクト
 */
@interface AppiariesPush : NSObject

/**
 * 初期化処理
 *
 * appiaries push 通知オブジェクトを使用する為の初期化を行います。
 *
 * @param   strDataStoreId  appiaries データストアID
 * @param   strAppliId      appiaries アプリID
 * @param   strAppliToken   appiaries アプリトークン
 */
+ (void) initialize:(NSString*)strDataStoreId appliId:(NSString*)strAppliId appliToken:(NSString*)strAppliToken;

/**
 * デバイストークン登録
 *
 * APNs より取得したデバイストークンを appiaries へ登録します。
 * 処理が完了すると、セレクタへ結果を返却します。
 * 返却されるオブジェクトは AppiariesEntity* になります。
 *
 * @param   dataDeviceToken     APNs より取得したデバイストークン
 * @param   dicAttr             登録時に付与する属性データ
 * @param   delegate            selector が定義してあるオブジェクト
 * @param   selector            処理完了時コールバックセレクタ
 */
+ (void) sendDeviceToken:(NSData*)dataDeviceToken dicAttr:(NSDictionary*)dicAttr delegate:(id)delegate selector:(SEL)selector;

/**
 * デバイストークン登録解除
 *
 * sendDeviceToken で appiaries へ登録したデバイストークンを解除します。
 * 処理が完了すると、セレクタへ結果を返却します。
 * 返却されるオブジェクトは AppiariesEntity* になります。
 *
 * @param   delegate            selector が定義してあるオブジェクト
 * @param   selector            処理完了時コールバックセレクタ
 */
+ (void) removeDeviceToken:(id)delegate selector:(SEL)selector;

/**
 * push 通知開封通知
 *
 * push 通知を開封したことを appiaries へ通知します。
 * 
 * @param   strPushId           push 通知受信時の NSDictionary 内の pushId をキーに持つ value
 * @param   delegate            selector が定義してあるオブジェクト
 * @param   selector            処理完了時コールバックセレクタ
 */
+ (void) sendOpened:(NSString*)strPushId delegate:(id)delegate selector:(SEL)selector;

@end
