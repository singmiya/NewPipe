//
//  BaseTabController.h
//  NewPipe
//
//  Created by Somiya on 2018/10/15.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabController : UITabBarController
- (void)setTabBarItem:(UITabBarItem *)tabBarItem title:(NSString *)title titleSize:(CGFloat)titleSize titleFontName:(NSString *)titleFontName selectedImage:(NSString *)selectedImage selectedTitleColor:(UIColor *)selectedTitleColor normalImage:(NSString *)mormalImage normalTitleColor:(UIColor *)normalTitleColor;
@end
