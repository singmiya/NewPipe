//
//  NSString+Util.m
//  NewPipe
//
//  Created by Somiya on 2018/11/3.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "NSString+Util.h"

@interface NSString (Util)

@end
@implementation NSString (Util)
- (NSString *)convertNumber {
    NSArray *nums = [self componentsSeparatedByString:@","];
    if (nums.count == 2) {
        return [NSString stringWithFormat:@"%@K", nums[0]];
    }
    if (nums.count == 3) {
        return [NSString stringWithFormat:@"%@M", nums[0]];
    }
    if (nums.count == 4) {
        return [NSString stringWithFormat:@"%@Bil", nums[0]];
    }
    return [NSString stringWithFormat:@"%@", self];
}

const static float BIL = 1000000000.0;
const static long MAX_M = 999999999;
const static float M = 1000000.0;
const static long MAX_K = 999999;
const static float K = 1000.0;
const static long MAX_H = 999;
+ (NSString *)convertNumberToStr:(long)num {
    if (num > MAX_M) {
        return [NSString stringWithFormat:@"%.1fBil", num / BIL];
    }
    if (num > MAX_K) {
        return [NSString stringWithFormat:@"%.1fM", num / M];
    }
    if (num > MAX_H) {
        return [NSString stringWithFormat:@"%.1fK", num / K];
    }
    return [NSString stringWithFormat:@"%ld", num];
}

/**
 * 获得字符串的高度
 * @param font
 * @param width
 * @return
 */
- (float)stringHeightWithFont:(UIFont *)font andWidth:(float)width {
    if (self == nil) {
        return 0;
    }
    // 段落设置与实际显示的 Label 属性一致 采用 NSMutableParagraphStyle 设置Nib 中 Label 的相关属性传入到 NSAttributeString 中计算；
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:self attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style}];
    
    CGSize sizeToFit =  [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    NSLog(@" size =  %@", NSStringFromCGSize(sizeToFit));
    
    return sizeToFit.height;
}

/**
 * 获取字符串的长度
 * @param font
 * @param height
 * @return
 */
- (float)stringWidthWithFont:(UIFont *)font andHeight:(float)height {
    // 段落设置与实际显示的 Label 属性一致 采用 NSMutableParagraphStyle 设置Nib 中 Label 的相关属性传入到 NSAttributeString 中计算；
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:self attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style}];
    
    CGSize sizeToFit =  [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    NSLog(@" size =  %@", NSStringFromCGSize(sizeToFit));
    
    return sizeToFit.width;
}

- (NSMutableAttributedString *)attributedStringWithImg:(NSString *)img {
    NSString *text = self;
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

@end
