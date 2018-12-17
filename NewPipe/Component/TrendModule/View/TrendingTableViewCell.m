//
//  TrendingTableViewCell.m
//  NewPipe
//
//  Created by Somiya on 2018/10/30.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "TrendingTableViewCell.h"
#import "PlayItem.h"
#import "UIImageView+WebCache.h"
#import "NSString+Util.h"

@interface TrendingTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewsNumsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@end

@implementation TrendingTableViewCell

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
    PlayItem *item = (PlayItem *)data;
    _titleLabel.text = item.title;
    _channelLabel.text = item.channelName;
    if (item.duration != nil) {
        _durationLabel.text = [NSString stringWithFormat:@" %@ ", item.duration];
    } else {
        _durationLabel.hidden = YES;
    }
    _viewsNumsLabel.text = [NSString stringWithFormat:@"%@ views", [item.playnum convertNumber]];
    _dateLabel.text = item.lasttime;
    [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:item.imgurl] placeholderImage:[UIImage imageNamed:@"default"]];
    
}

@end
