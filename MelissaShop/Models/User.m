//
//  User.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/13.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "User.h"
#import "NSDateFormatter+GregorianCalendar.h"
#import "DateHelper.h"


@implementation User
@dynamic gender;
@dynamic dateOfBirth;
@dynamic address;
@dynamic favoriteFood;
@dynamic lastAccessDate;
@dynamic lastLocation;
@dynamic deviceToken;

#pragma mark - Public methods
- (NSString *)localizedGender
{
    if ([self.gender isEqualToString:@"male"]) {
        return NSLocalizedString(@"GenderMale", nil);
    } else if ([self.gender isEqualToString:@"female"]) {
        return NSLocalizedString(@"GenderFemale", nil);
    } else if ([self.gender isEqualToString:@"other"]) {
        return NSLocalizedString(@"GenderOther", nil);
    }
    return nil;
}

#pragma mark - ABObject overridden methods
#pragma mark - Instance methods (Accessors)
- (id)baasInputDataFilter:(id)data forKey:(NSString *)key
{
    id fixed = data;
    if ([key isEqualToString:@"dateOfBirth"]) {
        fixed = [DateHelper dateFromObject:data bundle:nil];
    }
    return fixed;
}
- (id)baasOutputDataFilter:(id)data forKey:(NSString *)key
{
    id fixed = data;
    if ([key isEqualToString:@"dateOfBirth"]) {
        if ([data isKindOfClass:[NSDate class]]) {

            fixed = @((long long)([(NSDate *) data timeIntervalSince1970] * (double)1000.0));
        }
    }
    return fixed;
}

#pragma mark - ABManagedProtocol implementations
+ (NSString *)collectionID
{
    return ABNullCollectionID;
}

@end
