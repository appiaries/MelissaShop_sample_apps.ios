//
//  SettingViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/21.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <UIAlertView-Blocks/UIAlertView+Blocks.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "SettingViewController.h"
#import "SettingAppInfoViewController.h"
#import "Constants.h"


@interface SettingViewController ()
#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSUInteger selectedRow;
#pragma mark - Actions
- (IBAction)cancelButtonAction:(id)sender;
@end


@implementation SettingViewController

#pragma mark - Constants
static NSString *const kCellIdentifier = @"SettingViewCell";
static NSString *const kCellUserSegue = @"SettingUserPushSegue";
static NSString *const kCellAppInfoSegue = @"SettingAppInfoPushSegue";

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Memory management
- (void)dealloc
{
    [_tableView setDelegate:nil];
}

#pragma mark - Actions
- (IBAction)cancelButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView data sources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return baas.session.isLoggedIn ? MELSSettingCellCount : MELSSettingCellCount - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == MELSSettingCellUser) {
        cell.textLabel.text = NSLocalizedString(@"SettingTitleUser", nil);
    } else if (indexPath.row == MELSSettingCellHowTo) {
        cell.textLabel.text = NSLocalizedString(@"SettingTitleHowTo", nil);
    } else if (indexPath.row == MELSSettingCellTerms) {
        cell.textLabel.text = NSLocalizedString(@"SettingTitleTerms", nil);
    } else if (indexPath.row == MELSSettingCellPrivacy) {
        cell.textLabel.text = NSLocalizedString(@"SettingTitlePrivacy", nil);
    } else if (indexPath.row == MELSSettingCellFaq) {
        cell.textLabel.text = NSLocalizedString(@"SettingTitleFaq", nil);
    } else if (indexPath.row == MELSSettingCellLogout) {
        cell.textLabel.text = NSLocalizedString(@"SettingTitleLogout", nil);
    }
    return cell;
}

#pragma mark - UITableView delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == MELSSettingCellUser) {
        //ユーザ情報の表示
        if (baas.session.isLoggedIn) {
            [self performSegueWithIdentifier:kCellUserSegue sender:self];
        } else {
            [self login];
        }
    } else if (indexPath.row == MELSSettingCellLogout) {
        //ログアウト処理
        __weak typeof(self) weakSelf = self;
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LoginAlertTitle", nil)
                                    message:NSLocalizedString(@"LogoutAlertMessage", nil)
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"Cancel"]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"OK"
                                                                 action:^{
                //ログアウト処理
                [self logoutWithCompletion:^(ABError *error){
                    if (error == nil) {
                        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"LogoutSuccessMessage", nil)];
                    } else {
                        [SVProgressHUD showErrorWithStatus:error.description];
                    }
                    [weakSelf.tableView reloadData];
                }];
        }], nil] show];
    } else {
        //アプリ情報を表示する画面へ
        self.selectedRow = (NSUInteger)indexPath.row;
        [self performSegueWithIdentifier:kCellAppInfoSegue sender:self];
    }
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kCellAppInfoSegue]) {
        SettingAppInfoViewController *viewController = segue.destinationViewController;
        viewController.appInfoNumber = self.selectedRow;
    }
}

@end
