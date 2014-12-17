//
//  MELSInformation.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/15.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSInformation.h"

@implementation MELSInformation

-(id)initWithDict:(NSDictionary *)dict
{
    if(self=[super init]){
        _objectId = dict[@"_id"];
        _title = dict[@"title"];
        _textDescription = dict[@"description"];
        _listImageObjectId = dict[@"listImageObjectId"];
        _detailImageObjectId = dict[@"detailImageObjectId"];
        _detailBottomImageObjectId = dict[@"detailBottomImageObjectId"];
        NSTimeInterval createdAtInterval = [dict[@"createdAt"] doubleValue];
        _createdAt = [NSDate dateWithTimeIntervalSince1970:createdAtInterval];
        
        //画像のIDが入っている場合は、URLに変換したデータを保持する
        if (_listImageObjectId.length > 0) {
            _listImageUrl = [MELSInformation getImageFileUrlWithObjectId:_listImageObjectId];
        }
        if (_detailImageObjectId.length > 0) {
            _detailImageUrl = [MELSInformation getImageFileUrlWithObjectId:_detailImageObjectId];
        }
        if (_detailBottomImageObjectId.length > 0) {
            _detailBottomImageUrl = [MELSInformation getImageFileUrlWithObjectId:_detailBottomImageObjectId];
        }
    }
    return self;
}

+(NSString*)getImageFileUrlWithObjectId:(NSString*)objectId
{
    return [NSString stringWithFormat:@"%@/%@/%@/%@/%@/_bin", MELSFileUrlBase, MELSAPISDatastoreId, MELSAPISAppId, MELSImageCollectionId, objectId];
}

@end
