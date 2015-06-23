//
// Created by Appiaries Corporation on 15/05/29.
// Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Device;
@class Shop;
@class AppInfo;


@interface DataManager : NSObject
#pragma mark - Properties
//>> App Info
@property (strong, nonatomic) AppInfo *appInfo;
//>> Coupon Data
@property (strong, nonatomic) NSMutableArray *couponList;
//>> Information Data
@property (strong, nonatomic) NSMutableArray *infoList;
//>> Device Data
@property (strong, nonatomic) NSData *deviceToken;
//>> Shop Data
@property (strong, nonatomic) Shop *selectedShop; // 選択中の店舗データ
@property (strong, nonatomic) NSMutableArray *shopList;

#pragma mark - Initialization (Singleton methods)
+ (instancetype)sharedManager;

@end
