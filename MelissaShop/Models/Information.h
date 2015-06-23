//
//  Information.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/15.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Information : ABDBObject <ABManagedProtocol>
#pragma mark - Properties
@property (strong, nonatomic) NSString *title;                          // タイトル
@property (strong, nonatomic) NSString *description;                    // 詳細記述
@property (strong, nonatomic) NSString *listImageObjectId;              // リスト表示時の画像オブジェクトID (imageFileコレクションに紐づく)
@property (strong, nonatomic, readonly) NSString *listImageUrl;         // リスト表示時の画像URL
@property (strong, nonatomic) NSString *detailImageObjectId;            // 詳細画面の画像オブジェクトID
@property (strong, nonatomic, readonly) NSString *detailImageUrl;       // 詳細画面の画像URL
@property (strong, nonatomic) NSString *detailBottomImageObjectId;      // 詳細画面下の画像オブジェクトID
@property (strong, nonatomic, readonly) NSString *detailBottomImageUrl; // 詳細画面下の画像URL
@property (strong, nonatomic) NSDate *createdAt;

@end
