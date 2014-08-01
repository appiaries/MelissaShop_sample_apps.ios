//
//  MELSLoginViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSLoginViewController.h"

@interface MELSLoginViewController ()

-(IBAction)noLoginButtonAction:(id)sender;

@end

@implementation MELSLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NavigationBar
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"header"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)noLoginButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
