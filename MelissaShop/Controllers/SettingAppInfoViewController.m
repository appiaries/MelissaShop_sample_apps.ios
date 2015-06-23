//
//  SettingAppInfoViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/21.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "SettingAppInfoViewController.h"
#import "AppInfo.h"
#import "Constants.h"
#import "DataManager.h"


@interface SettingAppInfoViewController ()
#pragma mark - Properties (Private)
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@end


@implementation SettingAppInfoViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //タイトルの設定
    if (self.appInfoNumber == MELSSettingCellHowTo) {
        self.title = NSLocalizedString(@"SettingTitleHowTo", nil);
    } else if (self.appInfoNumber == MELSSettingCellTerms) {
        self.title = NSLocalizedString(@"SettingTitleTerms", nil);
    } else if (self.appInfoNumber == MELSSettingCellPrivacy) {
        self.title = NSLocalizedString(@"SettingTitlePrivacy", nil);
    } else if (self.appInfoNumber == MELSSettingCellFaq) {
        self.title = NSLocalizedString(@"SettingTitleFaq", nil);
    }
    
    //DataStoreから情報を取得
    [self loadAppInfoData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self layoutSubview];
}

#pragma mark - Private methods
- (void)loadAppInfoData
{
    __weak typeof(self) weakSelf = self;

    ABQuery *query = [[AppInfo query] where:@"appInfoNumber" equalsTo:@(self.appInfoNumber)];
    [baas.db findWithQuery:query block:^(ABResult *ret, ABError *err){
        if (err == nil) {
            NSArray *foundArray = ret.data;
            if ([foundArray count] > 0) {
                AppInfo *appInfo = foundArray.firstObject; // 1件目のみ使用
                [DataManager sharedManager].appInfo = appInfo;
                if (appInfo.appInfoNumber == self.appInfoNumber) {
                    weakSelf.titleLabel.text = appInfo.title;
                    weakSelf.descriptionLabel.text = appInfo.description;
                    [weakSelf layoutSubview];
                }
            }
        } else {
            [weakSelf displayError:err completion:nil];
        }
    }];
}

- (void)layoutSubview
{
    //XXX: 暫定だがAutoLayoutでスクロールを伸ばせなかったので、自力でなんとかしてみる
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x,
                                        self.contentView.frame.origin.y,
                                        self.contentView.frame.size.width,
                                        self.descriptionLabel.frame.origin.y + self.descriptionLabel.intrinsicContentSize.height);
    
    [self.scrollView setContentSize:self.contentView.bounds.size];
    [self.scrollView flashScrollIndicators];
}

@end
