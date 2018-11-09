//
//  VideoItemTableViewCell.m
//  NewPipe
//
//  Created by Somiya on 2018/10/14.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "VideoItemTableViewCell.h"
#import "PlayItem.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "ColorUtil.h"
#import "NSString+Util.h"

@interface VideoItemTableViewCell()
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *channelLabel;
@property (nonatomic, strong) UILabel *viewsNumLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *durationLabel;

@end
@implementation VideoItemTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.videoImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.channelLabel];
        [self.contentView addSubview:self.viewsNumLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.videoImageView addSubview:self.durationLabel];
    }
    return self;
}
// tell UIKit that you are using AutoLayout
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [self.videoImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(2/5.0);
        make.height.mas_equalTo(self.videoImageView.mas_width).multipliedBy(0.75);
    }];
    
    [self.durationLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.durationLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.videoImageView.mas_right).mas_offset(-15);
        make.bottom.equalTo(self.videoImageView.mas_bottom).mas_offset(-10);
        make.height.mas_equalTo(20);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.videoImageView.mas_right);
        make.top.right.equalTo(self.contentView);
//        make.bottom.equalTo(self.channelLabel).insets(UIEdgeInsetsMake(0, 0, 2, 0));
        make.height.equalTo(@50);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(3/5.0);
    }];

    [self.channelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoImageView.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 20, 0));
        make.width.equalTo(self.titleLabel.mas_width);
    }];
    [self.viewsNumLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.videoImageView.mas_right).offset(10);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.right.equalTo(self.timeLabel.mas_left);
        make.height.equalTo(@20);
        make.width.equalTo(self.titleLabel.mas_width).multipliedBy(1/2.0);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.bottom.equalTo(self.contentView).offset(-5);
        make.height.equalTo(@20);
        make.width.equalTo(self.titleLabel.mas_width).multipliedBy(1/2.0);
    }];

    [super updateConstraints];
}

//----- init subviews
- (UIImageView *)videoImageView {
    if(!_videoImageView) {
        _videoImageView = [[UIImageView alloc] init];
    }
    return _videoImageView;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:50];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)channelLabel {
    if (!_channelLabel) {
        _channelLabel = [[UILabel alloc] init];
        _channelLabel.textColor = UICOLOR_HEX(0xCECED2);
        _channelLabel.font = [UIFont systemFontOfSize:14 weight:1];
    }
    return _channelLabel;
}

- (UILabel *)viewsNumLabel {
    if(!_viewsNumLabel) {
        _viewsNumLabel = [[UILabel alloc] init];
        _viewsNumLabel.textColor = UICOLOR_HEX(0xCECED2);
        _viewsNumLabel.font = [UIFont systemFontOfSize:14 weight:1];
    }
    return _viewsNumLabel;
}

- (UILabel *)timeLabel {
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UICOLOR_HEX(0xCECED2);
        _timeLabel.font = [UIFont systemFontOfSize:14 weight:1];
    }
    return _timeLabel;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.backgroundColor = UICOLOR_HEX(0xCECED2);
        _durationLabel.layer.cornerRadius = 3;
        _durationLabel.layer.masksToBounds = YES;
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.font = [UIFont systemFontOfSize:14];
    }
    return _durationLabel;
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
    _viewsNumLabel.text = [NSString stringWithFormat:@"%@ views", [item.playnum convertNumber]];
    _timeLabel.text = item.lasttime;
    [_videoImageView sd_setImageWithURL:[NSURL URLWithString:item.imgurl]];
    
}

@end
