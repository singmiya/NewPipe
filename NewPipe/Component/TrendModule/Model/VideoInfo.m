//
//  VideoInfo.m
//  NewPipe
//
//  Created by Somiya on 2018/11/1.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "VideoInfo.h"
#import "NetWorkConstants.h"
#import "TFHpple.h"

@implementation VideoInfo
+ (void)getVideoInfo:(void (^)(VideoInfo *))callBack withVid:(NSString *)vid {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //    NSString *path = [NSString stringWithFormat:@"%@/trending1.html", [[NSBundle mainBundle] bundlePath]];
        //    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:VIDEO_LIST_URL(vid)]];
        callBack([VideoInfo extractorVideoInfo:vid data:data]);
    });
}

+ (VideoInfo *)extractorVideoInfo:(NSString *)vid data:(NSData *)data {
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    
    // 匹配空格和换行符的的正则表达式
    NSRegularExpression *whiteSpaceAndNewLineRegex = [NSRegularExpression regularExpressionWithPattern:@"\n\\s*" options:0 error:nil];
    VideoInfo *info = [VideoInfo new];
    NSArray *elements = [doc searchWithXPathQuery:@"//img/@data-thumb"];
    if (elements.count > 0) {
        info.avatarImgUrl = [elements[0] text];
    }
    elements = [doc searchWithXPathQuery:@"//span[@id='eow-title']"];
    if (elements.count > 0) {
        info.title = [[elements[0] text] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }

    elements = [doc searchWithXPathQuery:@"//div[@class='yt-user-info']/a"];
    if (elements.count > 0) {
        info.author = [whiteSpaceAndNewLineRegex stringByReplacingMatchesInString:[elements[0] text] options:0 range:NSMakeRange(0, [elements[0] text].length) withTemplate:@" "];
    }
    elements = [doc searchWithXPathQuery:@"//div[@class='watch-view-count']"];
    if (elements.count > 0) {
        NSString *tempCount = [[elements[0] text] stringByReplacingOccurrencesOfString:NSLocalizedString(@"views", nil) withString:@""];
        info.viewCount = [whiteSpaceAndNewLineRegex stringByReplacingMatchesInString:tempCount options:0 range:NSMakeRange(0, tempCount.length) withTemplate:@" "];
    }
    elements = [doc searchWithXPathQuery:@"//span[contains(@class, 'like-button-renderer')]/span/button/span"];
    if (elements.count == 4) {
        info.likeNums = [elements[1] text];
        info.dislikeNums = [elements[3] text];
    }
    return info;
}
@end
