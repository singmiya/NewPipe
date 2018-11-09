//
//  NetWorkConstants.h
//  NewPipe
//
//  Created by Somiya on 2018/10/14.
//  Copyright © 2018 Somiya. All rights reserved.
//

#ifndef NetWorkConstants_h
#define NetWorkConstants_h

#define BASE_URL @"http://maoyingmusic.net/"
#define TRENDING_URL @"https://www.youtube.com/feed/trending"
#define VIDEO_LIST_URL(__VID) [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",__VID]
#define SEARCH_URL(__KEYWORDS,__PAGE) [NSString stringWithFormat:@"https://www.youtube.com/results?search_query=%@&page=%ld",__KEYWORDS,__PAGE]
#endif /* NetWorkConstants_h */
