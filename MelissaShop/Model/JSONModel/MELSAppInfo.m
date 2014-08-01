//
//  MELSAppInfo.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/29.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSAppInfo.h"

@implementation MELSAppInfo

-(id)initWithDict:(NSDictionary *)dict
{
    if(self=[super init]){
        _objectId = dict[@"_id"];
        _appInfoNumber = [dict[@"appInfoNumber"] unsignedIntegerValue];
        _title = dict[@"title"];
        _description = dict[@"description"];
    }
    return self;
}

@end
