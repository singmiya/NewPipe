//
//  RecommendTableViewCell.m
//  NewPipe
//
//  Created by Somiya on 2018/10/30.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "RecommendTableViewCell.h"
#import "RecommendItem.h"
#import "UIImageView+WebCache.h"
#import "NSString+Util.h"
#import "NetWorkConstants.h"
#import "PlayItem.h"

@interface RecommendTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewsNumsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
@implementation RecommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.durationLabel.layer.cornerRadius = 3;
//    self.durationLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellData:(id)data {
    if ([data isKindOfClass:[RecommendItem class]]) {
        RecommendItem *item =(RecommendItem *)data;
        _titleLabel.text = item.title;
        _descriptionLabel.text = item.vdescription;
        _viewsNumsLabel.text = [NSString stringWithFormat:@"%@ %@", [NSString convertNumberToStr:item.statistics.viewCount], NSLocalizedString(@"views", nil)];
        [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:IMAGE_URL(item.vid)] placeholderImage:[UIImage imageNamed:@"default"]];
    } else {
        PlayItem *item = (PlayItem *)data;
        _titleLabel.text = item.title;
        if (item.duration != nil) {
            _durationLabel.text = [NSString stringWithFormat:@" %@ ", item.duration];
        } else {
            _durationLabel.hidden = YES;
        }
        _descriptionLabel.text = item.vdescription;
        _viewsNumsLabel.text = [NSString stringWithFormat:@"%@ %@", [item.playnum convertNumber], NSLocalizedString(@"views", nil)];
        _dateLabel.text = item.lasttime;
        [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:IMAGE_URL(item.vid)] placeholderImage:[UIImage imageNamed:@"default"]];
    }
}
@end
