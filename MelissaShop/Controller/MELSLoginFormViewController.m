//
//  MELSLoginFormViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/12/04.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSLoginFormViewController.h"
#import "MELSUserManager.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MELSLoginFormViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)loginButtonAction:(id)sender;

@end

@implementation MELSLoginFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //メールアドレスをデフォルトで開く
    [self.emailTextField becomeFirstResponder];
    
    //編集された際に呼び出される
    [self.emailTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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

- (IBAction)loginButtonAction:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    [[MELSUserManager sharedManager]loginWithLoginId:self.emailTextField.text password:self.passwordTextField.text completion:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            //エラー表示
            [self displayError:error completion:nil];
        } else {
            //ログイン成功
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"LoginSuccessMessage", nil)];
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
        [textField resignFirstResponder];
        [self loginButtonAction:self.passwordTextField];
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

@end
