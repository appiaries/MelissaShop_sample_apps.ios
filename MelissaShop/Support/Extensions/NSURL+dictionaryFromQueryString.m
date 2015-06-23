//
//  NSURL+dictionaryFromQueryString.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/13.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "NSURL+dictionaryFromQueryString.h"

@implementation NSURL (dictionaryFromQueryString)

- (NSDictionary *)dictionaryFromQueryString{
    
    NSString *query = [self query];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [elements[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [elements[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        dict[key] = val;
    }
    return dict;
}

@end
