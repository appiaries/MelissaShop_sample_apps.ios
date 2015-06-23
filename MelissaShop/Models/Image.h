//
//  Image.h
//  MelissaShop
//
//  Created by Appiaries Corporation on 2015/04/09.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Image : ABFile <ABManagedProtocol>
#pragma mark - Properties
@property (readonly, nonatomic) NSString *imageURL; // 画像URL

#pragma mark - Initialization
+ (instancetype)image;

@end