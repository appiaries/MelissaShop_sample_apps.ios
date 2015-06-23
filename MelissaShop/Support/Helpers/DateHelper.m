//
//  DateHelper.h
//  MelissaShop
//
//  Created by Appiaries Corporation on 2015/04/09.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import "DateHelper.h"


@implementation DateHelper

+ (NSDate *)dateFromObject:(id)object bundle:(NSBundle *)bundle { //ABFP
    if (!object) return nil;
    if ([object isKindOfClass:[NSDate class]]) return object;

    if  ([object isKindOfClass:[NSString class]]) {
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate error:nil];
        NSTextCheckingResult *result = [detector firstMatchInString:object options:0 range:NSMakeRange(0, [object length])];
        return (result.resultType == NSTextCheckingTypeDate) ? result.date : nil;
    }
    if ([object isKindOfClass:[NSNumber class]]) {
        if ([object longLongValue] > 10000000000) {
            return [NSDate dateWithTimeIntervalSince1970:[object doubleValue] / 1000.0];
        } else {
            return [NSDate dateWithTimeIntervalSince1970:[object doubleValue]];
        }
    }
    return nil;
}

@end