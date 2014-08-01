//
//  MELSShop.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/17.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MELSShop : NSObject

/**
 *  identifier
 */
@property (strong, nonatomic) NSString *objectId;

/**
 *  店舗名
 */
@property (strong, nonatomic) NSString *shopName;

/**
 *  店舗住所
 */
@property (strong, nonatomic) NSString *shopAddress;

/**
 *  店舗電話番号
 */
@property (strong, nonatomic) NSString *shopTel;

/**
 *  店舗緯度経度
 */
@property (strong, nonatomic) CLLocation *shopLocation;

/**
 *  店舗情報登録日付
 */
@property (strong, nonatomic) NSDate *createdAt;

/**
 *  現在地から店舗への距離
 */
@property (assign, nonatomic) CLLocationDistance distance;

/**
 *  JSON→オブジェクト初期化用
 *
 *  @param dict JSONのShopオブジェクト
 *  @param location ショップとの距離を計算するための起点位置
 */
-(id)initWithDict:(NSDictionary*)dict location:(CLLocation*)location;

@end
