//
//  CollectionItem+CoreDataProperties.m
//  
//
//  Created by Somiya on 2018/12/10.
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
@dynamic playnum;
@dynamic title;
@dynamic updateTime;
@dynamic vid;
@dynamic listName;

@end
