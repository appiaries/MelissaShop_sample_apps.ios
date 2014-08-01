//
//  MELSHomeViewCell.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/15.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSHomeViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MELSInformation.h"

@implementation MELSHomeViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupWithInformation:(MELSInformation *)information
{
    [self.mainImageView setImage:nil];
    
    NSString *urlString = information.listImageUrl;
    if (urlString.length > 0) {
        __weak UIImageView *weakImageView = self.mainImageView;
        //画像表示にアニメーションを入れて、非同期でロードする
        [self.mainImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                               if (response == nil) {
                                                   weakImageView.image = image;
                                               } else {
                                                   [UIView transitionWithView:weakImageView
                                                                     duration:0.2f
                                                                      options:UIViewAnimationOptionTransitionCrossDissolve
                                                                   animations:^{
                                                                       weakImageView.image = image;
                                                                   } completion:nil];
                                               }
                                           }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                           }
         ];
    }
}

@end
