//
//  VideoInfo.h
//  NewPipe
//
//  Created by Somiya on 2018/11/1.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoInfo : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *avatarImgUrl;
@property (nonatomic, strong) NSString *viewCount;
@property (nonatomic, strong) NSString *likeNums;
@property (nonatomic, strong) NSString *dislikeNums;

/**
 * 从网页中解析出视频信息
 */
+ (void)getVideoInfo:(void(^)(VideoInfo *videoInfo))callBack withVid:(NSString *)vid;
@end
