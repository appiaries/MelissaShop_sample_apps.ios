//
//  Shop.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/17.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "Shop.h"

@implementation Shop
@dynamic shopName;
@dynamic shopAddress;
@dynamic shopTel;

#pragma mark - Public methods
- (CLLocationDistance)distanceWithLocation:(CLLocation *)location
{
    return location ? [location distanceFromLocation:location] : CLLocationDistanceMax;
}

#pragma mark - ABManagedProtocol implementations
+ (NSString *)collectionID
{
    return @"shop";
}

@end
