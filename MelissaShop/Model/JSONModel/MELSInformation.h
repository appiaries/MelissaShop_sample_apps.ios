//
//  MELSInformation.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/15.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MELSInformation : NSObject

/**
 *  identifier
 */
@property (strong, nonatomic) NSString *objectId;

/**
 *  タイトル
 */
@property (strong, nonatomic) NSString *title;

/**
 *  詳細記述
 */
@property (strong, nonatomic) NSString *description;

/**
 *  リスト表示時の画像objectId (imageFileコレクションに紐づく)
 */
@property (strong, nonatomic) NSString *listImageObjectId;

/**
 *  リスト表示時の画像URL
 */
@property (strong, nonatomic) NSString *listImageUrl;

/**
 *  詳細画面の画像objectId
 */
@property (strong, nonatomic) NSString *detailImageObjectId;

/**
 *  詳細画面の画像URL
 */
@property (strong, nonatomic) NSString *detailImageUrl;

/**
 *  詳細画面下の画像objectId
 */
@property (strong, nonatomic) NSString *detailBottomImageObjectId;

/**
 *  詳細画面下の画像URL
 */
@property (strong, nonatomic) NSString *detailBottomImageUrl;

/**
 *  データ登録日付
 */
@property (strong, nonatomic) NSDate *createdAt;

/**
 *  JSON→オブジェクト初期化用
 *
 *  @param dict JSONのInformationオブジェクト
 */
-(id)initWithDict:(NSDictionary*)dict;

@end
