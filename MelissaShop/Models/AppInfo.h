//
//  AppInfo.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/29.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfo : ABDBObject <ABManagedProtocol>
#pragma mark - Properties
@property (assign, nonatomic) NSUInteger appInfoNumber;  // 記述タイプ
@property (strong, nonatomic) NSString *title;           // タイトル
@property (strong, nonatomic) NSString *description;     // 詳細

@end
