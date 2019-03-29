//
//  ChannelTableViewCell.m
//  NewPipe
//
//  Created by Somiya on 2019/3/20.
//  Copyright © 2019 Somiya. All rights reserved.
//

#import "ChannelTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+Util.h"

@interface ChannelTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subscriptionLabel;

@end
@implementation ChannelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellData:(id)data {
    NSDictionary *dic = (NSDictionary *)data;
    _titleLabel.text = dic[@"name"];
    long count = [(NSNumber *)dic[@"subscriberCount"] longValue];
    _subscriptionLabel.text = [NSString stringWithFormat:@"%@ %@", [NSString convertNumberToStr:count], NSLocalizedString(@"subscriptions", nil)];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"avatarUrl"]] placeholderImage:[UIImage imageNamed:@"default"]];
}

@end
