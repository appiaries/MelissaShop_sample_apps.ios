//
//  LogInFormViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/12/04.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "LogInFormViewController.h"
#import "User.h"
#import <SVProgressHUD/SVProgressHUD.h>


@interface LogInFormViewController ()<UITextFieldDelegate>
#pragma mark - Properties (Private)
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
#pragma mark - Actions (Private)
- (IBAction)loginButtonAction:(id)sender;
@end


@implementation LogInFormViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //メールアドレスをデフォルトで開く
    [self.emailTextField becomeFirstResponder];
    
    //編集された際に呼び出される
    [self.emailTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //>>>>>>>>> DEBUG
    if (kLogInDefaultEmail) {
        self.emailTextField.text = kLogInDefaultEmail;
    }
    if (kLogInDefaultPassword) {
        self.passwordTextField.text = kLogInDefaultPassword;
    }
    //<<<<<<<<< DEBUG
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self checkForm];
}

#pragma mark - Actions
- (IBAction)loginButtonAction:(id)sender
{
    User *user = [User user];
    user.email = self.emailTextField.text;
    user.password = self.passwordTextField.text;

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [user logInWithBlock:^(ABResult *ret, ABError *err){
        if (err == nil) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"LoginSuccessMessage", nil)];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [SVProgressHUD dismiss];
            [self displayError:err completion:nil];
        }
    } option:ABUserLogInOptionLogInAutomatically]; // 自動ログインは常にYES
}

#pragma mark - UITextField delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [textField resignFirstResponder];
        [self loginButtonAction:nil];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [self checkForm];
}

#pragma mark - Private methods
- (void)checkForm
{
    self.navigationItem.rightBarButtonItem.enabled =
            [self.emailTextField.text length] > 0 && [self.passwordTextField.text length] > 0;
}

@end
