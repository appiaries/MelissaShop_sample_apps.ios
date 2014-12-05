//
//  MELSUserAttribute.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/12/05.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MELSUserAttribute : NSObject

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
 *  JSON→オブジェクト初期化用
 *
 *  @param dict JSONのAppUser attributeオブジェクト
 */
-(id)initWithDict:(NSDictionary*)dict;

/**
 *  MELSUserAttributeをdictionaryで返す
 *
 *  @return NSDictionary
 */
-(NSDictionary*)dictionaryWithUserAttribute;

/**
 *  MELSUserAttributeを一度に更新する
 *
 *  @param userAttribute
 */
-(void)updateIfExistsUserAttribute:(MELSUserAttribute*)userAttribute;

@end
