//
//  NSString+Util.h
//  NewPipe
//
//  Created by Somiya on 2018/11/3.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Util)
- (NSString *)convertNumber;
+ (NSString *)convertNumberToStr:(NSInteger)num;
/**
 * 获得字符串的高度
 * @param font
 * @param width
 * @return
 */
- (float) stringHeightWithFont:(UIFont *)font andWidth:(float)width;

/**
 * 获取字符串的长度
 * @param font
 * @param height
 * @return
 */
- (float)stringWidthWithFont:(UIFont *)font andHeight:(float)height;

/**
 * 在文字前面添加图片
 *
 */
- (NSMutableAttributedString *)attributedStringWithImg:(NSString *)img;
@end
