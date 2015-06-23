//
//  Coupon.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/19.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coupon : ABDBObject <ABManagedProtocol>
#pragma mark - Properties
@property (strong, nonatomic) NSString *couponName;               // クーポン名
@property (strong, nonatomic) NSString *couponDescription;        // クーポン詳細記述
@property (strong, nonatomic) NSDate *expireDate;                 // クーポン有効期限
@property (assign, nonatomic) NSUInteger limitCount;              // クーポン利用回数上限
@property (strong, nonatomic) NSString *conditions;               // クーポン利用条件
@property (strong, nonatomic) NSString *usesDescription;          // クーポン利用方法
@property (strong, nonatomic) NSString *precautions;              // クーポン注意事項
@property (strong, nonatomic) NSString *couponImageObjectId;      // クーポン画像オブジェクトID
@property (strong, nonatomic, readonly) NSString *couponImageUrl; // クーポン画像URL

@end
