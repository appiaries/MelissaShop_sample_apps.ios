//
//  MELSUser.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/13.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSUser.h"
#import "NSDateFormatter+GregorianCalendar.h"

/**
 *  性別、生年月日のProfileAPIから許可を得るための設定
 */
NSString *const kMELSUserProfileScope = @"gender date_of_birth";

@implementation MELSUser

-(id)initWithDict:(NSDictionary *)dict
{
    if(self=[super init]){
        _objectId = dict[@"_id"];
        _gender = dict[@"gender"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        _dateOfBirth = [dateFormatter dateFromString:dict[@"date_of_birth"]];
    }
    return self;
}

-(void)updatePropertyWithDict:(NSDictionary*)dict
{
    _propertyObjectId = dict[@"_id"];
    _address = dict[@"address"];
    _favoriteFood = dict[@"favoriteFood"];
    NSTimeInterval lastAccessDateInterval = [dict[@"lastAccessDate"] doubleValue];
    _lastAccessDate = [NSDate dateWithTimeIntervalSince1970:lastAccessDateInterval];
    _lastLocation = [[CLLocation alloc]initWithLatitude:[dict[@"lastLatitude"] doubleValue] longitude:[dict[@"lastLongitude"] doubleValue]];
    _deviceToken = dict[@"deviceToken"];
}

-(NSString*)localizedGender
{
    if ([_gender isEqualToString:@"male"]) {
        return NSLocalizedString(@"GenderMale", nil);
    } else if ([_gender isEqualToString:@"female"]) {
        return NSLocalizedString(@"GenderFemale", nil);
    } else if ([_gender isEqualToString:@"other"]) {
        return NSLocalizedString(@"GenderOther", nil);
    }
    return nil;
}

@end
