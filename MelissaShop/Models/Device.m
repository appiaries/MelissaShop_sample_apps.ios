//
//  Device.m
//  MelissaShop
//
//  Created by Appiaries Corporation on 2015/04/09.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import "Device.h"


@implementation Device
@dynamic gender;
@dynamic dateOfBirth;
@dynamic localizedGender;
@dynamic address;
@dynamic favoriteFood;
@dynamic lastAccessDate;
@dynamic lastLocation;

#pragma mark - ABManagedProtocol implementations
+ (NSString *)collectionID
{
    return ABNullCollectionID;
}

@end