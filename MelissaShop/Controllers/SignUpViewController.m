//
//  SignUpViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/12/04.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "SignUpViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "NSDateFormatter+GregorianCalendar.h"
#import "User.h"


@interface SignUpViewController ()<UITextFieldDelegate>
#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (strong, nonatomic) NSString *gender;
#pragma mark - Actions
- (IBAction)saveButtonAction:(id)sender;
@end


@implementation SignUpViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //メールアドレスをデフォルトで開く
    [self.emailTextField becomeFirstResponder];
    
    //編集された際に呼び出される
    [self.emailTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.genderSegmentedControl addTarget:self action:@selector(changeGender:) forControlEvents:UIControlEventValueChanged];

    self.gender = @"female";
    
    //>>>>>>>>> DEBUG
    if (kSignUpDefaultEmail) {
        self.emailTextField.text = kSignUpDefaultEmail;
    }
    if (kSignUpDefaultPassword) {
        self.passwordTextField.text = kSignUpDefaultPassword;
    }
    if (kSignUpDefaultDateOfBirth) {
        self.dateOfBirthTextField.text = kSignUpDefaultDateOfBirth;
    }
    if (kSignUpDefaultGender) {
        self.gender = kSignUpDefaultGender;
        self.genderSegmentedControl.selectedSegmentIndex = [kSignUpDefaultGender isEqualToString:@"male"] ? 1 : 0;
    }
    //<<<<<<<<< DEBUG
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self checkForm];
}

#pragma mark - Actions
- (IBAction)saveButtonAction:(id)sender
{
    User *user = [User user];
    user.email = self.emailTextField.text;
    user.password = self.passwordTextField.text;
    user.loginId = [[[[NSUUID UUID].UUIDString lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""] substringToIndex:20]; //XXX:
    NSDictionary *attributes = @{
            @"dateOfBirth" : [NSDateFormatter dateFromString:self.dateOfBirthTextField.text format:@"yyyyMMdd" useGregorianCalendar:YES],
            @"gender" : self.gender
    };
    for (NSString *key in attributes) {
        user[key] = attributes[key];
    }

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [user signUpWithBlock:^(ABResult *ret, ABError *err){
        if (err == nil) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"RegistSuccessMessage", nil)];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [SVProgressHUD dismiss];
            [self displayError:err completion:nil];
        }
    } option:ABUserSignUpOptionLogInAutomatically]; // 自動ログインは常にYES
}

#pragma mark - UITextField delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.dateOfBirthTextField becomeFirstResponder];
    } else if (textField == self.dateOfBirthTextField) {
        [textField resignFirstResponder];
        [self saveButtonAction:nil];
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

- (void)changeGender:(id)sender
{
    switch (self.genderSegmentedControl.selectedSegmentIndex) {
        case 0  : self.gender = @"female"; break;
        case 1  : self.gender = @"male";   break;
        default : self.gender = @"female"; break;
    }
}

@end
