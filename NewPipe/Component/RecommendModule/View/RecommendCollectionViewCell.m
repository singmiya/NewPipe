//
//  RecommendCollectionViewCell.m
//  NewPipe
//
//  Created by Somiya on 2018/12/13.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "RecommendCollectionViewCell.h"
#import "RecommendItem.h"
#import "UIImageView+WebCache.h"
#import "NSString+Util.h"
#import "NetWorkConstants.h"

@interface RecommendCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dislikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@end
@implementation RecommendCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCellData:(id)data {
    RecommendItem *item = (RecommendItem *)data;
    _titleLabel.text = item.title;
    _descriptionLabel.text = item.idescription;
    _viewsLabel.text = [NSString convertNumberToStr:item.statistics.viewCount];
    _viewsLabel.attributedText = [_viewsLabel.text attributedStringWithImg:@"eye"];
    _likeLabel.text = [NSString convertNumberToStr:item.statistics.likeCount];
    _likeLabel.attributedText = [_likeLabel.text attributedStringWithImg:@"like"];
    _dislikeLabel.text = [NSString convertNumberToStr:item.statistics.dislikeCount];
    _dislikeLabel.attributedText = [_dislikeLabel.text attributedStringWithImg:@"dislike"];
    _commentLabel.text = [NSString convertNumberToStr:item.statistics.commentCount];
    _commentLabel.attributedText = [_commentLabel.text attributedStringWithImg:@"comment"];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:IMAGE_URL(item.iid)]];
}
@end
