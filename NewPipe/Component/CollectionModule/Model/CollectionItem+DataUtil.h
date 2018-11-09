//
//  CollectionItem+DataUtil.h
//  maoying
//
//  Created by Somiya on 2018/11/7.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "CollectionItem+CoreDataClass.h"

@interface CollectionItem (DataUtil)
+ (void)getSearchResult:(void(^)(NSArray *playList))callBack searchString:(NSString *)searchStr page:(NSInteger)page;
@end
