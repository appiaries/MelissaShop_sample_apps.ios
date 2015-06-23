//
//  NSDateFormatter+GregorianCalendar.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/21.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "NSDateFormatter+GregorianCalendar.h"

@implementation NSDateFormatter (GregorianCalendar)

- (id)initWithGregorianCalendar {
    self = [self init];
    if (self) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [self setLocale:[NSLocale systemLocale]];
        [self setTimeZone:[NSTimeZone systemTimeZone]];
        [self setCalendar:calendar];
    }
    return self;
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    return [NSDateFormatter stringFromDate:date format:format useGregorianCalendar:NO];
}
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format useGregorianCalendar:(BOOL)useGregorianCalendar
{
    if (!date) return nil;

    NSDateFormatter *fmt;
    fmt = useGregorianCalendar ? [[NSDateFormatter alloc] initWithGregorianCalendar] : [[NSDateFormatter alloc] init];
    fmt.dateFormat = format;
    return [fmt stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format
{
    return [NSDateFormatter dateFromString:string format:format useGregorianCalendar:NO];
}
+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format useGregorianCalendar:(BOOL)useGregorianCalendar
{
    if (!string) return nil;

    NSDateFormatter *fmt;
    fmt = useGregorianCalendar ? [[NSDateFormatter alloc] initWithGregorianCalendar] : [[NSDateFormatter alloc] init];
    fmt.dateFormat = format;
    return [fmt dateFromString:string];
}

@end
