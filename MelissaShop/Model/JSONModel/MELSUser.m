//
//  MELSUser.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/13.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSUser.h"
#import "NSDateFormatter+GregorianCalendar.h"


@implementation MELSUser

-(id)initWithDict:(NSDictionary *)dict
{
    if(self=[super init]){
        //AppUserを作成する
        APISAppUser *appUser = [[APISAppUser alloc]initFromDictionary:dict];
        
        //AppUserからMELSUserへ置き換える
        self.id = appUser.id;
        self.loginId = appUser.loginId;
        self.password = appUser.password;
        self.email = appUser.email;
        if ([appUser.attributes objectForKey:@"gender"] != nil) {
            self.gender = [appUser.attributes objectForKey:@"gender"];
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        if ([appUser.attributes objectForKey:@"date_of_birth"] != nil) {
            self.dateOfBirth = [dateFormatter dateFromString:[appUser.attributes objectForKey:@"date_of_birth"]];
        }
    }
    return self;
}

-(void)updatePropertyWithDict:(NSDictionary*)dict
{
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
