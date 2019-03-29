//
//  PlayListItem.m
//  NewPipe
//
//  Created by Somiya on 2019/3/20.
//  Copyright © 2019 Somiya. All rights reserved.
//

#import "PlayListItem.h"
#import "NetWorkConstants.h"
#import "YYModel.h"
#import "TFHpple.h"

@implementation PlayListItem
+ (void)getPlayListItem:(void (^)(NSArray *))callBack withUrl:(NSString *)url {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *_url = [[NSString stringWithFormat:@"%@/playlists", url] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:_url]];
//        NSError *error = nil;
//        NSLog(@"The file is %lu bytes", (unsigned long)[data length]);
//        NSString *fileStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//        BOOL written = [data writeToFile:[fileStr stringByAppendingPathComponent:@"list123.html"] options:0 error:&error];
//        if(!written){
//            NSLog(@"write failed: %@", [error localizedDescription]);
//        }
        callBack([PlayListItem extractorPlayList:data]);
    });
}

+ (NSArray *)extractorPlayList:(NSData *)data {
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements = [doc searchWithXPathQuery:@"//li[contains(@class,'channels-content-item')]"];
    NSMutableArray *playList = [NSMutableArray array];
    // 匹配空格和换行符的的正则表达式
    NSRegularExpression *whiteSpaceAndNewLineRegex = [NSRegularExpression regularExpressionWithPattern:@"\n\\s*" options:0 error:nil];
    for (TFHppleElement *element in elements) {
        PlayListItem *item = [PlayListItem new];
        // 解析list id
        NSArray *listIds = [element searchWithXPathQuery:@"//button[contains(@class, 'yt-uix-button')]/@data-list-id"];
        if (listIds.count <= 0) {
            continue;
        }
        item.listId = [listIds[0] text];
        // 解析title
        NSArray *titles = [element searchWithXPathQuery:@"//h3[contains(@class, 'yt-lockup-title')]/a/@title"];
        if (titles.count > 0) {
            item.title = [titles[0] content];
        }
        // 解析watch vid url
        NSArray *wsrcs = [element searchWithXPathQuery:@"//a[contains(@class, 'yt-pl-thumb-link')]/@href"];
        if (wsrcs.count > 0) {
            item.wsrc = [wsrcs[0] text];
        }
        // 解析count
        NSArray *counts = [element searchWithXPathQuery:@"//span[contains(@class, 'formatted-video-count-label')]/b"];
        if (counts.count > 0) {
            item.count = [counts[0] text];
        }
        // 解析img url
        NSArray *imgs = [element searchWithXPathQuery:@"//span[contains(@class, 'yt-thumb-clip')]/img/@src"];
        if (imgs.count > 0) {
            item.imgUrl = [imgs[0] text];
        }
        [playList addObject:item];
    }
    return playList;
}
@end
