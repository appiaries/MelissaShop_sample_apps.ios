//
//  HomeViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "HomeViewController.h"
#import "Information.h"
#import "HomeViewCell.h"
#import "InformationViewController.h"
#import "DataManager.h"


@interface HomeViewController ()
#pragma mark - Properties (Private)
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end


@implementation HomeViewController

#pragma mark - Constants
static NSString *const kCellIdentifier = @"HomeViewCell";
static NSString *const kCellSegue = @"InformationPushSegue";

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NavigationBar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
    
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
    return [[DataManager sharedManager].infoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeViewCell *cell = (HomeViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if ([[DataManager sharedManager].infoList count] <= indexPath.row) {
        return cell;
    }
    
    Information *info = [DataManager sharedManager].infoList[(NSUInteger)indexPath.row];
    [cell setupWithInformation:info];

    return cell;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kCellSegue]) {
        NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
        Information *info = [DataManager sharedManager].infoList[(NSUInteger)selected.row];
        
        InformationViewController *controller = segue.destinationViewController;
        controller.information = info;
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

    ABQuery *query = [Information query];
    [baas.db findWithQuery:query block:^(ABResult *ret, ABError *err){
        if (err == nil) {
            NSArray *foundArray = ret.data;
            if ([foundArray count] > 0) {
                DataManager *mgr = [DataManager sharedManager];
                mgr.infoList = [ret.data mutableCopy];
            }
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf displayError:err completion:nil];
        }
        [weakSelf.refreshControl endRefreshing];
    }];
}

@end
