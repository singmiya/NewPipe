//
//  MainTabController.m
//  NewPipe
//
//  Created by Somiya on 2018/10/15.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "MainTabController.h"
#import "TrendViewController.h"
#import "RecommendViewController.h"
#import "CollectionViewController.h"
#import "SearchViewController.h"
#import "ColorUtil.h"

@interface MainTabController ()

@end

@implementation MainTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RecommendViewController *recommendVC = [[RecommendViewController alloc] init];
    UINavigationController *recommendNavi = [[UINavigationController alloc] initWithRootViewController:recommendVC];
    [self setTabBarItem:recommendNavi.tabBarItem title:NSLocalizedString(@"Recommended", nil) titleSize:12.0 titleFontName:@"HeiTi SC" selectedImage:@"selected_recommend" selectedTitleColor:UICOLOR_HEX(0xE54D42) normalImage:@"normal_recommend" normalTitleColor:UICOLOR_HEX(0x979797)];
    TrendViewController *trendVC = [[TrendViewController alloc] init];
    [self setTabBarItem:trendVC.tabBarItem title:NSLocalizedString(@"Trending", nil) titleSize:12.0 titleFontName:@"HeiTi SC" selectedImage:@"selected_trending" selectedTitleColor:UICOLOR_HEX(0xE54D42) normalImage:@"normal_trending" normalTitleColor:UICOLOR_HEX(0x979797)];
    CollectionViewController *collectionVC = [[CollectionViewController alloc] init];
    UINavigationController *collectionNavi = [[UINavigationController alloc] initWithRootViewController:collectionVC];
    [self setTabBarItem:collectionNavi.tabBarItem title:NSLocalizedString(@"Collection", nil) titleSize:12.0 titleFontName:@"HeiTi SC" selectedImage:@"selected_recommend" selectedTitleColor:UICOLOR_HEX(0xE54D42) normalImage:@"normal_recommend" normalTitleColor:UICOLOR_HEX(0x979797)];
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self setTabBarItem:searchVC.tabBarItem title:NSLocalizedString(@"Searching", nil) titleSize:12.0 titleFontName:@"HeiTi SC" selectedImage:@"selected_search" selectedTitleColor:UICOLOR_HEX(0xE54D42) normalImage:@"normal_search" normalTitleColor:UICOLOR_HEX(0x979797)];
    self.viewControllers = @[recommendNavi, trendVC, collectionNavi, searchVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
