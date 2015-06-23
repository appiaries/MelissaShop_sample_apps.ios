//
//  CouponListViewCell.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/19.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "CouponListViewCell.h"
#import "Coupon.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NSDateFormatter+GregorianCalendar.h"

@implementation CouponListViewCell

#pragma mark - Public methods
- (void)setupWithCoupon:(Coupon *)coupon
{
    //画像
    NSString *urlString = coupon.couponImageUrl;
    if (urlString.length > 0) {
        __weak UIImageView *weakImageView = self.couponImageView;
        //画像表示にアニメーションを入れて、非同期でロードする
        [self.couponImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                               if (response == nil) {
                                                   weakImageView.image = image;
                                               } else {
                                                   [UIView transitionWithView:weakImageView
                                                                     duration:0.2f
                                                                      options:UIViewAnimationOptionTransitionCrossDissolve
                                                                   animations:^{
                                                                       weakImageView.image = image;
                                                                   } completion:nil];
                                               }
                                           }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                           }
         ];
    }

    self.couponNameLabel.text = coupon.couponName;
    self.couponDescriptionLabel.text = coupon.couponDescription;
    self.expireDateLabel.text = [NSDateFormatter stringFromDate:coupon.expireDate format:@"yyyy/MM/dd" useGregorianCalendar:YES];

    if (coupon.limitCount > 0) {
        self.limitCountLabel.text = [NSString stringWithFormat:@"%ld %@",(unsigned long)coupon.limitCount, NSLocalizedString(@"CouponLimitCountSuffix", nil)];
    } else {
        self.limitCountLabel.text = NSLocalizedString(@"CouponLimitCountNoLimit", nil);
    }
}

@end
