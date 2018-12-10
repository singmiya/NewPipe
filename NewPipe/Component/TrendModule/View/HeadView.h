//
//  HeadView.h
//  NewPipe
//
//  Created by Somiya on 2018/11/1.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoInfo;
typedef void(^CallBack)(void);

@interface HeadView : UIView
@property (nonatomic, copy) CallBack praiseBtnCallBack;
@property (nonatomic, copy) CallBack addBtnCallBack;

- (void)configData:(VideoInfo *)info;
@end
