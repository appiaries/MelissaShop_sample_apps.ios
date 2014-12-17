//
//  MELSAppInfoManager.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/29.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSAppInfoManager.h"
#import "MELSAppInfo.h"

/**
 *  コレクション名
 */
static NSString *const kMELSCollectionAppInfo = @"appInfo";

@interface MELSAppInfoManager ()

@property (readwrite) MELSAppInfo *appInfo;

@end

@implementation MELSAppInfoManager

//--------------------------------------------------------------//
#pragma mark Initial
//--------------------------------------------------------------//
+ (MELSAppInfoManager*)sharedManager
{
    static MELSAppInfoManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MELSAppInfoManager alloc] initSharedInstance];
    });
    return sharedInstance;
}

- (id)initSharedInstance {
    self = [super init];
    if (self) {
        // 初期化処理
        self.appInfo = [[MELSAppInfo alloc]init];
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
-(void)getAppInfoWithAppInfoNumber:(NSUInteger)appInfoNumber completion:(void (^)(NSError *))block
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //条件を指定します。有効期限以降のデータを取得する
    APISQueryCondition *query = [[APISQueryCondition alloc] init];
    [query setEqualValue:[NSString stringWithFormat:@"%lun", (unsigned long)appInfoNumber] forKey:@"appInfoNumber"];
    
    //JSON API Clientから検索を呼び出す
    __weak typeof(self) weakSelf = self;
    APISJsonAPIClient *api = [[APISSession sharedSession] createJsonAPIClientWithCollectionId:kMELSCollectionAppInfo];
    [api searchJsonObjectsWithQueryCondition:query
        success:^(APISResponseObject *response) {
            //結果は「_objs」の配列で取得できる
            NSArray *objs = [response.data objectForKey:@"_objs"];
            if ([objs isKindOfClass:[NSArray class]] && [objs count] > 0) {
                //1件目だけ取得
                weakSelf.appInfo = [[MELSAppInfo alloc]initWithDict:(NSDictionary*)objs[0]];
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
