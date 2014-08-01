//
//  MELSSettingAppInfoViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/21.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSSettingAppInfoViewController.h"
#import "MELSAppInfoManager.h"
#import "MELSAppInfo.h"

@interface MELSSettingAppInfoViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation MELSSettingAppInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //タイトルの設定
    if (self.appInfoNumber == MELSSettingCellHowTo){
        self.title = NSLocalizedString(@"SettingTitleHowTo", nil);
        
    } else if (self.appInfoNumber == MELSSettingCellTerms){
        self.title = NSLocalizedString(@"SettingTitleTerms", nil);
        
    } else if (self.appInfoNumber == MELSSettingCellPrivacy){
        self.title = NSLocalizedString(@"SettingTitlePrivacy", nil);
        
    } else if (self.appInfoNumber == MELSSettingCellFaq){
        self.title = NSLocalizedString(@"SettingTitleFaq", nil);

    }
    
    //DataStoreから情報を取得
    [self loadAppInfoData];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self layoutSubview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadAppInfoData
{
    __weak typeof(self) weakSelf = self;
    
    //該当のデータを取得
    [[MELSAppInfoManager sharedManager]getAppInfoWithAppInfoNumber:self.appInfoNumber completion:^(NSError *error) {
        if (error) {
            [weakSelf displayError:error completion:nil];
        } else {
            MELSAppInfo *appInfo = [MELSAppInfoManager sharedManager].appInfo;
            if (appInfo != nil && appInfo.appInfoNumber == self.appInfoNumber) {
                self.titleLabel.text = appInfo.title;
                self.descriptionLabel.text = appInfo.description;
                [self layoutSubview];
            }
        }
    }];
}

- (void)layoutSubview
{
    //暫定だがAutolayoutでスクロールを伸ばせなかったので、自力でなんとかしてみる
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.descriptionLabel.frame.origin.y + self.descriptionLabel.intrinsicContentSize.height);
    
    [self.scrollView setContentSize: self.contentView.bounds.size];
    [self.scrollView flashScrollIndicators];
}

@end
