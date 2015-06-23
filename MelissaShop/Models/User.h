//
//  User.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/13.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface User : ABUser <ABManagedProtocol>
#pragma mark - Properties
@property (strong, nonatomic) NSString *gender;          // 性別 (male, female, other)
@property (strong, nonatomic) NSDate *dateOfBirth;       // 生年月日
@property (readonly, nonatomic) NSString *localizedGender; // ローカライズされた性別
@property (strong, nonatomic) NSString *address;         // 住所（都道府県）
@property (strong, nonatomic) NSString *favoriteFood;    // 好きな食べ物
@property (strong, nonatomic) NSDate *lastAccessDate;    // 最後にアクセスした日時
@property (strong, nonatomic) CLLocation *lastLocation;  // 最後にアクセスした緯度、経度
@property (strong, nonatomic) NSString *deviceToken;     // PUSH通知用のデバイストークン

#pragma mark - Public methods
- (NSString *)localizedGender;

@end
