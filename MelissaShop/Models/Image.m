//
//  Image.m
//  MelissaShop
//
//  Created by Appiaries Corporation on 2015/04/09.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import "Image.h"


@implementation Image

#pragma mark - Initialization
+ (instancetype)image
{
    return [self file];
}

#pragma mark - Public methods
- (NSString *)imageURL
{
    // @note このアプリでは、コードを簡潔にするために画像ファイルURLをコード内で組み立てていますが、
    //       [baas.file findWithQuery:] メソッド等を介してファイルオブジェクトを取得した場合は、
    //       urlプロパティから画像URLを取得することができます。
    return [NSString stringWithFormat:@"%@/%@/%@/%@/%@/_bin",
                    @"https://api-datastore.appiaries.com/v1/bin",
                    baas.config.datastoreID, baas.config.applicationID, [Image collectionID], self.ID];
}

#pragma mark - ABManagedProtocol implementations
+ (NSString *)collectionID
{
    return @"imageFile";
}

@end