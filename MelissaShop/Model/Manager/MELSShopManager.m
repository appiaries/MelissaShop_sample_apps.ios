//
//  MELSShopManager.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/17.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSShopManager.h"
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
    
    //現在地から検索するときの検索条件
    APISLocation *apisLocation = [[APISLocation alloc] init];
    apisLocation.longitude = location.coordinate.longitude;
    apisLocation.latitude = location.coordinate.latitude;
    apisLocation.radius = kSearchInCircle;
    APISQueryCondition *query = [[APISQueryCondition alloc] init];
    [query setWithInCircle:apisLocation];
    
    //JSON API Clientから検索を呼び出す
    __weak typeof(self) weakSelf = self;
    APISJsonAPIClient *api = [[APISSession sharedSession] createJsonAPIClientWithCollectionId:kMELSCollectionShop];
    [api searchJsonObjectsWithQueryCondition:query
        success:^(APISResponseObject *response) {
            //結果は「_objs」の配列で取得できる
            NSArray *objs = [response.data objectForKey:@"_objs"];
            if ([objs isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [NSMutableArray new];
                //配列をループで回してMELSInformationの配列を作成する
                for (NSDictionary *v in objs) {
                    MELSShop *shop = [[MELSShop alloc]initWithDict:v location:location];
                    [array addObject:shop];
                }
                //現在地のからの距離が近い順でソートする
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"distance" ascending:YES];
                [weakSelf.collections removeAllObjects];
                weakSelf.collections = [[array sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (block) block(nil);
        } failure:^(NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (block) block(error);
        }
    ];
}

@end
