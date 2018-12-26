//
//  PlayItem+CoreDataClass.m
//  
//
//  Created by Somiya on 2018/10/22.
//
//

#import "PlayItem.h"
#import "DataSourceManager.h"
#import "NetWorkConstants.h"
#import "YYModel.h"
#import "TFHpple.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation PlayItem

+ (NSDictionary *)modelCustomPropertyMapper {
//    [NSString stringWithFormat:@"https://www.youtube.comwatch?v=%@", @"xx"];
    return @{@"vid" : @"id",
             @"vdescription" : @"description"
             };
}

+ (void)getRecommendPlayItemList:(void (^)(NSArray * _Nonnull))callBack {
    NSString *url = [NSString stringWithFormat:@"%@%@YoutubeFeed.json", BASE_URL, PLAY_LIST];
    [[DataSourceManager sharedInstance] get:url params:nil success:^(id response) {
        NSMutableArray *items = [NSMutableArray array];
        for (NSDictionary *dic in response[@"items"]) {
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            PlayItem *obj = [PlayItem yy_modelWithDictionary:dic];
            if (obj) {
                [items addObject:obj];
            }
        }
        callBack(items);
    } failure:^(id response) {
        callBack(@[]);
    }];
}

+ (void)getCachedPlayItemList:(void(^)(NSArray *playList))callBack {
//    NSArray *items = [PlayItem MR_findAll];
//    callBack(items);
}
/**
 * 从网页中解析数据并保存到数据库中
 */
+ (void)getPlayItemList:(void(^)(NSArray *playList))callBack {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //    NSString *path = [NSString stringWithFormat:@"%@/data.html", [[NSBundle mainBundle] bundlePath]];
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:TRENDING_URL]];
        callBack([PlayItem extractorPlayList: data]);
    });
}

+ (NSArray *)extractorPlayList:(NSData *)data {
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements = [doc searchWithXPathQuery:@"//div[contains(@class,'expanded-shelf-content-item')]"];
    NSMutableArray *playList = [NSMutableArray array];
    // 匹配空格和换行符的的真个表达式
    NSRegularExpression *whiteSpaceAndNewLineRegex = [NSRegularExpression regularExpressionWithPattern:@"\n\\s*" options:0 error:nil];

    for (TFHppleElement *element in elements) {
        PlayItem *item = [PlayItem new];
        // 解析id
        NSArray *lookUpDivs = [element searchWithXPathQuery:@"//div[1]/@data-context-item-id"];
        if (lookUpDivs.count <= 0) {
            continue;
        }
        TFHppleElement *lookUpDiv = lookUpDivs[0];
        item.vid = [lookUpDiv text];
        // 解析img
        NSArray *thumbs = [element searchWithXPathQuery:@"//span[@class='yt-thumb-simple']/img/@src"];
        if (thumbs.count > 0) {
            item.imgurl = [thumbs[0] text];
        }
        // 解析duration
        NSArray *durations = [element searchWithXPathQuery:@"//span[@class='yt-thumb-simple']/span"];
        if (durations.count > 0) {
            item.duration = [durations[0] content];
        }
        // 解析title
        NSArray *titles = [element searchWithXPathQuery:@"//h3/a/@title"];
        if (titles.count > 0) {
            item.title = [titles[0] text];
        }

        // 解析channel
        NSArray *channels = [element searchWithXPathQuery:@"//div[contains(@class, 'yt-lockup-byline')]/a"];
        if (channels.count > 0) {
            item.channel = [[channels[0] attributes] valueForKey:@"href"];
            item.channelName = [whiteSpaceAndNewLineRegex stringByReplacingMatchesInString:[channels[0] text] options:0 range:NSMakeRange(0, [channels[0] text].length) withTemplate:@" "];
        }
        // 解析lasttime
        NSArray *times = [element searchWithXPathQuery:@"//ul[@class='yt-lockup-meta-info']/li"];
        if (times.count > 1) {
            item.lasttime = [[times[0] content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *playnum = [[times[1] content] stringByReplacingOccurrencesOfString:@"views" withString:@""];
            item.playnum  = [whiteSpaceAndNewLineRegex stringByReplacingMatchesInString:playnum options:0 range:NSMakeRange(0, playnum.length) withTemplate:@" "];
        }
        [playList addObject:item];
    }
    
    return playList;
}

+ (void)getVideoList:(void (^)(NSArray *))callBack withVid:(NSString *)vid {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //    NSString *path = [NSString stringWithFormat:@"%@/trending1.html", [[NSBundle mainBundle] bundlePath]];
        //    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:VIDEO_LIST_URL(vid)]];
        callBack([PlayItem extractorRelatedVideoList:vid data:data]);
    });
}

