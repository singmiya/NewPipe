//
//  CollectionItem+CoreDataProperties.m
//  
//
//  Created by guolinan on 2018/12/11.
//
//

#import "CollectionItem+CoreDataProperties.h"

@implementation CollectionItem (CoreDataProperties)

+ (NSFetchRequest<CollectionItem *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"CollectionItem"];
}

@dynamic author;
@dynamic badnum;
@dynamic createTime;
@dynamic duration;
@dynamic goodnum;
@dynamic imgurl;
@dynamic lasttime;
@dynamic listName;
@dynamic playnum;
@dynamic title;
@dynamic updateTime;
@dynamic vid;
@dynamic avatarImgUrl;

@end
