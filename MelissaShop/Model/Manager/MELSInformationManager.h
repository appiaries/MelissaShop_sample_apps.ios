//
//  MELSInformationManager.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/15.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MELSInformationManager : NSObject

/**
 *  class method for singleton
 *
 *  @return MELSInformationManager
 */
+(MELSInformationManager*)sharedManager;

/**
 *  取得したMELSInformation Entityの配列
 */
@property (readonly, nonatomic) NSMutableArray *collections;

/**
 *  Informationデータを取得する
 *
 *  @param block NSError
 */
-(void)getInformationWithCompletion:(void (^)(NSError *error))block;

@end
