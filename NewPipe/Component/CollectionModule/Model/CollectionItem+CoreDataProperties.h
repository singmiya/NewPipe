//
//  CollectionItem+CoreDataProperties.h
//  maoying
//
//  Created by Somiya on 2018/11/7.
//  Copyright © 2018 Somiya. All rights reserved.
//
//

#import "CollectionItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CollectionItem (CoreDataProperties)

+ (NSFetchRequest<CollectionItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *vid;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *duration;
@property (nullable, nonatomic, copy) NSString *imgurl;
@property (nullable, nonatomic, copy) NSString *playnum;
@property (nullable, nonatomic, copy) NSString *badnum;
@property (nullable, nonatomic, copy) NSString *goodnum;
@property (nullable, nonatomic, copy) NSString *lasttime;
@property (nullable, nonatomic, copy) NSString *author;
@property (nullable, nonatomic, copy) NSDate *createTime;
@property (nullable, nonatomic, copy) NSDate *updateTime;

@end

NS_ASSUME_NONNULL_END
