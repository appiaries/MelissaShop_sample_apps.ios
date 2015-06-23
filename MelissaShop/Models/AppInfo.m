//
//  AppInfo.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/29.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo
@dynamic appInfoNumber;
@dynamic title;
@dynamic description;

#pragma mark - ABManagedProtocol implementations
+ (NSString *)collectionID
{
    return @"appInfo";
}

@end
