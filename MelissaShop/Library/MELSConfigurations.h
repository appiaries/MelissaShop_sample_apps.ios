//
//  MELSConfigurations.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#ifndef MelissaShop_MELSConfigurations_h
#define MelissaShop_MELSConfigurations_h

#pragma mark - APIS
/**
 *  Appiaries アプリトークン
 */
static NSString *const MELSAPISAppToken = @"app7835df55aa831ef1387e2e4543";
/**
 * Appiaries アプリID
 */
static NSString *const MELSAPISAppId = @"melissa_shop";
/**
 * Appiaries クライアントID
 */
static NSString *const MELSAPISClientId = @"b4335bed6a0c8bf";
/**
 * Appiaries datastore ID
 */
static NSString *const MELSAPISDatastoreId = @"appiaries_sample";

#pragma mark - UIStoryboard name
static NSString *const MELSStoryboardMain = @"Main";

#pragma mark - UIStoryboardId
static NSString *const MELSStoryboardIDLogin = @"LoginNavigationController";
static NSString *const MELSStoryboardIDShopSearch = @"ShopSearchNavigationController";
static NSString *const MELSStoryboardIDSetting = @"SettingNavigationController";

#pragma mark - NSNotification
static NSString *const MELSNotificationSelectedShop = @"MELSNotificationSelectedShop";

#pragma mark - static
//クーポン画面のセル
typedef NS_ENUM(NSUInteger, MELSCouponDetailCell) {
    MELSCouponDetailCellExpireDate = 0,
    MELSCouponDetailCellLimitCount,
    MELSCouponDetailCellConditions,
    MELSCouponDetailCellUsesDescription,
    MELSCouponDetailCellPrecautions,
    
    MELSCouponDetailCellCount
};

//設定画面のセル
typedef NS_ENUM(NSUInteger, MELSSettingCell) {
    MELSSettingCellUser = 0,
    MELSSettingCellHowTo,
    MELSSettingCellTerms,
    MELSSettingCellPrivacy,
    MELSSettingCellFaq,
    MELSSettingCellLogout,
    
    MELSSettingCellCount
};

#pragma mark - NSError
static NSString *const MELSErrorDomain = @"com.appiaries.MelissaShop";

typedef NS_ENUM (NSUInteger, MELSErrorCode) {
    MELSErrorCodeNotUser = -1000
};

#endif
