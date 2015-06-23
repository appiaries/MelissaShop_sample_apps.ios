//
//  ShopListViewCell.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/17.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "ShopListViewCell.h"
#import "Shop.h"
#import <CoreLocation/CoreLocation.h>

@implementation ShopListViewCell

#pragma mark - Public methods
- (void)setupWithShop:(Shop *)shop location:(CLLocation *)location index:(NSUInteger)index
{
    self.shopIndexLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)index+1];
    self.shopNameLabel.text = shop.shopName;
    self.shopAddressLabel.text = shop.shopAddress;
    self.shopTelLabel.text = shop.shopTel;

    CLLocationDistance distance = [shop distanceWithLocation:location] / 1000;
    self.shopDistanceLabel.text = [NSString stringWithFormat:@"%.1f km", distance];
}

@end
