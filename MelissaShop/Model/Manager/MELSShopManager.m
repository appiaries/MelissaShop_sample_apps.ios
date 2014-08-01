//
//  MELSShopManager.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/17.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSShopManager.h"
#import "MELSAPIClient.h"
#import "MELSShop.h"
#import <CoreLocation/CoreLocation.h>

/**
 *  コレクション名
 */
static NSString *const kMELSCollectionShop = @"shop";

/**
 *  現在地から検索するの範囲（km）
 */
static float const kSearchInCircle = 10.0f;

@interface MELSShopManager ()

@property (readwrite) NSMutableArray *collections;

@end

@implementation MELSShopManager

//--------------------------------------------------------------//
#pragma mark Initial
//--------------------------------------------------------------//
+ (MELSShopManager*)sharedManager
{
    static MELSShopManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MELSShopManager alloc] initSharedInstance];
    });
    return sharedInstance;
}

- (id)initSharedInstance {
    self = [super init];
    if (self) {
        // 初期化処理
        self.collections = [NSMutableArray new];
    }
    return self;
}

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

//--------------------------------------------------------------//
#pragma mark Public method
//--------------------------------------------------------------//
-(void)getShopWithLocation:(CLLocation *)location completion:(void (^)(NSError *))block
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSDictionary *parameters = nil;
    
    //現在地から検索するときの検索条件
    NSString *conditionString = [NSString stringWithFormat:@"_coord.wic.%f,%f,%f", location.coordinate.longitude, location.coordinate.latitude, kSearchInCircle];
    NSArray *conditions = @[conditionString];
    
    __weak typeof(self) weakSelf = self;
    //DataStoreAPIの呼び出し
    [[MELSAPIClient sharedClient]searchDataStoreAPIWithCollection:kMELSCollectionShop conditions:conditions paramerters:parameters completion:^(NSDictionary *results, NSError *error) {
        ALog(@"%@", results);
        if (results && [results isKindOfClass:[NSDictionary class]]) {
            NSArray *objs = [results objectForKey:@"_objs"];
            if ([objs isKindOfClass:[NSArray class]]) {
                NSMutableArray *shops = [NSMutableArray new];
                for (NSDictionary *v in objs) {
                    MELSShop *shop = [[MELSShop alloc]initWithDict:v location:location];
                    [shops addObject:shop];
                }
                //現在地のからの距離が近い順でソートする
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"distance" ascending:YES];
                [weakSelf.collections removeAllObjects];
                weakSelf.collections = [[shops sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
            }
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (block) block(error);
    }];
}

-(void)getShopWithWord:(NSString *)word location:(CLLocation*)location completion:(void (^)(NSError *))block
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSDictionary *parameters = @{@"order": @"_coord"};
    
    NSString *conditionString = [NSString stringWithFormat:@"shopName.eq.%@", [self urlEncoding:word]];
    NSArray *conditions = @[conditionString];
    
    __weak typeof(self) weakSelf = self;
    [[MELSAPIClient sharedClient]searchDataStoreAPIWithCollection:kMELSCollectionShop conditions:conditions paramerters:parameters completion:^(NSDictionary *results, NSError *error) {
        ALog(@"%@", results);
        if (results && [results isKindOfClass:[NSDictionary class]]) {
            NSArray *objs = [results objectForKey:@"_objs"];
            if ([objs isKindOfClass:[NSArray class]]) {
                [weakSelf.collections removeAllObjects];
                for (NSDictionary *v in objs) {
                    MELSShop *shop = [[MELSShop alloc]initWithDict:v location:location];
                    [weakSelf.collections addObject:shop];
                }
            }
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (block) block(error);
    }];
}

-(NSString*)urlEncoding:(NSString*)plainString
{
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)plainString,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
    return escapedString;
}


@end
