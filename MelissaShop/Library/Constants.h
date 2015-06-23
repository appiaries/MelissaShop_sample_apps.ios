//
//  MELSConstants.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#ifndef MelissaShop_Constants____FILEEXTENSION___
#define MelissaShop_Constants____FILEEXTENSION___

#pragma mark - UIStoryboard name
static NSString *const MELSStoryboardMain = @"Main";

#pragma mark - UIStoryboardId
static NSString *const MELSStoryboardIDLogIn = @"LogInNavigationController";
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
static NSString *const MELSErrorDomain = @"com.appiaries.sample.MelissaShop";

typedef NS_ENUM (NSUInteger, MELSErrorCode) {
    MELSErrorCodeNotUser = -1000
};

#endif
