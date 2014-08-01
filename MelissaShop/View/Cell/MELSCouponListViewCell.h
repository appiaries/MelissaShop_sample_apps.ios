//
//  MELSCouponListViewCell.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/19.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MELSCoupon;

@interface MELSCouponListViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *couponImageView;
@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *expireDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitCountLabel;

/**
 *  ModelからCellに情報を登録
 *
 *  @param coupon couponオブジェクト
 *  @param index
 */
-(void)setupWithCoupon:(MELSCoupon*)coupon;


@end
