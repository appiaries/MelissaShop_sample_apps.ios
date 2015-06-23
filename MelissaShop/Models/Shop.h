//
//  Shop.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/17.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Shop : ABDBObject <ABManagedProtocol>
#pragma mark - Properties
@property (strong, nonatomic) NSString *shopName;    // 店舗名
@property (strong, nonatomic) NSString *shopAddress; // 店舗住所
@property (strong, nonatomic) NSString *shopTel;     // 店舗電話番号

#pragma mark - Public methods
// 現在地から店舗への距離を返す
- (CLLocationDistance)distanceWithLocation:(CLLocation *)location;

@end
