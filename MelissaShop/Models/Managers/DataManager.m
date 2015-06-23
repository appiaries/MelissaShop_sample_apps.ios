//
// Created by Appiaries Corporation on 15/05/29.
// Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import "DataManager.h"
#import "Device.h"
#import "Shop.h"
#import "AppInfo.h"


@implementation DataManager

static DataManager *_sharedManager;

#pragma mark - Initialization
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[DataManager alloc] initSharedManager];
    });
    return _sharedManager;
}

- (instancetype)initSharedManager
{
    if (self = [super init]) {
        _couponList = [@[] mutableCopy];
        _infoList   = [@[] mutableCopy];
        _shopList   = [@[] mutableCopy];
    }
    return self;
}

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
