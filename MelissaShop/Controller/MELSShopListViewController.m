//
//  MELSShopListViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSShopListViewController.h"
#import "MELSShopManager.h"
#import "MELSShop.h"
#import "MELSShopListViewCell.h"

static NSString *const kCellIdentifier = @"ShopListViewCell";

@interface MELSShopListViewController ()

@property(nonatomic,weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,strong) UIRefreshControl *refreshControl;

-(IBAction)cancelButtonAction:(id)sender;

@end

@implementation MELSShopListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //テーブルヘッダーのタイトルを入れる
    self.titleLabel.text = NSLocalizedString(@"ShopListTitleLocation", nil);
    
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
    return [[MELSShopManager sharedManager].collections count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    MELSShopListViewCell *cell = (MELSShopListViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if ([[MELSShopManager sharedManager].collections count] <= indexPath.row) {
        return cell;
    }
    
    MELSShop *shop = [MELSShopManager sharedManager].collections[(NSUInteger) indexPath.row];
    [cell setupWithShop:shop location:self.currentLocation index:indexPath.row];
    
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
    
    //選択されたショップを保存
    [MELSShopManager sharedManager].selectedShop = [MELSShopManager sharedManager].collections[(NSUInteger) indexPath.row];
    
    //選択されたことを通知する
    NSNotification *n = [NSNotification notificationWithName:MELSNotificationSelectedShop object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n];
    
    //閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

//--------------------------------------------------------------//
#pragma mark - Action method
//--------------------------------------------------------------//
-(void)cancelButtonAction:(id)sender
{
    //閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)refreshAction:(id)sender
{
    [self.refreshControl beginRefreshing];
    
    [self loadTableView];
}

-(void)loadTableView
{
    __weak typeof(self) weakSelf = self;
    
    if (self.currentLocation != nil) {
        //データ呼び出し
        [[MELSShopManager sharedManager]getShopWithLocation:self.currentLocation completion:^(NSError *error) {
            if (error) {
                [weakSelf displayError:error completion:nil];
            } else {
                [weakSelf.tableView reloadData];
            }
            [weakSelf.refreshControl endRefreshing];
        }];
    } else {
        //検索ワードデータ呼び出し(not use)
        [[MELSShopManager sharedManager]getShopWithWord:self.searchWord location:self.currentLocation completion:^(NSError *error) {
            if (error) {
                [weakSelf displayError:error completion:nil];
            } else {
                [weakSelf.tableView reloadData];
            }
            [weakSelf.refreshControl endRefreshing];
        }];
    }
    
}


@end
