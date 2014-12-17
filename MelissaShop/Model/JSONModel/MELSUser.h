//
//  MELSUser.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/13.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MELSUser : APISAppUser

/**
 *  性別 (male, female, other)
 */
@property (strong, nonatomic) NSString *gender;

/**
 *  生年月日
 */
@property (strong, nonatomic) NSDate *dateOfBirth;

/**
 *  ローカライズされた性別
 */
@property (strong, nonatomic) NSString *localizedGender;

/**
 *  住所（都道府県）
 */
@property (strong, nonatomic) NSString *address;

/**
 *  好きな食べ物
 */
@property (strong, nonatomic) NSString *favoriteFood;

/**
 *  最後にアクセスした日時
 */
@property (strong, nonatomic) NSDate *lastAccessDate;

/**
 *  最後にアクセスした緯度、経度
 */
@property (strong, nonatomic) CLLocation *lastLocation;

/**
 *  PUSH通知用のデバイストークン
 */
@property (strong, nonatomic) NSString *deviceToken;

/**
 *  JSON→オブジェクト初期化用
 *
 *  @param dict JSONのAppUserオブジェクト
 */
-(id)initWithDict:(NSDictionary*)dict;

/**
 *  JSON→属性情報の更新用
 *
 *  @param dict JSONのAppUserオブジェクト
 */
-(void)updatePropertyWithDict:(NSDictionary*)dict;

@end
