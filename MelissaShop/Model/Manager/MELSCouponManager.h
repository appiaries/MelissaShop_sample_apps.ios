//
//  MELSCouponManager.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/19.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MELSCouponManager : NSObject

/**
 *  class method for Singleton
 *
 *  @return MELSCouponManager
 */
+(MELSCouponManager*)sharedManager;

/**
 *  MELSCoupon Entityの配列データ
 */
@property (readonly, nonatomic) NSMutableArray *collections;

/**
 *  couponデータを取得する
 *
 *  @param block NSError
 */
-(void)getCouponWithCompletion:(void (^)(NSError *error))block;

@end
