//
//  MELSCoupon.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/19.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MELSCoupon : NSObject

/**
 *  identifier
 */
@property (strong, nonatomic) NSString *objectId;

/**
 *  クーポン名
 */
@property (strong, nonatomic) NSString *couponName;

/**
 *  クーポン詳細記述
 */
@property (strong, nonatomic) NSString *couponDescription;

/**
 *  クーポン有効期限
 */
@property (strong, nonatomic) NSDate *expireDate;

/**
 *  クーポン利用回数
 */
@property (assign, nonatomic) NSUInteger limitCount;

/**
 *  クーポン利用条件
 */
@property (strong, nonatomic) NSString *conditions;

/**
 *  クーポン利用方法
 */
@property (strong, nonatomic) NSString *usesDescription;

/**
 *  クーポン注意事項
 */
@property (strong, nonatomic) NSString *precautions;

/**
 *  クーポン画像objectId
 */
@property (strong, nonatomic) NSString *couponImageObjectId;

/**
 *  クーポン画像URL
 */
@property (strong, nonatomic) NSString *couponImageUrl;

/**
 *  クーポン作成日付
 */
@property (strong, nonatomic) NSDate *createdAt;

/**
 *  JSON→オブジェクト初期化用
 *
 *  @param dict JSONのInformationオブジェクト
 */
-(id)initWithDict:(NSDictionary*)dict;

@end
