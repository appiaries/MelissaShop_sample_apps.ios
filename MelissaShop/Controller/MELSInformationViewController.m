//
//  MELSInformationViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSInformationViewController.h"
#import "MELSInformation.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MELSInformationViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;

@end

@implementation MELSInformationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //ヘッダ画像
    [self.headImageView setImageWithURL:[NSURL URLWithString:self.information.detailImageUrl] placeholderImage:nil];
    
    //タイトル
    self.titleLabel.text = self.information.title;
    
    //詳細
    self.descriptionLabel.text = self.information.description;
    
    //下部の画像
    [self.bottomImageView setImageWithURL:[NSURL URLWithString:self.information.detailBottomImageUrl] placeholderImage:nil];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.scrollView setContentSize: self.contentView.bounds.size];
    [self.scrollView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
