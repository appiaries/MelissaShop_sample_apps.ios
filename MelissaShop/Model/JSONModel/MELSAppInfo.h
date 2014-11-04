//
//  MELSAppInfo.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/29.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MELSAppInfo : NSObject

/**
 *  identifier
 */
@property (strong, nonatomic) NSString *objectId;

/**
 *  記述タイプ
 */
@property (assign, nonatomic) NSUInteger appInfoNumber;

/**
 *  タイトル
 */
@property (strong, nonatomic) NSString *title;

/**
 *  詳細
 */
@property (strong, nonatomic) NSString *textDescription;

/**
 *  JSON→オブジェクト初期化用
 *
 *  @param dict JSONのInformationオブジェクト
 */
-(id)initWithDict:(NSDictionary*)dict;

@end
