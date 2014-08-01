//
//  MELSShop.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/17.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSShop.h"

@implementation MELSShop

-(id)initWithDict:(NSDictionary *)dict location:(CLLocation *)location
{
    if(self=[super init]){
        _objectId = dict[@"_id"];
        _shopName = dict[@"shopName"];
        _shopAddress = dict[@"shopAddress"];
        _shopTel = dict[@"shopTel"];
        _shopName = dict[@"shopName"];
        //位置情報が付与されているJSONデータは_coordという配列に経度、緯度の順番で格納されている
        if ([dict[@"_coord"] isKindOfClass:[NSArray class]]){
            NSArray *coord = dict[@"_coord"];
            _shopLocation = [[CLLocation alloc]initWithLatitude:[coord[1] doubleValue] longitude:[coord[0] doubleValue]];
        }
        NSTimeInterval createdAtInterval = [dict[@"createdAt"] doubleValue];
        _createdAt = [NSDate dateWithTimeIntervalSince1970:createdAtInterval];
        
        //引数で指定された位置からの距離を格納する
        if (location != nil) {
            _distance = [location distanceFromLocation:_shopLocation];
        }
    }
    return self;
}

@end
