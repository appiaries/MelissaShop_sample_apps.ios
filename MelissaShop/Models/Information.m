//
//  Information.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/15.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "Information.h"
#import "Image.h"

@implementation Information
@dynamic title;
@dynamic description;
@dynamic listImageObjectId;
@dynamic detailImageObjectId;
@dynamic detailBottomImageObjectId;
@dynamic createdAt;

#pragma mark - Accessors
- (NSString *)listImageUrl
{
    if (self.listImageObjectId.length > 0) {
        Image *image = [Image image];
        image.ID = self.listImageObjectId;
        return image.imageURL;
    } else {
        return nil;
    }
}
- (NSString *)detailImageUrl
{
    if (self.detailImageObjectId.length > 0) {
        Image *image = [Image image];
        image.ID = self.detailImageObjectId;
        return image.imageURL;
    } else {
        return nil;
    }
}
- (NSString *)detailBottomImageUrl
{
    if (self.detailBottomImageObjectId.length > 0) {
        Image *image = [Image image];
        image.ID = self.detailBottomImageObjectId;
        return image.imageURL;
    } else {
        return nil;
    }
}

#pragma mark - ABManagedProtocol implementations
+ (NSString *)collectionID
{
    return @"information";
}

@end
