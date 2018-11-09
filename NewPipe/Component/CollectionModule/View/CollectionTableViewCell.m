//
//  CollectionTableViewCell.m
//  maoying
//
//  Created by Somiya on 2018/10/30.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "CollectionTableViewCell.h"
#import "CollectionItem+CoreDataClass.h"
#import "UIImageView+WebCache.h"
#import "NSString+Util.h"

@interface CollectionTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewsNumsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@end

@implementation CollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.durationLabel.layer.cornerRadius = 3;
    self.durationLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//------ configuration cell data
- (void)configCellData:(id)data {
    CollectionItem *item = (CollectionItem *)data;
    _titleLabel.text = item.title;
    _channelLabel.text = item.author;
    if (item.duration != nil) {
        _durationLabel.text = [NSString stringWithFormat:@" %@ ", item.duration];
    } else {
        _durationLabel.hidden = YES;
    }
    _viewsNumsLabel.text = [NSString stringWithFormat:@"%@ views", [item.playnum convertNumber]];
    _dateLabel.text = item.lasttime;
    [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:item.imgurl]];
    
}

@end
