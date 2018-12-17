//
//  RecommendItem.h
//  NewPipe
//
//  Created by Somiya on 2018/12/13.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Statistics;
@interface RecommendItem : NSObject
@property (nonatomic, copy) NSString *vid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *vdescription;
@property (nonatomic, copy) NSString *childPath;
@property (nonatomic, strong) Statistics *statistics;

/**
 * 通过接口加载推荐列表
 */
+ (void)getRecommendItemList:(void(^)(NSArray *playList, NSDictionary *pageInfo))callBack url:(NSString *)url;

@end

@interface Statistics : NSObject
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger dislikeCount;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger commentCount;
@end
