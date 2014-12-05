//
//  MELSRegistViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/12/04.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSRegistViewController.h"
#import "MELSUserManager.h"
#import "MELSUserAttribute.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "NSDateFormatter+GregorianCalendar.h"

@interface MELSRegistViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;

@property (strong, nonatomic) NSString *gender;

- (IBAction)saveButtonAction:(id)sender;

@end

@implementation MELSRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //メールアドレスをデフォルトで開く
    [self.emailTextField becomeFirstResponder];
    
    //編集された際に呼び出される
    [self.emailTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.genderSegmentedControl addTarget:self action:@selector(changeGender:) forControlEvents:UIControlEventValueChanged];
    self.gender = @"female";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self checkForm];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonAction:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    MELSUserAttribute *userAttribute = [[MELSUserAttribute alloc]init];
    userAttribute.dateOfBirth = [dateFormatter dateFromString:self.dateOfBirthTextField.text];
    userAttribute.gender = self.gender;
    
    //会員登録
    [[MELSUserManager sharedManager] registWithLoginId:self.emailTextField.text password:self.passwordTextField.text attribute:userAttribute completion:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            //エラー表示
            [self displayError:error completion:nil];
        } else {
            //登録成功
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"RegistSuccessMessage", nil)];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

//--------------------------------------------------------------//
#pragma mark UITextFieldDelegate
//--------------------------------------------------------------//
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    }else if (textField == self.passwordTextField){
        [self.dateOfBirthTextField becomeFirstResponder];
    }else if (textField == self.dateOfBirthTextField){
        [textField resignFirstResponder];
        [self saveButtonAction:nil];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidChange:(UITextField*)textField
{
    [self checkForm];
}

-(void)checkForm
{
    if ([self.emailTextField.text length] > 0 && [self.passwordTextField.text length] > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)changeGender:(id)sender
{
    switch (self.genderSegmentedControl.selectedSegmentIndex) {
        case 0:
            self.gender = @"female";
            break;
        case 1:
            self.gender = @"male";
            break;
        default:
            self.gender = @"female";
            break;
    }
}


@end
