//
//  PlayListItem.h
//  NewPipe
//
//  Created by Somiya on 2019/3/20.
//  Copyright © 2019 Somiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayListItem : NSObject
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *listId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *wsrc;


+ (void)getPlayListItem:(void(^)(NSArray *items))callBack withUrl:(NSString *)url;
@end
