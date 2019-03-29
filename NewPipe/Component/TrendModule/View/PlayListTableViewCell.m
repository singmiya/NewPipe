//
//  PlayListTableViewCell.m
//  NewPipe
//
//  Created by Somiya on 2019/3/20.
//  Copyright © 2019 Somiya. All rights reserved.
//

#import "PlayListTableViewCell.h"
#import "PlayListItem.h"
#import "NSString+Util.h"
#import "UIImageView+WebCache.h"

@interface PlayListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
@implementation PlayListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configCellData:(id)data {
    PlayListItem *item = (PlayListItem *)data;
    _titleLabel.text = item.title;
    _countLabel.text = [item.count convertNumber];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:item.imgUrl] placeholderImage:[UIImage imageNamed:@"default"]];
}
@end
