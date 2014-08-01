//
//  MELSCouponDetailViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSCouponDetailViewController.h"
#import "MELSCoupon.h"
#import "MELSCouponDetailViewCell.h"
#import "MELSCouponUseViewController.h"
#import "MELSUserManager.h"
#import <UIAlertView-Blocks/UIAlertView+Blocks.h>
#import "NSDateFormatter+GregorianCalendar.h"

static NSString *const kCellIdentifier = @"CouponDetailViewCell";
static NSString *const kButtonSegue = @"CouponUsePushSegue";

@interface MELSCouponDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) MELSCouponDetailViewCell *stubCell;

@end

@implementation MELSCouponDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //クーポン名
    self.couponNameLabel.text = self.coupon.couponName;
    
    //クーポン詳細
    self.couponDescriptionLabel.text = self.coupon.couponDescription;
    
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

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    //今すぐクーポンを利用するボタンを押された場合の処理
    if ([identifier isEqualToString:kButtonSegue]) {
        //会員の判定処理
        if ([MELSUserManager sharedManager].isLoggedIn) {
            return YES;
        } else {
            //共通ログイン処理
            [self login];
        }
    }
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kButtonSegue]) {
        MELSCouponDetailViewController *controller = segue.destinationViewController;
        controller.coupon = self.coupon;
    }
}


@end
