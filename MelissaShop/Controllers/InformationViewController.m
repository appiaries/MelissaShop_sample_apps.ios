//
//  InformationViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "InformationViewController.h"
#import "Information.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


@interface InformationViewController ()
#pragma mark - Properties (Private)
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;   //ヘッダ画像
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;          //タイトル
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;    //詳細
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView; //下部の画像
@end


@implementation InformationViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.headImageView setImageWithURL:[NSURL URLWithString:self.information.detailImageUrl] placeholderImage:nil];
    self.titleLabel.text = self.information.title;
    self.descriptionLabel.text = self.information.description;
    [self.bottomImageView setImageWithURL:[NSURL URLWithString:self.information.detailBottomImageUrl] placeholderImage:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self.scrollView setContentSize:self.contentView.bounds.size];
    [self.scrollView flashScrollIndicators];
}

@end
