//
//  Coupon.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/19.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "Coupon.h"
#import "Image.h"

@implementation Coupon
@dynamic couponName;
@dynamic couponDescription;
@dynamic expireDate;
@dynamic limitCount;
@dynamic conditions;
@dynamic usesDescription;
@dynamic precautions;
@dynamic couponImageObjectId;

#pragma mark - Accessors
- (NSString *)couponImageUrl
{
    if (self.couponImageObjectId) {
        Image *image = [Image image];
        image.ID = self.couponImageObjectId;
        return image.imageURL;
    } else {
        return nil;
    }
}

#pragma mark - ABManagedProtocol implementations
+ (NSString *)collectionID
{
    return @"coupon";
}

@end
