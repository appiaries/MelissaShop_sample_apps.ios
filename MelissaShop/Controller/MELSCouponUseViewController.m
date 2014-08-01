//
//  MELSCouponUseViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/19.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSCouponUseViewController.h"
#import "MELSCoupon.h"
#import "MELSCouponDetailViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NSDateFormatter+GregorianCalendar.h"

static NSString *const kCellIdentifier = @"CouponDetailViewCell";

@interface MELSCouponUseViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *couponImageView;
@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) MELSCouponDetailViewCell *stubCell;

@end

@implementation MELSCouponUseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //クーポン名
    self.couponNameLabel.text = self.coupon.couponName;
    
    //クーポン詳細
    self.couponDescriptionLabel.text = self.coupon.couponDescription;
    
    //クーポン画像
    [self.couponImageView setImageWithURL:[NSURL URLWithString:self.coupon.couponImageUrl] placeholderImage:nil];
    
    //セル可変用
    _stubCell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_tableView setDelegate:nil];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return MELSCouponDetailCellCount;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    MELSCouponDetailViewCell *detailViewCell = (MELSCouponDetailViewCell*)cell;
    
    if (indexPath.row == MELSCouponDetailCellExpireDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        detailViewCell.titleLabel.text = NSLocalizedString(@"CouponExpireDate", nil);
        detailViewCell.detailLabel.text = [dateFormatter stringFromDate:self.coupon.expireDate];
        
    } else if (indexPath.row == MELSCouponDetailCellLimitCount) {
        detailViewCell.titleLabel.text = NSLocalizedString(@"CouponLimitCount", nil);
        if (self.coupon.limitCount > 0) {
            detailViewCell.detailLabel.text = [NSString stringWithFormat:@"%ld %@", (unsigned long)self.coupon.limitCount, NSLocalizedString(@"CouponLimitCountSuffix", nil)];
        } else {
            detailViewCell.detailLabel.text = NSLocalizedString(@"CouponLimitCountNoLimit", nil);
        }
        
    } else if (indexPath.row == MELSCouponDetailCellConditions) {
        detailViewCell.titleLabel.text = NSLocalizedString(@"CouponLimitConditions", nil);
        detailViewCell.detailLabel.text = self.coupon.conditions;
        
    } else if (indexPath.row == MELSCouponDetailCellUsesDescription) {
        detailViewCell.titleLabel.text = NSLocalizedString(@"CouponUsesDescription", nil);
        detailViewCell.detailLabel.text = self.coupon.usesDescription;
        
    } else if (indexPath.row == MELSCouponDetailCellPrecautions) {
        detailViewCell.titleLabel.text = NSLocalizedString(@"CouponUsesPrecautions", nil);
        detailViewCell.detailLabel.text = self.coupon.precautions;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 計測用のプロパティ"_stubCell"を使って高さを計算する
    [self configureCell:_stubCell atIndexPath:indexPath];
    [_stubCell layoutSubviews];
    
    CGFloat height = [_stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return height + 1;
}

@end
