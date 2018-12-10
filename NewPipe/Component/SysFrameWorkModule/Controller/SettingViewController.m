//
//  SettingViewController.m
//  NewPipe
//
//  Created by Somiya on 2018/11/18.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "SettingViewController.h"
#import "ZJDrawerController.h"
#import "DataSourceManager.h"
#import "NetWorkConstants.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *section1Data;
@property (nonatomic, copy) NSArray *section2Data;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.section2Data = @[@{@"title":NSLocalizedString(@"AboutUS", nil)}, @{@"title":NSLocalizedString(@"Like", nil)}, @{@"title":NSLocalizedString(@"Privacy", nil)}];
    self.section1Data = [NSMutableArray array];
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, @"Category.json"];
    [[DataSourceManager sharedInstance] get:url params:nil success:^(id response) {
        NSDictionary *dic = response;
        [self.section1Data addObjectsFromArray:[dic.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
        [self.tableView reloadData];
    } failure:^(id response) {
        
    }];
}
#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section1Data.count;
    }
    return self.section2Data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const kCellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = self.section1Data[indexPath.row];
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = self.section2Data[indexPath.row][@"title"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}
#pragma mark -
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:NSLocalizedString(@"Warring", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击确认");
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Warring", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击警告");
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
//    [self.zj_drawerController setupNewCenterViewController:new closeDrawer:NO finishHandler:^(BOOL finished) {
//        NSLog(@"切换完成");
//    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44.0f;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.bounces = NO;
    }
    return _tableView;
}
- (void)viewWillLayoutSubviews {
    CGRect frame = CGRectMake(0.0f, 200.0f, self.view.bounds.size.width, self.view.bounds.size.height - 200.0f);
    
    self.tableView.frame = frame;
}

@end
