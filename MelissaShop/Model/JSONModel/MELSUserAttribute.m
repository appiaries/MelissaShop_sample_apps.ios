//
//  MELSUserAttribute.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/12/05.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSUserAttribute.h"
#import "NSDateFormatter+GregorianCalendar.h"

@implementation MELSUserAttribute

-(id)initWithDict:(NSDictionary *)dict
{
    if(self=[super init]){
        if ([dict objectForKey:@"gender"] != nil) {
            _gender = [dict objectForKey:@"gender"];
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        if ([dict objectForKey:@"date_of_birth"] != nil) {
            _dateOfBirth = [dateFormatter dateFromString:[dict objectForKey:@"date_of_birth"]];
        }
        if ([dict objectForKey:@"address"] != nil) {
            _address = [dict objectForKey:@"address"];
        }
        if ([dict objectForKey:@"favoriteFood"] != nil) {
            _favoriteFood = [dict objectForKey:@"favoriteFood"];
        }
        if ([dict objectForKey:@"lastAccessDate"] != nil) {
            NSTimeInterval lastAccessDateInterval = [dict[@"lastAccessDate"] doubleValue];
            _lastAccessDate = [NSDate dateWithTimeIntervalSince1970:lastAccessDateInterval];
        }
        if ([dict objectForKey:@"lastLatitude"] != nil && [dict objectForKey:@"lastLongitude"] != nil) {
            _lastLocation = [[CLLocation alloc]initWithLatitude:[dict[@"lastLatitude"] doubleValue] longitude:[dict[@"lastLongitude"] doubleValue]];
        }
    }
    return self;
}

-(NSDictionary *)dictionaryWithUserAttribute
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSDictionary *dict = @{
                           @"gender": self.gender ?:@"",
                           @"date_of_birth": [dateFormatter stringFromDate:self.dateOfBirth] ?: @"",
                           @"address": self.address ?:@"",
                           @"favoriteFood": self.favoriteFood ?:@"",
                           @"lastAccessDate": [NSNumber numberWithUnsignedLong:(unsigned long)[self.lastAccessDate timeIntervalSince1970]] ?:0,
                           @"lastLatitude": [NSNumber numberWithDouble:self.lastLocation.coordinate.latitude] ?: 0,
                           @"lastLongitude": [NSNumber numberWithDouble:self.lastLocation.coordinate.longitude] ?: 0,
                           };
    return dict;
}

-(void)updateIfExistsUserAttribute:(MELSUserAttribute *)userAttribute
{
    if (userAttribute.gender){
        self.gender = userAttribute.gender;
    }
    if (userAttribute.dateOfBirth){
        self.dateOfBirth = userAttribute.dateOfBirth;
    }
    if (userAttribute.address){
        self.address = userAttribute.address;
    }
    if (userAttribute.favoriteFood){
        self.favoriteFood = userAttribute.favoriteFood;
    }
    if (userAttribute.lastAccessDate){
        self.lastAccessDate = userAttribute.lastAccessDate;
    }
    if (userAttribute.lastLocation){
        self.lastLocation = userAttribute.lastLocation;
    }
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
