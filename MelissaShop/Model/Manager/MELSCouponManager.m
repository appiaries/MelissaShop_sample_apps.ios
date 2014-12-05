//
//  MELSCouponManager.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/19.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSCouponManager.h"
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
    
    //条件を指定します。今回は絞込条件なし、データ作成順にソートする
    APISQueryCondition *query = [[APISQueryCondition alloc] init];
    //    NSDictionary *parameters = @{@"order": @"createdAt"};
    
    //JSON API Clientから検索を呼び出す
    __weak typeof(self) weakSelf = self;
    APISJsonAPIClient *api = [[APISSession sharedSession] createJsonAPIClientWithCollectionId:kMELSCollectionCoupon];
    [api searchJsonObjectsWithQueryCondition:query
        success:^(APISResponseObject *response) {
            //結果は「_objs」の配列で取得できる
            NSArray *objs = [response.data objectForKey:@"_objs"];
            if ([objs isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [NSMutableArray new];
                //配列をループで回してMELSInformationの配列を作成する
                for (NSDictionary *v in objs) {
                    MELSCoupon *coupon = [[MELSCoupon alloc]initWithDict:v];
                    [array addObject:coupon];
                }
                weakSelf.collections = [array mutableCopy];
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
