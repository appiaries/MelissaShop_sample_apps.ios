//
//  ShopListViewController.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class CLLocation;

@interface ShopListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
#pragma mark - Properties
@property (strong, nonatomic) CLLocation *currentLocation;

@end
