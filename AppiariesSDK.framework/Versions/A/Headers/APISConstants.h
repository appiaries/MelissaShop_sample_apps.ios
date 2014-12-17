//
//  APISConstants.h
//  AppiariesSDK
//
//  Created by Appiaries Corporation on 2014/11/20.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APISResponseObject;

/**
 * 汎用コールバック・ブロック
 * @brief APISResponseObject を引数にとる汎用コールバック・ブロックです。
 * @since AppiariesSDK 1.3.0
 */
typedef void (^APISGenericCallbackBlock)(APISResponseObject *result, NSError *error);

/**
 * BOOL値コールバック・ブロック
 * @brief BOOL値を引数にとる汎用コールバック・ブロックです。
 * @since AppiariesSDK 1.3.0
 */
typedef void (^APISBooleanCallbackBlock)(BOOL success, NSError *error);


/**
 * SNSプロバイダ定数
 * @since AppiariesSDK 1.3.0
 */
typedef NS_ENUM(NSUInteger, APISSNSProvider) {
    /**
     * SNSプロバイダ (不明)
     * @since AppiariesSDK 1.3.0
     */
    APISSNSProviderUnknown = 0,
    /**
     * SNSプロバイダ (Facebook)
     * @since AppiariesSDK 1.3.0
     */
    APISSNSProviderFacebook,
    /**
     * SNSプロバイダ (Twitter)
     * @since AppiariesSDK 1.3.0
     */
    APISSNSProviderTwitter,
};
