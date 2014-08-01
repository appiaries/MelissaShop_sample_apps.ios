//
//  MELSBaseViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/17.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSBaseViewController.h"
#import "MELSUserManager.h"
#import <UIAlertView-Blocks/UIAlertView+Blocks.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface MELSBaseViewController ()

-(IBAction)settingButtonItemAction:(id)sender;

@end

@implementation MELSBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //navigationBar共通処理
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)settingButtonItemAction:(id)sender
{
    UIViewController *viewController =  [self.storyboard instantiateViewControllerWithIdentifier:MELSStoryboardIDSetting];
    [self.tabBarController presentViewController:viewController animated:YES completion:nil];
}

-(void)login
{
    //ログインしていない場合、ログイン画面を表示するかアラートを表示
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LoginAlertTitle", nil)
                                                    message:NSLocalizedString(@"LoginAlertMessage", nil)
                                           cancelButtonItem:[RIButtonItem itemWithLabel:@"OK"]
                                           otherButtonItems:[RIButtonItem itemWithLabel:NSLocalizedString(@"LoginAlertButtonName", nil) action:^{
        //ログインへを押した時はログインのトップ画面を表示
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:MELSStoryboardIDLogin];
        [self presentViewController:viewController animated:YES completion:nil];
    }], nil
                          ];
    [alert show];
}

-(void)logoutWithCompletion:(void(^)(void))block
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LoginAlertTitle", nil)
                                                    message:NSLocalizedString(@"LogoutAlertMessage", nil)
                                           cancelButtonItem:[RIButtonItem itemWithLabel:@"Cancel"]
                                           otherButtonItems:[RIButtonItem itemWithLabel:@"OK" action:^{
        //ログアウト処理
        [[MELSUserManager sharedManager] logout];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"LogoutSuccessMessage", nil)];
        if (block) block();

                            }], nil
                          ];
    [alert show];
}

-(void)displayError:(NSError*)error completion:(void(^)(void))block
{
    if (error) {
        NSDictionary *userInfo = [error userInfo];
        NSString *errorDescription = [userInfo objectForKey:NSLocalizedDescriptionKey];
        if (errorDescription != nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ErrorTitle", nil)
                                                            message:errorDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
    if (block) block();
}

@end
