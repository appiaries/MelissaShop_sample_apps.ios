//
//  HomeViewCell.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/15.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Information;

@interface HomeViewCell : UITableViewCell
#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

#pragma mark - Public methods
- (void)setupWithInformation:(Information *)information;

@end
