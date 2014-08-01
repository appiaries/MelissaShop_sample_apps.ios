//
//  MELSSettingViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/21.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSSettingViewController.h"
#import "MELSUserManager.h"
#import "MELSSettingAppInfoViewController.h"

static NSString *const kCellIdentifier = @"SettingViewCell";
static NSString *const kCellUserSegue = @"SettingUserPushSegue";
static NSString *const kCellAppInfoSegue = @"SettingAppInfoPushSegue";

@interface MELSSettingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) NSUInteger selectedRow;

-(IBAction)cancelButtonAction:(id)sender;

@end

@implementation MELSSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark - Action
-(IBAction)cancelButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([MELSUserManager sharedManager].isLoggedIn) {
        return MELSSettingCellCount;
    }
    return MELSSettingCellCount - 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == MELSSettingCellUser) {
        cell.textLabel.text = NSLocalizedString(@"SettingTitleUser", nil);
    } else if (indexPath.row == MELSSettingCellHowTo){
        cell.textLabel.text = NSLocalizedString(@"SettingTitleHowTo", nil);
    } else if (indexPath.row == MELSSettingCellTerms){
        cell.textLabel.text = NSLocalizedString(@"SettingTitleTerms", nil);
    } else if (indexPath.row == MELSSettingCellPrivacy){
        cell.textLabel.text = NSLocalizedString(@"SettingTitlePrivacy", nil);
    } else if (indexPath.row == MELSSettingCellFaq){
        cell.textLabel.text = NSLocalizedString(@"SettingTitleFaq", nil);
    } else if (indexPath.row == MELSSettingCellLogout){
        cell.textLabel.text = NSLocalizedString(@"SettingTitleLogout", nil);
    }
    return cell;
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDelegate --
//--------------------------------------------------------------//
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == MELSSettingCellUser) {
        //ユーザ情報の表示
        if ([MELSUserManager sharedManager].isLoggedIn) {
            [self performSegueWithIdentifier:kCellUserSegue sender:self];
        } else {
            [self login];
        }
    } else if (indexPath.row == MELSSettingCellLogout){
        //ログアウト処理
        __weak typeof(self) weakSelf = self;
        [self logoutWithCompletion:^{
            [weakSelf.tableView reloadData];
        }];
    } else {
        //アプリ情報を表示する画面へ
        self.selectedRow = indexPath.row;
        [self performSegueWithIdentifier:kCellAppInfoSegue sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kCellAppInfoSegue]) {
        MELSSettingAppInfoViewController *viewController = segue.destinationViewController;
        viewController.appInfoNumber = self.selectedRow;
    }
}
@end
