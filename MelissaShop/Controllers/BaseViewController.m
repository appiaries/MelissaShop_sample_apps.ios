//
//  BaseViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/17.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "BaseViewController.h"
#import "Constants.h"
#import <UIAlertView-Blocks/UIAlertView+Blocks.h>


@interface BaseViewController ()
#pragma mark - Actions (Private)
- (IBAction)settingButtonItemAction:(id)sender;
@end


@implementation BaseViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //navigationBar共通処理
    self.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark - Actions
- (IBAction)settingButtonItemAction:(id)sender
{
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:MELSStoryboardIDSetting];
    [self.tabBarController presentViewController:viewController animated:YES completion:nil];
}

- (void)login
{
    //ログインしていない場合、ログイン画面を表示するかアラートを表示
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LoginAlertTitle", nil)
                                message:NSLocalizedString(@"LoginAlertMessage", nil)
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"OK"]
                       otherButtonItems:[RIButtonItem itemWithLabel:NSLocalizedString(@"LoginAlertButtonName", nil)
                                                             action:^{
                                                                 //ログインへを押した時はログインのトップ画面を表示
                                                                 UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:MELSStoryboardIDLogIn];
                                                                 [self presentViewController:viewController animated:YES completion:nil];
                                                             }], nil] show];
}

- (void)logoutWithCompletion:(void(^)(ABError *error))block
{
    [baas.session.user logOutWithBlock:^(ABResult *ret, ABError *err){
        if (block) {
            block(err);
        }
    }];
}

- (void)displayError:(NSError *)error completion:(void(^)(void))block
{
    if (error) {
        NSDictionary *userInfo = [error userInfo];
        NSString *errorDescription = userInfo[NSLocalizedDescriptionKey];
        if (errorDescription != nil) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ErrorTitle", nil)
                                        message:errorDescription
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }
    
    if (block) block();
}

@end
