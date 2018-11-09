//
//  SVProgressHUD+Util.m
//  NewPipe
//
//  Created by Somiya on 2018/11/3.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "SVProgressHUD+Util.h"
#import "ColorUtil.h"

@implementation SVProgressHUD (Util)
+ (void)themeConfigContainerView:(UIView *)view {
    [SVProgressHUD setForegroundColor:UICOLOR_HEX(0xE54D42)];
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD setContainerView:view];
    [SVProgressHUD setRingThickness:6];
}
@end
