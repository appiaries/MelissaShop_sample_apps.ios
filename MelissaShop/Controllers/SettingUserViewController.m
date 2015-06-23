//
//  SettingUserViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/21.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "SettingUserViewController.h"
#import "NSDateFormatter+GregorianCalendar.h"
#import "User.h"
#import <SVProgressHUD/SVProgressHUD.h>


@interface SettingUserViewController ()
#pragma mark - Properties (Private)
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (strong, nonatomic) NSArray *addresses;
@end


@implementation SettingUserViewController

#pragma mark - Constants
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

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //住所データの読み込み
    NSString *addressPath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
    self.addresses = [NSArray arrayWithContentsOfFile:addressPath];
    
    [self showUserData];
}

#pragma mark - Memory management
- (void)dealloc
{
    [_tableView setDelegate:nil];
}

#pragma mark UITableView data sources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kMELSSettingUserCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const kSpacer = @" "; //ref) http://stackoverflow.com/questions/25793074/subtitles-of-uitableviewcell-wont-update/26051439#26051439
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];

    User *user = (User *)baas.session.user;
    
    if (indexPath.row == kMELSSettingUserCellSex) {
        cell.textLabel.text = NSLocalizedString(@"Gender", nil);
        NSString *localizedGenderStr = user.localizedGender;
        cell.detailTextLabel.text = localizedGenderStr ? localizedGenderStr : kSpacer;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if (indexPath.row == kMELSSettingUserCellDateOfBirth) {
        cell.textLabel.text = NSLocalizedString(@"DateOfBirth", nil);
        NSString *dateOfBirthStr = [NSDateFormatter stringFromDate:user.dateOfBirth format:@"yyyy/MM/dd" useGregorianCalendar:YES];
        cell.detailTextLabel.text = dateOfBirthStr ? dateOfBirthStr : kSpacer;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if (indexPath.row == kMELSSettingUserCellAddress) {
        cell.textLabel.text = NSLocalizedString(@"Address", nil);
        NSString *addressStr = user.address;
        cell.detailTextLabel.text = addressStr ? addressStr : kSpacer;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    } else if (indexPath.row == kMELSSettingUserCellFavoriteFood) {
        cell.textLabel.text = NSLocalizedString(@"FavoriteFood", nil);
        NSString *favoriteFoodStr = user.favoriteFood;
        cell.detailTextLabel.text = favoriteFoodStr ? favoriteFoodStr : kSpacer;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    } else if (indexPath.row == kMELSSettingUserCellLastAccessDate) {
        cell.textLabel.text = NSLocalizedString(@"LastAccessDate", nil);
        NSString *lastAccessDateStr = [NSDateFormatter stringFromDate:user.lastAccessDate format:@"yyyy/MM/dd HH:mm" useGregorianCalendar:YES];
        cell.detailTextLabel.text = lastAccessDateStr ? lastAccessDateStr : kSpacer;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if (indexPath.row == kMELSSettingUserCellLocation) {
        cell.textLabel.text = NSLocalizedString(@"LastLocation", nil);
        NSString *lastLocationStr = [NSString stringWithFormat:@"%f %f", user.lastLocation.coordinate.latitude, user.lastLocation.coordinate.longitude];
        cell.detailTextLabel.text = lastLocationStr ? lastLocationStr : kSpacer;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

#pragma mark - UITableView delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == kMELSSettingUserCellAddress) {
        [self showActionSheet];
    } else if (indexPath.row == kMELSSettingUserCellFavoriteFood) {
        [self showEditFavoriteFood];
    }
}

#pragma mark - UIAlertView delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {

        //好きな食べ物の保存処理

        User *user = (User *)[baas.session.user copy]; // セッションからログイン中ユーザの情報をコピー
        NSString *favFood = [[alertView textFieldAtIndex:0] text];
        user.favoriteFood = favFood ? favFood : @""; // 好きな食べ物を編集

        __weak typeof(self) weakSelf = self;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [user saveWithBlock:^(ABResult *ret, ABError *err){
            if (err == nil) {
                User *updatedUser = ret.data;
                [baas.session storeUser:updatedUser isPermanently:YES]; // セッションのユーザ情報をリストアする
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SaveSuccessMessage", nil)];
                [weakSelf showUserData];
            } else {
                [SVProgressHUD dismiss];
                [weakSelf displayError:err completion:nil];
            }
        }];
    }
}

#pragma mark - UIPickerView data sources
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.addresses count];
}

#pragma mark - UIPickerView delegates
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.addresses[(NSUInteger)row];
}

#pragma mark - Actions
- (void)cancelDidPushPicker
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void)doneDidPushPicker
{
    User *user = (User *)[baas.session.user copy]; // セッションからログイン中ユーザの情報をコピー
    NSString *address = self.addresses[(NSUInteger)[self.pickerView selectedRowInComponent:0]];
    user.address = address ? address : @""; // 住所を編集

    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [user saveWithBlock:^(ABResult *ret, ABError *err){
        if (err == nil) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SaveSuccessMessage", nil)];
            User *updatedUser = ret.data;
            [baas.session storeUser:updatedUser isPermanently:YES]; // セッションのユーザ情報をリストアする
            [weakSelf showUserData];
        } else {
            [SVProgressHUD dismiss];
            [weakSelf displayError:err completion:nil];
        }
    }];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
}

#pragma mark - Private methods
- (void)showUserData
{
    [self.tableView reloadData];
}

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

- (void)showActionSheet
{
    //ActionSheetを代替する
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self showAlertController];
    } else {
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                       delegate:self
                                              cancelButtonTitle:@""
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
        self.actionSheet.backgroundColor = [UIColor whiteColor];
        
        [self makeActionSheetContents];
        
        // アクションシートへの埋め込みと表示
        [self.actionSheet addSubview:self.toolbar];
        [self.actionSheet addSubview:self.pickerView];
        [self.actionSheet showInView:self.view];
        [self.actionSheet setBounds:CGRectMake(0, 0, self.view.bounds.size.width, 464)];
    }
}

- (void)showAlertController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"\n\n\n\n\n\n\n\n"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [self makeActionSheetContents];
    
    // AlertControllerへ埋め込む
    [alertController.view addSubview:self.toolbar];
    [alertController.view addSubview:self.pickerView];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)makeActionSheetContents
{
    // ピッカーの作成
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 300, 100)];
    } else {
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    }
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    //Toolbarの作成
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    } else {
        self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        [self.toolbar sizeToFit];
    }

    // Cancelボタンの作成
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                            target:self
                                                                            action:@selector(cancelDidPushPicker)];
    // フレキシブルスペースの作成
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                            target:self
                                                                            action:nil];
    // Doneボタンの作成
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                          target:self
                                                                          action:@selector(doneDidPushPicker)];
    [self.toolbar setItems:@[cancel, spacer, done] animated:YES];
}

@end
