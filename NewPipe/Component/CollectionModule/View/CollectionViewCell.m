//
//  CollectionViewCell.m
//  NewPipe
//
//  Created by Somiya on 2018/12/11.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "CollectionViewCell.h"
#import "CollectionItem+CoreDataClass.h"
#import "UIImageView+WebCache.h"
#import "NSString+Util.h"

@interface CollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end
@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.durationLabel.layer.cornerRadius = 3;
//    self.durationLabel.layer.masksToBounds = YES;
    self.durationLabel.hidden = YES;
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius = 20;
    // Initialization code
//    self.imgView.layer.borderColor = [UIColor redColor].CGColor;
//    self.imgView.layer.borderWidth = 1;
//    self.titleLabel.layer.borderColor = [UIColor greenColor].CGColor;
//    self.titleLabel.layer.borderWidth = 1;
//    self.descriptionLabel.layer.borderColor = [UIColor yellowColor].CGColor;
//    self.descriptionLabel.layer.borderWidth = 1;

}
- (void)configCellData:(id)data title:(NSString *)title {
    if ([data isKindOfClass:[CollectionItem class]]) {
        CollectionItem *item =(CollectionItem *)data;
        _titleLabel.text = title;
        _nameLabel.text = item.author;
        //    if (item.duration != nil) {
        //        _durationLabel.text = [NSString stringWithFormat:@" %@ ", item.duration];
        //    } else {
        //        _durationLabel.hidden = YES;
        //    }
        _viewsLabel.text = [NSString stringWithFormat:@"%@ %@", [item.playnum convertNumber], NSLocalizedString(@"views", nil)];
        _timeLabel.text = item.lasttime;
        [_imgView sd_setImageWithURL:[NSURL URLWithString:item.imgurl] placeholderImage:[UIImage imageNamed:@"default"]];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:item.avatarImgUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    } else {
        NSDictionary *dic = data;
        _titleLabel.text = dic[@"name"];
        _nameLabel.text = dic[@"uploader"];
        //    if (item.duration != nil) {
        //        _durationLabel.text = [NSString stringWithFormat:@" %@ ", item.duration];
        //    } else {
        //        _durationLabel.hidden = YES;
        //    }
        _viewsLabel.text = [NSString stringWithFormat:@"%@ %@", dic[@"playnum"], NSLocalizedString(@"views", nil)];
//        _timeLabel.text = item.lasttime;
        [_imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"thumbnailUrl"]] placeholderImage:[UIImage imageNamed:@"default"]];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:dic[@"avatarImgUrl"]] placeholderImage:[UIImage imageNamed:@"default"]];
    }
}
@end
