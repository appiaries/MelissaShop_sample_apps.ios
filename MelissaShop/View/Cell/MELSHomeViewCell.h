//
//  MELSHomeViewCell.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/15.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MELSInformation;

@interface MELSHomeViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

/**
 *  ModelからCellに情報を登録
 *
 *  @param information Informationオブジェクト
 */
-(void)setupWithInformation:(MELSInformation*)information;

@end
