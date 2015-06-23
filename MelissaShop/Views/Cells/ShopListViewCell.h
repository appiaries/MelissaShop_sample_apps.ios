//
//  ShopListViewCell.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/17.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Shop;
@class CLLocation;

@interface ShopListViewCell : UITableViewCell
#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UILabel *shopIndexLabel;    // インデックス
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;     // 店舗名
@property (weak, nonatomic) IBOutlet UILabel *shopAddressLabel;  // 住所
@property (weak, nonatomic) IBOutlet UILabel *shopTelLabel;      // 電話番号
@property (weak, nonatomic) IBOutlet UILabel *shopDistanceLabel; // 現在地からの距離(km)

#pragma mark - Public methods
/*!
 ModelからCellに情報を登録
 @param information Informationオブジェクト
 @param location ショップへの距離を出すための起点
 @param index インデックス番号
 */
- (void)setupWithShop:(Shop *)shop location:(CLLocation *)location index:(NSUInteger)index;

@end
