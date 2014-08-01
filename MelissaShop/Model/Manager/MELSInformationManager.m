//
//  MELSInformationManager.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/15.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSInformationManager.h"
#import "MELSAPIClient.h"
#import "MELSInformation.h"

/**
 *  コレクション名
 */
static NSString *const kMELSCollectionInformation = @"information";

@interface MELSInformationManager ()

@property (readwrite) NSMutableArray *collections;

@end

@implementation MELSInformationManager

//--------------------------------------------------------------//
#pragma mark Initial
//--------------------------------------------------------------//
+ (MELSInformationManager*)sharedManager
{
    static MELSInformationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MELSInformationManager alloc] initSharedInstance];
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
-(void)getInformationWithCompletion:(void (^)(NSError *error))block
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    //Datastoreの条件を指定します。今回は絞込条件なし、データ作成順にソートする
    NSDictionary *parameters = @{@"order": @"createdAt"};
    
    //データストアからHomeの情報を返す
    __weak typeof(self) weakSelf = self;
    [[MELSAPIClient sharedClient]searchDataStoreAPIWithCollection:kMELSCollectionInformation conditions:nil paramerters:parameters completion:^(NSDictionary *results, NSError *error) {
        ALog(@"%@", results);
        if (results && [results isKindOfClass:[NSDictionary class]]) {
            //結果は「_objs」の配列で取得できる
            NSArray *objs = [results objectForKey:@"_objs"];
            if ([objs isKindOfClass:[NSArray class]]) {
                //自身のManagerで保持している配列を一旦削除する
                [weakSelf.collections removeAllObjects];
                //配列をループで回してMELSInformationの配列を作成する
                for (NSDictionary *v in objs) {
                    MELSInformation *information = [[MELSInformation alloc]initWithDict:v];
                    [weakSelf.collections addObject:information];
                }
            }
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (block) block(error);
    }];
}

@end
