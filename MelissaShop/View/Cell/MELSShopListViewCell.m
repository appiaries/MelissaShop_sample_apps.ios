//
//  MELSShopListViewCell.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/17.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSShopListViewCell.h"
#import "MELSShop.h"
#import <CoreLocation/CoreLocation.h>

@implementation MELSShopListViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupWithShop:(MELSShop *)shop location:(CLLocation *)location index:(NSUInteger)index
{
    //インデックス
    self.shopIndexLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)index+1];
    
    //店舗名
    self.shopNameLabel.text = shop.shopName;
    
    //住所
    self.shopAddressLabel.text = shop.shopAddress;
    
    //電話番号
    self.shopTelLabel.text = shop.shopTel;
    
    //現在地からの距離(km)
    CLLocationDistance distance = shop.distance / 1000;
    self.shopDistanceLabel.text = [NSString stringWithFormat:@"%.1f km", distance];
}

@end
