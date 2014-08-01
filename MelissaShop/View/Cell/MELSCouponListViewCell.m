//
//  MELSCouponListViewCell.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/19.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSCouponListViewCell.h"
#import "MELSCoupon.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NSDateFormatter+GregorianCalendar.h"

@implementation MELSCouponListViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupWithCoupon:(MELSCoupon *)coupon
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
    
    //タイトル
    self.couponNameLabel.text = coupon.couponName;
    
    //説明文
    self.couponDescriptionLabel.text = coupon.couponDescription;
    
    //有効期限
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    self.expireDateLabel.text = [dateFormatter stringFromDate:coupon.expireDate];

    //利用回数
    if (coupon.limitCount > 0) {
        self.limitCountLabel.text = [NSString stringWithFormat:@"%ld %@",(unsigned long)coupon.limitCount, NSLocalizedString(@"CouponLimitCountSuffix", nil)];
    } else {
        self.limitCountLabel.text = NSLocalizedString(@"CouponLimitCountNoLimit", nil);
    }

}

@end
