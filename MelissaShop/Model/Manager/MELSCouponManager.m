//
//  MELSCouponManager.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/19.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSCouponManager.h"
#import "MELSAPIClient.h"
#import "MELSCoupon.h"

/**
 *  コレクション名
 */
static NSString *const kMELSCollectionCoupon = @"coupon";

@interface MELSCouponManager ()

@property (readwrite) NSMutableArray *collections;

@end

@implementation MELSCouponManager

//--------------------------------------------------------------//
#pragma mark Initial
//--------------------------------------------------------------//
+ (MELSCouponManager*)sharedManager
{
    static MELSCouponManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MELSCouponManager alloc] initSharedInstance];
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
-(void)getCouponWithCompletion:(void (^)(NSError *))block
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSDictionary *parameters = @{@"order": @"createdAt"};
    
    //有効期限以降のデータを取得する
    NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
    NSString *conditionString = [NSString stringWithFormat:@"expireDate.gte.%.fn", nowInterval];
    NSArray *conditions = @[conditionString];
    
    __weak typeof(self) weakSelf = self;
    [[MELSAPIClient sharedClient]searchDataStoreAPIWithCollection:kMELSCollectionCoupon conditions:conditions paramerters:parameters completion:^(NSDictionary *results, NSError *error) {
        ALog(@"%@", results);
        if (results && [results isKindOfClass:[NSDictionary class]]) {
            NSArray *objs = [results objectForKey:@"_objs"];
            if ([objs isKindOfClass:[NSArray class]]) {
                [weakSelf.collections removeAllObjects];
                for (NSDictionary *v in objs) {
                    MELSCoupon *coupon = [[MELSCoupon alloc]initWithDict:v];
                    [weakSelf.collections addObject:coupon];
                }
            }
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (block) block(error);
    }];
}


@end
