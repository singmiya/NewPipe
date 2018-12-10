//
//  AppDelegate.h
//  NewPipe
//
//  Created by Somiya on 2018/10/14.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJDrawerController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ZJDrawerController *drawer;
@end

