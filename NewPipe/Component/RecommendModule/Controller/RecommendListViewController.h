//
//  RecommendListViewController.h
//  NewPipe
//
//  Created by Somiya on 2018/12/13.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "BaseViewController.h"

@interface RecommendListViewController : BaseViewController
@property (nonatomic, copy) NSString *childPath;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *url;

@end
