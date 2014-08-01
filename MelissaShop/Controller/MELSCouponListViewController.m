//
//  MELSCouponListViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSCouponListViewController.h"
#import "MELSCouponManager.h"
#import "MELSCoupon.h"
#import "MELSCouponListViewCell.h"
#import "MELSCouponDetailViewController.h"

static NSString *const kCellIdentifier = @"CouponListViewCell";
static NSString *const kCellSegue = @"CouponDetailPushSegue";

@interface MELSCouponListViewController ()

@property(nonatomic,weak) IBOutlet UITableView *tableView;

@property(nonatomic,strong) UIRefreshControl *refreshControl;

@end

@implementation MELSCouponListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //RefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self refreshAction:nil];
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
    return [[MELSCouponManager sharedManager].collections count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    MELSCouponListViewCell *cell = (MELSCouponListViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if ([[MELSCouponManager sharedManager].collections count] <= indexPath.row) {
        return cell;
    }
    
    MELSCoupon *coupon = [MELSCouponManager sharedManager].collections[(NSUInteger) indexPath.row];
    [cell setupWithCoupon:coupon];
    
    return cell;
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDelegate --
//--------------------------------------------------------------//
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        cell.alpha = 0.9f;
    } else {
        cell.alpha = 0.8f;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kCellSegue]) {
        NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
        MELSCoupon *coupon = [MELSCouponManager sharedManager].collections[(NSUInteger) selected.row];
        
        MELSCouponDetailViewController *controller = segue.destinationViewController;
        controller.coupon = coupon;
    }
}

//--------------------------------------------------------------//
#pragma mark Action method
//--------------------------------------------------------------//
- (void)refreshAction:(id)sender
{
    [self.refreshControl beginRefreshing];
    
    [self loadTableView];
}

-(void)loadTableView
{
    __weak typeof(self) weakSelf = self;
    
    //データ呼び出し
    [[MELSCouponManager sharedManager]getCouponWithCompletion:^(NSError *error) {
        if (error) {
            [weakSelf displayError:error completion:nil];
        } else {
            [weakSelf.tableView reloadData];
        }
        [weakSelf.refreshControl endRefreshing];
    }];
}

@end
