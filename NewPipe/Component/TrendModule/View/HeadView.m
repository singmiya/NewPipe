//
//  HeadView.m
//  NewPipe
//
//  Created by Somiya on 2018/11/1.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "HeadView.h"
#import "VideoInfo.h"
#import "UIImageView+WebCache.h"
#import "NSString+Util.h"

@interface HeadView()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *viewCountLabel;
@property (strong, nonatomic) UIImageView *imgView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (strong, nonatomic) UILabel *likeLabel;
@property (strong, nonatomic) UILabel *dislikeLabel;
@property (nonatomic, strong) UILabel *sectionLabel;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *bgPlayBtn;
@end

@implementation HeadView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.viewCountLabel];
        [self addSubview:self.likeLabel];
        [self addSubview:self.imgView];
        [self addSubview:self.authorLabel];
        [self addSubview:self.dislikeLabel];
        [self addSubview:self.sectionLabel];
        [self addSubview:self.addBtn];
        [self addSubview:self.bgPlayBtn];
        [self updateFrames];
    }
    return self;
}

- (void)configData:(VideoInfo *)info {
    self.titleLabel.text = info.title;
    self.viewCountLabel.text = info.viewCount;
    self.authorLabel.text = info.author;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:info.avatarImgUrl]];
    self.likeLabel.text = [info.likeNums convertNumber];
    self.likeLabel.attributedText = [self getAttributedString:self.likeLabel.text withImg:@"like"];
    self.dislikeLabel.text = [info.dislikeNums convertNumber];
    self.dislikeLabel.attributedText = [self getAttributedString:self.dislikeLabel.text withImg:@"dislike"];
    self.sectionLabel.text = @"即将播放";
    [self.addBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [_addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [self setButtonImageAndTitleWithSpace:5 WithButton:self.addBtn];
    
    [self.bgPlayBtn setTitle:@"后台播放" forState:UIControlStateNormal];
    [_bgPlayBtn setImage:[UIImage imageNamed:@"ej"] forState:UIControlStateNormal];
    [self setButtonImageAndTitleWithSpace:5 WithButton:self.bgPlayBtn];
    [self updateFrames];
}

- (void)updateFrames {
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat h = [self heightForString:self.titleLabel.text font:self.titleLabel.font andWidth:w];
    CGRect frame = (CGRect){{5, 15}, {w - 10, h}};
    self.titleLabel.frame = frame;

    CGFloat x = 10;
    CGFloat y = CGRectGetMaxY(frame);
    w = 50;
    frame = CGRectMake(x, y + 5, w, w);
    self.imgView.frame = frame;
    
    x = CGRectGetMaxX(frame) + 10;
    y = CGRectGetMinY(frame) + 15;
    w = 100;
    frame = CGRectMake(x, y, w, 25);
    self.authorLabel.frame = frame;
    
    w = 200;
    x = CGRectGetWidth(self.frame) - w - 10;
    y = CGRectGetMaxY(self.titleLabel.frame);
    frame = CGRectMake(x, y + 5, w, 20);
    self.viewCountLabel.frame = frame;

    x = CGRectGetWidth(self.frame) - w - 10;
    y = CGRectGetMaxY(frame) + 10;
    w = w / 2;
    frame = CGRectMake(x, y, w, 20);
    self.likeLabel.frame = frame;
    
    x = CGRectGetMaxX(self.likeLabel.frame) + 5;
    frame = CGRectMake(x, y, w, 20);
    self.dislikeLabel.frame = frame;
    
    x = CGRectGetWidth(self.frame) / 4;
    y = CGRectGetMaxY(self.dislikeLabel.frame) + 20;
    w = x;
    frame = CGRectMake(x, y, w, 30);
    self.addBtn.frame = frame;
    
    x = 2 * x;
    frame = CGRectMake(x, y, w, 30);
    self.bgPlayBtn.frame = frame;

    x = 10;
    y = CGRectGetMaxY(self.bgPlayBtn.frame) + 20;
    w = CGRectGetWidth(self.frame) - 10;
    frame = CGRectMake(x, y, w, 25);
    self.sectionLabel.frame = frame;

    frame = CGRectMake(0, 0, self.frame.size.width, CGRectGetMaxY(self.sectionLabel.frame) + 5);
    self.frame = frame;
}
- (void)addBtnDidClick:(id)sender {
    if (self.addBtnCallBack) {
        self.addBtnCallBack();
    }
}
- (void)bgPlayBtnDidClick:(id)sender {
    if (self.bgPlayBtnCallBack) {
        self.bgPlayBtnCallBack();
    }
}

#pragma mark- init subviews
- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.textColor = [UIColor whiteColor];
        _authorLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    }
    return _authorLabel;
}
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 25;
    }
    return _imgView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)viewCountLabel {
    if (!_viewCountLabel) {
        _viewCountLabel = [[UILabel alloc] init];
        _viewCountLabel.textColor = [UIColor whiteColor];
        _viewCountLabel.font = [UIFont systemFontOfSize:14];
        _viewCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _viewCountLabel;
}

- (UILabel *)likeLabel {
    if (!_likeLabel) {
        _likeLabel = [[UILabel alloc] init];
        _likeLabel.textColor = [UIColor whiteColor];
        _likeLabel.font = [UIFont systemFontOfSize:14];
        _likeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _likeLabel;
}

- (UILabel *)dislikeLabel {
    if (!_dislikeLabel) {
        _dislikeLabel = [[UILabel alloc] init];
        _dislikeLabel.textColor = [UIColor whiteColor];
        _dislikeLabel.font = [UIFont systemFontOfSize:14];
        _dislikeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _dislikeLabel;
}

- (UILabel *)sectionLabel {
    if (!_sectionLabel) {
        _sectionLabel = [[UILabel alloc] init];
        _sectionLabel.textColor = [UIColor lightGrayColor];
        _sectionLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    }
    return _sectionLabel;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] init];
        [_addBtn setTintColor:[UIColor whiteColor]];
        [_addBtn addTarget:self action:@selector(addBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UIButton *)bgPlayBtn {
    if (!_bgPlayBtn) {
        _bgPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgPlayBtn setTintColor:[UIColor whiteColor]];
        [_bgPlayBtn addTarget:self action:@selector(bgPlayBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgPlayBtn;
}

/**
 * 获得字符串的高度
 * @param value
 * @param font
 * @param width
 * @return
 */
- (float) heightForString:(NSString *)value font:(UIFont *)font andWidth:(float)width {
    if (value == nil) {
        return 0;
    }
    // 段落设置与实际显示的 Label 属性一致 采用 NSMutableParagraphStyle 设置Nib 中 Label 的相关属性传入到 NSAttributeString 中计算；
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;

    NSAttributedString *string = [[NSAttributedString alloc]initWithString:value attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style}];

    CGSize sizeToFit =  [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    NSLog(@" size =  %@", NSStringFromCGSize(sizeToFit));

    return sizeToFit.height;
}

/**
 * 获取字符串的长度
 * @param value
 * @param font
 * @param height
 * @return
 */
- (float)widthForStrng:(NSString *)value font:(UIFont *)font andHeight:(float)height {
    // 段落设置与实际显示的 Label 属性一致 采用 NSMutableParagraphStyle 设置Nib 中 Label 的相关属性传入到 NSAttributeString 中计算；
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;

    NSAttributedString *string = [[NSAttributedString alloc]initWithString:value attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style}];

    CGSize sizeToFit =  [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    NSLog(@" size =  %@", NSStringFromCGSize(sizeToFit));

    return sizeToFit.width;
}


- (NSMutableAttributedString *)getAttributedString:(NSString *)text withImg:(NSString *)img {
    if (!text) {
        text = @"0";
    }
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:text];
    /**
     添加图片到指定的位置
     */
    NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
    // 表情图片
    attchImage.image = [UIImage imageNamed:img];
    // 设置图片大小
    attchImage.bounds = CGRectMake(0, -5, 20, 20);
    NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
    [attriStr insertAttributedString:stringImage atIndex:0];
    return attriStr;
}
- (void)setButtonImageAndTitleWithSpace:(CGFloat)spacing WithButton:(UIButton *)btn{
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}
@end
