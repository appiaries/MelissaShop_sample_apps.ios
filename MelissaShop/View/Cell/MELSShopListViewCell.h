//
//  MELSShopListViewCell.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/17.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MELSShop;
@class CLLocation;

@interface MELSShopListViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *shopIndexLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopTelLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopDistanceLabel;

/**
 *  ModelからCellに情報を登録
 *
 *  @param information Informationオブジェクト
 *  @param location ショップへの距離を出すための起点
 *  @param index インデックス番号
 */
-(void)setupWithShop:(MELSShop*)shop location:(CLLocation*)location index:(NSUInteger)index;

@end
