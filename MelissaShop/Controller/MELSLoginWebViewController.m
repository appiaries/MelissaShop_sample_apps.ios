//
//  MELSLoginWebViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSLoginWebViewController.h"
#import "MELSAPIClient.h"
#import "MELSUser.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MELSUserManager.h"

@interface MELSLoginWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation MELSLoginWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //AuthURLを生成して渡す
    [self.webview loadRequest:[MELSAPIClient authUrlWithScope:kMELSUserProfileScope]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //CallbackのURLかの確認処理
    NSString *url = request.URL.absoluteString;
    
    //URLがCallbackに設定している正しいURLかどうかを判定する
    if ([[MELSAPIClient sharedClient]isHandleAuthCallback:url]) {
        //ユーザの作成処理を行う
        [[MELSUserManager sharedManager]createUserPropertyWithCompletion:^(NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (error) {
                //例外
                [self displayError:error completion:nil];
            } else {
                //ログイン成功
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"LoginSuccessMessage", nil)];
                
                //ログイン画面閉じる
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        //CallbackURLの場合はWebViewをそのまま遷移させないようにする
        return NO;
    }
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
