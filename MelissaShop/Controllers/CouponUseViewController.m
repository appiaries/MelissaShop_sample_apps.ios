//
//  CouponUseViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/19.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "CouponUseViewController.h"
#import "Coupon.h"
#import "CouponDetailViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NSDateFormatter+GregorianCalendar.h"
#import "Constants.h"


@interface CouponUseViewController ()
#pragma mark - Properties (Private)
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CouponDetailViewCell *stubCell;         //セル高算出用セル
@property (weak, nonatomic) IBOutlet UIImageView *couponImageView;    //クーポン画像
@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;        //クーポン名
@property (weak, nonatomic) IBOutlet UILabel *couponDescriptionLabel; //クーポン詳細
@end


@implementation CouponUseViewController

#pragma mark - Constants
static NSString *const kCellIdentifier = @"CouponDetailViewCell";

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.couponNameLabel.text = self.coupon.couponName;
    self.couponDescriptionLabel.text = self.coupon.couponDescription;
    [self.couponImageView setImageWithURL:[NSURL URLWithString:self.coupon.couponImageUrl] placeholderImage:nil];
    _stubCell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
}

#pragma mark - Memory management
- (void)dealloc
{
    [_tableView setDelegate:nil];
}

#pragma mark - UITableView data sources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MELSCouponDetailCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CouponDetailViewCell *detailViewCell = (CouponDetailViewCell *)cell;
    
    if (indexPath.row == MELSCouponDetailCellExpireDate) {
        detailViewCell.titleLabel.text = NSLocalizedString(@"CouponExpireDate", nil);
        detailViewCell.detailLabel.text = [NSDateFormatter stringFromDate:self.coupon.expireDate format:@"yyyy/MM/dd" useGregorianCalendar:YES];
        
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
    // セルの高さを算出する
    [self configureCell:_stubCell atIndexPath:indexPath];
    [_stubCell layoutSubviews];
    CGFloat height = [_stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height + 1;
}

@end
