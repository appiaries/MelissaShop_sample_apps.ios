//
//  MELSShopListViewController.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MELSBaseViewController.h"

@class CLLocation;

@interface MELSShopListViewController : MELSBaseViewController

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSString *searchWord;

@end
