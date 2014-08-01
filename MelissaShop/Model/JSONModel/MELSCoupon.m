//
//  MELSCoupon.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/19.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSCoupon.h"
#import "MELSAPIClient.h"

@implementation MELSCoupon

-(id)initWithDict:(NSDictionary *)dict
{
    if(self=[super init]){
        _objectId = dict[@"_id"];
        _couponName = dict[@"couponName"];
        _couponDescription = dict[@"couponDescription"];
        NSTimeInterval expireDateInterval = [dict[@"expireDate"] doubleValue];
        _expireDate = [NSDate dateWithTimeIntervalSince1970:expireDateInterval];
        _limitCount = [dict[@"limitCount"] integerValue];
        _conditions = dict[@"conditions"];
        _usesDescription = dict[@"usesDescription"];
        _precautions = dict[@"precautions"];
        _couponImageObjectId = dict[@"couponImageObjectId"];
        NSTimeInterval createdAtInterval = [dict[@"createdAt"] doubleValue];
        _createdAt = [NSDate dateWithTimeIntervalSince1970:createdAtInterval];
        
        if (_couponImageObjectId.length > 0) {
            _couponImageUrl = [MELSAPIClient getImageFileUrlWithObjectId:_couponImageObjectId];
        }
    }
    return self;
}

@end
