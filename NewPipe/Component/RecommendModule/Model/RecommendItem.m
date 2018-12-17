//
//  RecommendItem.m
//  NewPipe
//
//  Created by Somiya on 2018/12/13.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "RecommendItem.h"
#import "NetWorkConstants.h"
#import "DataSourceManager.h"
#import "YYModel.h"

@implementation RecommendItem

+ (NSDictionary *)modelCustomPropertyMapper {
    //    [NSString stringWithFormat:@"https://www.youtube.comwatch?v=%@", @"xx"];
    return @{@"vid" : @"id",
             @"vdescription" : @"description"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"statistics": [Statistics class]};
}

+ (void)getRecommendItemList:(void (^)(NSArray * _Nonnull, NSDictionary *_Nonnull))callBack url:(NSString *)url {
    [[DataSourceManager sharedInstance] get:url params:nil success:^(id response) {
        NSMutableArray *items = [NSMutableArray array];
        for (NSDictionary *dic in response[@"items"]) {
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            RecommendItem *obj = [RecommendItem yy_modelWithDictionary:dic];
            if (obj) {
                [items addObject:obj];
            }
        }
        callBack(items, response[@"pageInfo"]);
    } failure:^(id response) {
        callBack(@[], @{});
    }];
}
@end

@implementation Statistics
@end
