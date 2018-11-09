//
//  BaseViewController.m
//  NewPipe
//
//  Created by Somiya on 2018/10/14.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "BaseViewController.h"
#import "Constant.h"

@interface BaseViewController ()
@property (nonatomic, strong) UIView *statusBar;

@end

@implementation BaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view addSubview:self.statusBar];
}

- (UIView *)statusBar {
    if(!_statusBar) {
        _statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kStatusBarHeight)];
        _statusBar.backgroundColor = [UIColor blackColor];
    }
    return _statusBar;
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
