//
//  SectionCollectionViewCell.m
//  NewPipe
//
//  Created by Somiya on 2018/12/11.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "SectionCollectionViewCell.h"
#import "CollectionItem+CoreDataClass.h"
#import "UIImageView+WebCache.h"
#import "NSString+Util.h"

@interface SectionCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end
@implementation SectionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.durationLabel.layer.cornerRadius = 3;
    self.durationLabel.layer.masksToBounds = YES;
    // Initialization code
}
- (void)configCellData:(id)data title:(NSString *)title {
    CollectionItem *item = (CollectionItem *)data;
    _timeLabel.text = title;
    _nameLabel.text = item.author;
    if (item.duration != nil) {
        _durationLabel.text = [NSString stringWithFormat:@" %@ ", item.duration];
    } else {
        _durationLabel.hidden = YES;
    }
    _viewsLabel.text = [NSString stringWithFormat:@"%@ views", [item.playnum convertNumber]];
    _timeLabel.text = item.lasttime;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:item.imgurl]];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:item.avatarImgUrl]];
    
}
@end
