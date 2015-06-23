//
//  NSDateFormatter+GregorianCalendar.h
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/21.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (GregorianCalendar)

- (id)initWithGregorianCalendar;

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format useGregorianCalendar:(BOOL)useGregorianCalendar;
+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format useGregorianCalendar:(BOOL)useGregorianCalendar;

@end
