//
//  CouponListViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "CouponListViewController.h"
#import "Coupon.h"
#import "CouponListViewCell.h"
#import "CouponDetailViewController.h"
#import "DataManager.h"


@interface CouponListViewController ()
#pragma mark - Properties (Private)
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end


@implementation CouponListViewController

#pragma mark - Constants
static NSString *const kCellIdentifier = @"CouponListViewCell";
static NSString *const kCellSegue = @"CouponDetailPushSegue";

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    //RefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self refreshAction:nil];
}

#pragma mark - Memory management
- (void)dealloc
{
    [_tableView setDelegate:nil];
}

#pragma mark - UITableView data sources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DataManager sharedManager].couponList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponListViewCell *cell = (CouponListViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];

    NSMutableArray *couponList = [DataManager sharedManager].couponList;
    if (couponList.count <= indexPath.row) {
        return cell;
    }
    Coupon *coupon = couponList[(NSUInteger)indexPath.row];
    [cell setupWithCoupon:coupon];
    
    return cell;
}

#pragma mark - UITableView delegates
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.alpha = (indexPath.row % 2 == 0) ? 0.9f : 0.8f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kCellSegue]) {
        NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
        Coupon *coupon = [DataManager sharedManager].couponList[(NSUInteger)selected.row];
        
        CouponDetailViewController *controller = segue.destinationViewController;
        controller.coupon = coupon;
    }
}

#pragma mark - Actions
- (void)refreshAction:(id)sender
{
    [self.refreshControl beginRefreshing];
    [self loadTableView];
}

#pragma mark - Private methods
- (void)loadTableView
{
    __weak typeof(self) weakSelf = self;

    ABQuery *query = [Coupon query];
    [baas.db findWithQuery:query block:^(ABResult *ret, ABError *err){
        if (err == nil) {
            NSArray *foundArray = ret.data;
            if ([foundArray count] > 0) {
                DataManager *mgr = [DataManager sharedManager];
                [mgr.couponList removeAllObjects];
                [mgr.couponList addObjectsFromArray:foundArray];
            }
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf displayError:err completion:nil];
        }
        [weakSelf.refreshControl endRefreshing];
    }];
}

@end
