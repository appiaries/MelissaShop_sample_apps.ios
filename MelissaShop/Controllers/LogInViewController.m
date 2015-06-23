//
//  LogInViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "LogInViewController.h"


@interface LogInViewController ()
#pragma mark - Actions (Private)
- (IBAction)noLoginButtonAction:(id)sender;
@end


@implementation LogInViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
}

#pragma mark - Actions
- (IBAction)noLoginButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
