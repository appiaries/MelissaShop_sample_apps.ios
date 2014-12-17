//
//  MELSShopManager.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/17.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;
@class MELSShop;

@interface MELSShopManager : NSObject

/**
 *  class method for singleton
 *
 *  @return MELSShopManager
 */
+(MELSShopManager*)sharedManager;

/**
 *  選択中の店舗データ
 */
@property (strong, nonatomic) MELSShop *selectedShop;

/**
 *  MELSShop Entityの配列
 */
@property (readonly, nonatomic) NSMutableArray *collections;

/**
 *  位置情報から店舗データを取得する
 *
 *  @param block NSError
 */
-(void)getShopWithLocation:(CLLocation*)location completion:(void (^)(NSError *error))block;

@end
