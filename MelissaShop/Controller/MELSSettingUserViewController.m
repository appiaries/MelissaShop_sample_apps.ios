//
//  MELSSettingUserViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/21.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSSettingUserViewController.h"
#import "MELSUserManager.h"
#import "MELSUser.h"
#import "NSDateFormatter+GregorianCalendar.h"
#import <SVProgressHUD/SVProgressHUD.h>

static NSString *const kCellIdentifier = @"SettingUserViewCell";

typedef NS_ENUM(NSUInteger, kMELSSettingUserCell) {
    kMELSSettingUserCellSex = 0,
    kMELSSettingUserCellDateOfBirth,
    kMELSSettingUserCellAddress,
    kMELSSettingUserCellFavoriteFood,
    kMELSSettingUserCellLastAccessDate,
    kMELSSettingUserCellLocation,
    
    kMELSSettingUserCellCount
};

@interface MELSSettingUserViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *addresses;

@end

@implementation MELSSettingUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //住所データの読み込み
    NSString *addressPath = [[NSBundle mainBundle]pathForResource:@"address" ofType:@"plist"];
    self.addresses = [NSArray arrayWithContentsOfFile:addressPath];
    
    [self showUserData];
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
    return kMELSSettingUserCellCount;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    MELSUser *user = [MELSUserManager sharedManager].user;
    if (indexPath.row == kMELSSettingUserCellSex) {
        cell.textLabel.text = NSLocalizedString(@"Gender", nil);
        cell.detailTextLabel.text = user.localizedGender;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if (indexPath.row == kMELSSettingUserCellDateOfBirth){
        cell.textLabel.text = NSLocalizedString(@"DateOfBirth", nil);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        cell.detailTextLabel.text = [dateFormatter stringFromDate:user.dateOfBirth];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if (indexPath.row == kMELSSettingUserCellAddress){
        cell.textLabel.text = NSLocalizedString(@"Address", nil);
        cell.detailTextLabel.text = user.address;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    } else if (indexPath.row == kMELSSettingUserCellFavoriteFood){
        cell.textLabel.text = NSLocalizedString(@"FavoriteFood", nil);
        cell.detailTextLabel.text = user.favoriteFood;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    } else if (indexPath.row == kMELSSettingUserCellLastAccessDate){
        cell.textLabel.text = NSLocalizedString(@"LastAccessDate", nil);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        cell.detailTextLabel.text = [dateFormatter stringFromDate:user.lastAccessDate];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if (indexPath.row == kMELSSettingUserCellLocation){
        cell.textLabel.text = NSLocalizedString(@"LastLocation", nil);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%f %f", user.lastLocation.coordinate.latitude, user.lastLocation.coordinate.longitude];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == kMELSSettingUserCellAddress){
        [self showActionSheet];
    } else if (indexPath.row == kMELSSettingUserCellFavoriteFood){
        [self showEditFavoriteFood];
    }
}

#pragma mark - private
-(void)saveUserPropertyWithParameter:(NSDictionary*)parameters
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    //ユーザ属性情報の更新処理
    [[MELSUserManager sharedManager]updateUserPropertyWithParameters:parameters completion:^(NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [self displayError:error completion:nil];
        } else{
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SaveSuccessMessage", nil)];
            [weakSelf showUserData];
        }
    }];
}

-(void)showUserData
{
    __weak typeof(self) weakSelf = self;
    [[MELSUserManager sharedManager]getUserPropertyWithCompletion:^(NSError *error) {
        if (error) {
            [weakSelf displayError:error completion:nil];
        } else {
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - FavoriteFood

- (void)showEditFavoriteFood
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"FavoriteFood", nil)
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //好きな食べ物の保存処理
        NSDictionary *parameters = @{@"favoriteFood": [[alertView textFieldAtIndex:0]text] ? :@""};
        [self saveUserPropertyWithParameter:parameters];
    }
}

#pragma mark - Address

-(void)showActionSheet
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:nil];
    self.actionSheet.backgroundColor = [UIColor whiteColor];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
	toolBar.barStyle = UIBarStyleBlackOpaque;
	[toolBar sizeToFit];
    
	// ピッカーの作成
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44.0f, 0, 0)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
	// Cancelボタンの作成
	UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDidPushPicker)];
	
	// フレキシブルスペースの作成
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
	// Doneボタンの作成
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDidPushPicker)];
	
	NSArray *items = [NSArray arrayWithObjects:cancel, spacer, done, nil];
	[toolBar setItems:items animated:YES];
	
	// アクションシートへの埋め込みと表示
	[self.actionSheet addSubview:toolBar];
	[self.actionSheet addSubview:self.pickerView];
	[self.actionSheet showInView:self.view];
	[self.actionSheet setBounds:CGRectMake(0, 0, self.view.bounds.size.width, 464.0f)];
}

-(void)cancelDidPushPicker
{
    //閉じる
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)doneDidPushPicker
{
    //住所保存処理
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    NSDictionary *parameters = @{@"address": self.addresses[row] ? :@""};
    [self saveUserPropertyWithParameter:parameters];

    //閉じる
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.addresses count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.addresses[row];
}

@end
