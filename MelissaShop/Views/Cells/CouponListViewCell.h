//
//  CouponListViewCell.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/19.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Coupon;

@interface CouponListViewCell : UITableViewCell
#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UIImageView *couponImageView;
@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;        //タイトル
@property (weak, nonatomic) IBOutlet UILabel *couponDescriptionLabel; //説明文
@property (weak, nonatomic) IBOutlet UILabel *expireDateLabel;        //有効期限
@property (weak, nonatomic) IBOutlet UILabel *limitCountLabel;        //利用回数上限

#pragma mark - Public methods
- (void)setupWithCoupon:(Coupon *)coupon;

@end
