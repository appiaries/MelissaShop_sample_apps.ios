//
//  ShopListViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "ShopListViewController.h"
#import "Shop.h"
#import "ShopListViewCell.h"
#import "Constants.h"
#import "DataManager.h"


@interface ShopListViewController ()
#pragma mark - Properties (Private)
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
#pragma mark - Actions (Private)
- (IBAction)cancelButtonAction:(id)sender;
@end


@implementation ShopListViewController

#pragma mark - Constants
static NSString *const kCellIdentifier = @"ShopListViewCell";

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.titleLabel.text = NSLocalizedString(@"ShopListTitleLocation", nil);
    
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
    return [[DataManager sharedManager].shopList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopListViewCell *cell = (ShopListViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];

    NSArray *shopList = [DataManager sharedManager].shopList;
    if ([shopList count] <= indexPath.row) {
        return cell;
    }
    
    Shop *shop = shopList[(NSUInteger)indexPath.row];
    [cell setupWithShop:shop location:self.currentLocation index:(NSUInteger)indexPath.row];
    
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
    
    //選択されたショップを保存
    DataManager *mgr = [DataManager sharedManager];
    mgr.selectedShop = mgr.shopList[(NSUInteger)indexPath.row];

    //選択されたことを通知する
    NSNotification *notif = [NSNotification notificationWithName:MELSNotificationSelectedShop object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions
- (void)cancelButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)refreshAction:(id)sender
{
    [self.refreshControl beginRefreshing];
    
    [self loadTableView];
}

#pragma mark - Private methods
- (void)loadTableView
{
    if (self.currentLocation != nil) {
        __weak typeof(self) weakSelf = self;

        ABQuery *query = [[Shop query]
                where:@"_coord" withinCircle:[ABGeoPoint pointWithCLLocation:self.currentLocation] kilometers:10];

        [baas.db findWithQuery:query block:^(ABResult *ret, ABError *err){
            if (err == nil) {
                NSArray *foundArray = ret.data;
                //現在地のからの距離が近い順でソートする
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
                DataManager *mgr = [DataManager sharedManager];
                [mgr.shopList removeAllObjects];
                [mgr.shopList addObjectsFromArray:[foundArray sortedArrayUsingDescriptors:@[sortDescriptor]]];

                [weakSelf.tableView reloadData];
            } else {
                [weakSelf displayError:err completion:nil];
            }
            [weakSelf.refreshControl endRefreshing];
        }];
    }
}

@end
