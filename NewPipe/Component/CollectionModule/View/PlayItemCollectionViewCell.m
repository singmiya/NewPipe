//
//  PlayItemCollectionViewCell.m
//  NewPipe
//
//  Created by Somiya on 2018/12/11.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "PlayItemCollectionViewCell.h"
#import "CollectionItem+CoreDataClass.h"
@interface PlayItemCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation PlayItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCellData:(id)data {
    CollectionItem *item = (CollectionItem *)data;
    
}
@end
