//
//  MELSSettingUserViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/21.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSSettingUserViewController.h"
#import "MELSUserManager.h"
#import "MELSUserAttribute.h"
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
@property (nonatomic, strong) UIToolbar *toolbar;
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
    
    MELSUserAttribute *userAttribute = [MELSUserManager sharedManager].userAttribute;
    if (indexPath.row == kMELSSettingUserCellSex) {
        cell.textLabel.text = NSLocalizedString(@"Gender", nil);
        cell.detailTextLabel.text = userAttribute.localizedGender;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if (indexPath.row == kMELSSettingUserCellDateOfBirth){
        cell.textLabel.text = NSLocalizedString(@"DateOfBirth", nil);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        cell.detailTextLabel.text = [dateFormatter stringFromDate:userAttribute.dateOfBirth];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if (indexPath.row == kMELSSettingUserCellAddress){
        cell.textLabel.text = NSLocalizedString(@"Address", nil);
        cell.detailTextLabel.text = userAttribute.address;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    } else if (indexPath.row == kMELSSettingUserCellFavoriteFood){
        cell.textLabel.text = NSLocalizedString(@"FavoriteFood", nil);
        cell.detailTextLabel.text = userAttribute.favoriteFood;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    } else if (indexPath.row == kMELSSettingUserCellLastAccessDate){
        cell.textLabel.text = NSLocalizedString(@"LastAccessDate", nil);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        cell.detailTextLabel.text = [dateFormatter stringFromDate:userAttribute.lastAccessDate];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if (indexPath.row == kMELSSettingUserCellLocation){
        cell.textLabel.text = NSLocalizedString(@"LastLocation", nil);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%f %f", userAttribute.lastLocation.coordinate.latitude, userAttribute.lastLocation.coordinate.longitude];
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
-(void)showUserData
{
    [self.tableView reloadData];
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
        MELSUserAttribute *attribute = [[MELSUserAttribute alloc] init];
        attribute.favoriteFood = [[alertView textFieldAtIndex:0]text] ? :@"";
        __weak typeof(self) weakSelf = self;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        
        //ユーザ属性情報の更新
        [[MELSUserManager sharedManager]updateUserAttribute:attribute completion:^(NSError *error) {
            if (error) {
                [SVProgressHUD dismiss];
                [self displayError:error completion:nil];
            } else{
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SaveSuccessMessage", nil)];
                [weakSelf showUserData];
            }
        }];
    }
}

#pragma mark - Address

-(void)showActionSheet
{
    //ActionSheetを代替する
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self showAlertController];
    } else {
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:nil];
        self.actionSheet.backgroundColor = [UIColor whiteColor];
        
        [self makeActionSheetContents];
        
        // アクションシートへの埋め込みと表示
        [self.actionSheet addSubview:self.toolbar];
        [self.actionSheet addSubview:self.pickerView];
        [self.actionSheet showInView:self.view];
        [self.actionSheet setBounds:CGRectMake(0, 0, self.view.bounds.size.width, 464.0f)];
    }
}

-(void)showAlertController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self makeActionSheetContents];
    
    // AlertControllerへ埋め込む
    [alertController.view addSubview:self.toolbar];
    [alertController.view addSubview:self.pickerView];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)makeActionSheetContents
{
    // ピッカーの作成
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44.0f, 300, 100)];
    } else {
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44.0f, 0, 0)];
    }
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    //Toolbarの作成
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 44.0f)];
    } else {
        self.toolbar  = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
        [self.toolbar sizeToFit];
    }

    // Cancelボタンの作成
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDidPushPicker)];
    
    // フレキシブルスペースの作成
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    // Doneボタンの作成
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDidPushPicker)];
    
    NSArray *items = [NSArray arrayWithObjects:cancel, spacer, done, nil];
    [self.toolbar setItems:items animated:YES];
}

-(void)cancelDidPushPicker
{
    //閉じる
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
}

-(void)doneDidPushPicker
{
    //住所保存処理
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    MELSUserAttribute *attribute = [[MELSUserAttribute alloc] init];
    attribute.favoriteFood = self.addresses[row] ? :@"";
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    //ユーザ属性情報の更新
    [[MELSUserManager sharedManager]updateUserAttribute:attribute completion:^(NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [self displayError:error completion:nil];
        } else{
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SaveSuccessMessage", nil)];
            [weakSelf showUserData];
        }
    }];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        //閉じる
        [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
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
