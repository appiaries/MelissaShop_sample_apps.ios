//
//  DateHelper.h
//  MelissaShop
//
//  Created by Appiaries Corporation on 2015/04/09.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Date Helper
 */
@interface DateHelper : NSObject

#pragma mark - Helper methods
/*! @name Helper methods */
+ (NSDate *)dateFromObject:(id)object bundle:(NSBundle *)bundle;

@end