+ (void)getVideoList:(void (^)(NSArray *))callBack withUrl:(NSString *)url {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSString *path = [NSString stringWithFormat:@"%@/list123.html", [[NSBundle mainBundle] bundlePath]];
        //    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
//        NSError *error = nil;
//        NSLog(@"The file is %lu bytes", (unsigned long)[data length]);
//        NSString *fileStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//        BOOL written = [data writeToFile:[fileStr stringByAppendingPathComponent:@"list123.html"] options:0 error:&error];
//        if(!written){
//            NSLog(@"write failed: %@", [error localizedDescription]);
//        }
        callBack([PlayItem extractorDefaultRecommendPlayList:data]);
    });
}

+ (NSArray *)extractorRelatedVideoList:(NSString *)vid data:(NSData *)data {
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements = [doc searchWithXPathQuery:@"//ul[contains(@id,'watch-related')]/li"];
    NSMutableArray *releatedVideoList = [NSMutableArray array];
    // 匹配空格和换行符的的正则表达式
    NSRegularExpression *whiteSpaceAndNewLineRegex = [NSRegularExpression regularExpressionWithPattern:@"\n\\s*" options:0 error:nil];
    for (TFHppleElement *element in elements) {
        PlayItem *item = [PlayItem new];
        // 解析id
        NSArray *ids = [element searchWithXPathQuery:@"//div[@class='thumb-wrapper']/a/span/@data-vid"];
        if (ids.count <= 0) {
            continue;
        }
        item.vid = [ids[0] text];
        
        NSArray *thumbs = [element searchWithXPathQuery:@"//div[@class='thumb-wrapper']/a/span/img/@data-thumb"];
        if (thumbs.count > 0) {
            item.imgurl = [thumbs[0] text];
        }
        // 解析duration
        NSArray *durations = [element searchWithXPathQuery:@"//span[@class='video-time']"];
        if (durations.count > 0) {
            item.duration = [durations[0] content];
        }
        // 解析title
        NSArray *titles = [element searchWithXPathQuery:@"//span[@class='title']"];
        if (titles.count > 0) {
            item.title = [[titles[0] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        // 解析channel
        NSArray *channels = [element searchWithXPathQuery:@"//span[contains(@class, 'attribution')"];
        if (channels.count > 0) {
            item.channelName = [whiteSpaceAndNewLineRegex stringByReplacingMatchesInString:[channels[0] text] options:0 range:NSMakeRange(0, [channels[0] text].length) withTemplate:@" "];
        }
        // 解析play numbers
        NSArray *nums = [element searchWithXPathQuery:@"//span[contains(@class, 'view-count')]"];
        if (nums.count > 0) {
            NSString *playnum = [[nums[0] text] stringByReplacingOccurrencesOfString:NSLocalizedString(@"views", nil) withString:@""];
            item.playnum  = [whiteSpaceAndNewLineRegex stringByReplacingMatchesInString:playnum options:0 range:NSMakeRange(0, playnum.length) withTemplate:@" "];
        }
        [releatedVideoList addObject:item];
    }
    
    return releatedVideoList;
}

+ (void)getSearchResult:(void (^)(NSArray *))callBack searchString:(NSString *)searchStr page:(NSInteger)page {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = [SEARCH_URL(searchStr, page) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
//        NSString *path = [NSString stringWithFormat:@"%@/search.html", [[NSBundle mainBundle] bundlePath]];
//        NSError *error = nil;
//        BOOL written = [data writeToFile:path options:NSDataWritingAtomic error:&error];
        callBack([PlayItem extractorSearchResultList:data]);
    });
}

+ (NSArray *)extractorSearchResultList:(NSData *)data {
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements = [doc searchWithXPathQuery:@"//ol[@class='item-section']/li"];
    NSMutableArray *retList = [NSMutableArray array];
    // 匹配空格和换行符的的真个表达式
    NSRegularExpression *whiteSpaceAndNewLineRegex = [NSRegularExpression regularExpressionWithPattern:@"\n\\s*" options:0 error:nil];
    
    for (TFHppleElement *element in elements) {
        PlayItem *item = [PlayItem new];
        // 解析id
        NSArray *lookUpDivs = [element searchWithXPathQuery:@"//div[1]/@data-context-item-id"];
        if (lookUpDivs.count <= 0) {
            continue;
        }
        item.vid = [lookUpDivs[0] text];
        // 解析img
        NSArray *thumbs1 = [element searchWithXPathQuery:@"//span[@class='yt-thumb-simple']/img/@src"];
        NSArray *thumbs2 = [element searchWithXPathQuery:@"//span[@class='yt-thumb-simple']/img/@data-thumb"];
        if (thumbs1.count > 0) {
            item.imgurl = [thumbs1[0] text];
            if ([item.imgurl hasSuffix:@".gif"]) {
                item.imgurl = [thumbs2[0] text];
            }
        }
        // 解析duration
        NSArray *durations = [element searchWithXPathQuery:@"//span[@class='yt-thumb-simple']/span"];
        if (durations.count > 0) {
            item.duration = [durations[0] content];
        }
        // 解析title
        NSArray *titles = [element searchWithXPathQuery:@"//h3/a/@title"];
        if (titles.count > 0) {
            item.title = [titles[0] text];
        }
        
        // 解析channel
        NSArray *channels = [element searchWithXPathQuery:@"//div[contains(@class, 'yt-lockup-byline')]/a"];
        if (channels.count > 0) {
            item.channel = [[channels[0] attributes] valueForKey:@"href"];
            item.channelName = [whiteSpaceAndNewLineRegex stringByReplacingMatchesInString:[channels[0] text] options:0 range:NSMakeRange(0, [channels[0] text].length) withTemplate:@" "];
        }
        // 解析lasttime
        NSArray *times = [element searchWithXPathQuery:@"//ul[@class='yt-lockup-meta-info']/li"];
        if (times.count > 1) {
            item.lasttime = [[times[0] content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *playnum = [[times[1] content] stringByReplacingOccurrencesOfString:@"views" withString:@""];
            item.playnum  = [whiteSpaceAndNewLineRegex stringByReplacingMatchesInString:playnum options:0 range:NSMakeRange(0, playnum.length) withTemplate:@" "];
        }
        [retList addObject:item];
    }
    
    return retList;
}

+ (NSArray *)extractorDefaultRecommendPlayList:(NSData *)data {
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements = [doc searchWithXPathQuery:@"//ol[contains(@id,'playlist-autoscroll-list')]/li"];
    NSMutableArray *videoList = [NSMutableArray array];
    // 匹配空格和换行符的的真个表达式
    NSRegularExpression *whiteSpaceAndNewLineRegex = [NSRegularExpression regularExpressionWithPattern:@"\n\\s*" options:0 error:nil];
    for (TFHppleElement *element in elements) {
        PlayItem *item = [PlayItem new];
        // 解析id
        NSArray *ids = [element searchWithXPathQuery:@"//@data-video-id"];
        if (ids.count <= 0) {
            continue;
        }
        item.vid = [ids[0] text];
        // img
        NSArray *thumbs = [element searchWithXPathQuery:@"//@data-thumbnail-url"];
        if (thumbs.count <= 0) {
            continue;
        }
        item.imgurl = [thumbs[0] text];
        // title
        NSArray *titles = [element searchWithXPathQuery:@"//@data-video-title"];
        if (ids.count <= 0) {
            continue;
        }
        item.title = [titles[0] text];
        // author
        NSArray *channels = [element searchWithXPathQuery:@"//@data-video-username"];
        if (ids.count <= 0) {
            continue;
        }
        item.channelName = [channels[0] text];
        [videoList addObject:item];
    }
    return videoList;
}
@end
