//
//  PickTagCollectionViewCell.h
//  CollectionViewSubscriptionLabel
//
//  Created by chenyk on 15/4/24.
//  Copyright (c) 2015年 chenyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickTagCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel  * titleLabel;
- (void)select;
- (void)unselect;
- (void)resetStyle;
@end
