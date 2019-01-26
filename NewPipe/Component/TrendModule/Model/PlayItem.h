//
//  PlayItem+CoreDataClass.h
//  
//
//  Created by Somiya on 2018/10/22.
//
//

#import <Foundation/Foundation.h>

@interface PlayItem : NSObject
@property (nullable, nonatomic, copy) NSString *vid;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *channel;
@property (nullable, nonatomic, copy) NSString *channelName;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *duration;
@property (nullable, nonatomic, copy) NSString *imgurl;
@property (nullable, nonatomic, copy) NSString *playnum;
@property (nullable, nonatomic, copy) NSString *badnum;
@property (nullable, nonatomic, copy) NSString *goodnum;
@property (nullable, nonatomic, copy) NSString *lasttime;
@property (nullable, nonatomic, copy) NSString *vdescription;
@property (nonatomic, copy) NSString *avatarImgUrl;


/**
 * 通过接口加载推荐列表
 */
+ (void)getRecommendPlayItemList:(void(^)(NSArray *playList))callBack;
/**
 * 从网页中解析数据保存到数据库中并返回刷新页面
 */
+ (void)getPlayItemList:(void(^)(NSArray *playList))callBack;
/**
 * 从缓存中读取数据
 */
+ (void)getCachedPlayItemList:(void(^)(NSArray *playList))callBack;
/**
 * 从网页中解析出相关视频列表
 */
+ (void)getVideoList:(void(^)(NSArray *videoList))callBack withVid:(NSString *)vid;
+ (void)getVideoList:(void(^)(NSArray *videoList))callBack withUrl:(NSString *)url;

+ (void)getSearchResult:(void(^)(NSArray *retList))callBack searchString:(NSString *)searchStr page:(NSInteger)page;
@end
