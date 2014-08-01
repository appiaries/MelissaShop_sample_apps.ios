//
//  AppiariesEntity.h
//  appiaries
//
//  Created by t_kaifuku on 2014/05/01.
//  Copyright (c) 2014年 t_kaihuku. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * セレクタで返却するオブジェクト
 */
@interface AppiariesEntity : NSObject

/// AppiariesConstConnectionResponse.h に定義されたステータスコード
@property(nonatomic, assign) NSInteger statusCode;
/// 取得データ
@property(nonatomic, assign) NSDictionary* entity;


@end
