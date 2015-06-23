//
//  Device.h
//  MelissaShop
//
//  Created by Appiaries Corporation on 2015/04/09.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface Device : ABDevice <ABManagedProtocol>
#pragma mark - Properties
@property (strong, nonatomic) NSString *gender;          // 性別 (male, female, other)
@property (strong, nonatomic) NSDate *dateOfBirth;       // 生年月日
@property (strong, nonatomic) NSString *localizedGender; // ローカライズされた性別
@property (strong, nonatomic) NSString *address;         // 住所（都道府県）
@property (strong, nonatomic) NSString *favoriteFood;    // 好きな食べ物
@property (strong, nonatomic) NSDate *lastAccessDate;    // 最後にアクセスした日時
@property (strong, nonatomic) CLLocation *lastLocation;  // 最後にアクセスした緯度、経度

@end