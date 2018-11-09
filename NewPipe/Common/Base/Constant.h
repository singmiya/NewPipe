//
//  Constant.h
//  NewPipe
//
//  Created by Somiya on 2018/11/9.
//  Copyright © 2018 Somiya. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
//注意：请直接获取系统的tabbar高度，若没有用系统tabbar，建议判断屏幕高度；之前判断  状态栏高度的方法不妥，如果正在通话状态栏会变高，导致判断异常，下面只是一个例子，请勿直接使用！
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
#endif /* Constant_h */
