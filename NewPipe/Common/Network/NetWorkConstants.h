//
//  NetWorkConstants.h
//  NewPipe
//
//  Created by Somiya on 2018/10/14.
//  Copyright © 2018 Somiya. All rights reserved.
//

#ifndef NetWorkConstants_h
#define NetWorkConstants_h
#define BASE_URL @"https://molinmusic.com/"
#define BASE_URL1 @"http://maoyingmusic.net/"
#define PREFIX_URL @"YoutubeFeed/Vizplay/iOSTest/"
// Youtube相关
#define IMAGE_URL(id) [NSString stringWithFormat:@"https://i.ytimg.com/vi/%@/hqdefault.jpg", id]
#define TRENDING_URL @"https://www.youtube.com/feed/trending"
#define VIDEO_LIST_URL(__VID) [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",__VID]
#define SEARCH_URL(__KEYWORDS,__PAGE) [NSString stringWithFormat:@"https://www.youtube.com/results?search_query=%@&page=%ld",__KEYWORDS,__PAGE]
#define CHANNEL_PLAYLIST_URL(__CID) [NSString stringWithFormat:@"https://www.youtube.com/channel/%@/playlists", __CID]

#define YOUTOBE_URL @"https://www.youtube.com"

// Trend Module
#define PLAY_LIST @"YoutubeFeed.json"

// Recommend Module
#define RECOMMEND_LIST @"YoutubeFeed/Vizplay/iOSTest/Youtubefeed.json"
#endif /* NetWorkConstants_h */
