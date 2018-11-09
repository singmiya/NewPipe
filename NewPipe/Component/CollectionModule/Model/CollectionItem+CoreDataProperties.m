//
//  CollectionItem+CoreDataProperties.m
//  maoying
//
//  Created by Somiya on 2018/11/7.
//  Copyright © 2018 Somiya. All rights reserved.
//
//

#import "CollectionItem+CoreDataProperties.h"

@implementation CollectionItem (CoreDataProperties)

+ (NSFetchRequest<CollectionItem *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"CollectionItem"];
}

@dynamic vid;
@dynamic title;
@dynamic duration;
@dynamic imgurl;
@dynamic playnum;
@dynamic badnum;
@dynamic goodnum;
@dynamic lasttime;
@dynamic author;
@dynamic createTime;
@dynamic updateTime;

@end
