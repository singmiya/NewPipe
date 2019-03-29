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
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@end

@implementation CollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//------ configuration cell data
- (void)configCellData:(id)data num:(NSInteger)num {
    if ([data isKindOfClass:[CollectionItem class]]) {
        CollectionItem *item =(CollectionItem *)data;
        _titleLabel.text = item.title;
        _authorLabel.text = item.author;
        [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:item.imgurl] placeholderImage:[UIImage imageNamed:@"default"]];
    } else {
        NSDictionary *dic = data;
        _titleLabel.text = dic[@"name"];
        _authorLabel.text = dic[@"uploader"];
        [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"thumbnailUrl"]] placeholderImage:[UIImage imageNamed:@"default"]];
    }
    _numLabel.text = [NSString stringWithFormat:@"%ld", num];
}

@end
