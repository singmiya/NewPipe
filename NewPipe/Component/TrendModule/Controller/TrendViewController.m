//
//  TrendViewController.m
//  NewPipe
//
//  Created by Somiya on 2018/10/14.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "TrendViewController.h"
#import "PlayItem.h"
#import "TrendingTableViewCell.h"
#import "PlayViewController.h"
#import "SVProgressHUD.h"
#import "SVProgressHUD+Util.h"
#import "ColorUtil.h"
#import "Constant.h"
#import "MJRefresh.h"
#import "DataSourceManager.h"
#import "NetWorkConstants.h"
#import "ChannelTableViewCell.h"
#import "ChannelPlayListViewController.h"
static NSString *TrendingTableViewCellIdentifier = @"TrendingTableViewCellIdentifier";
static NSString *ChannelTableViewCellIdentifier = @"ChannelTableViewCellIdentifier";
@interface TrendViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TrendViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [SVProgressHUD themeConfigContainerView:self.view];
    [self loadData];
}
- (void)loadData {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading", nil)];
//    [PlayItem getPlayItemList:^(NSArray * _Nonnull playList) {
//        __strong __typeof(weakSelf) strongSelf = weakSelf;
//        strongSelf.dataSource = playList;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //刷新界面
//            [strongSelf.tableView reloadData];
//            [SVProgressHUD dismiss];
//            [strongSelf.tableView.mj_header endRefreshing];
//        });
//    }];
    @weakify(self)
    self.dataSource = [NSMutableArray array];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", BASE_URL, PREFIX_URL, @"Category.json"];
    [[DataSourceManager sharedInstance] get:url params:nil success:^(id response) {
        @strongify(self)
        NSArray *arr = response[@"Subscription|"];
        if (arr.count > 0) {
            [self.dataSource addObjectsFromArray:arr];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新界面
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
        });
    } failure:^(id response) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
//----- init table view
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.bounds) - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        UINib *nib = [UINib nibWithNibName:@"ChannelTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:ChannelTableViewCellIdentifier];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = UICOLOR_HEX(0x404040);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadData];
        }];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChannelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChannelTableViewCellIdentifier];
    [cell configCellData:self.dataSource[indexPath.row]];
    return cell;
}
#pragma mark -
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChannelPlayListViewController *listVC = [[ChannelPlayListViewController alloc] init];
    listVC.url = self.dataSource[indexPath.row][@"url"];
//    [listVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:listVC animated:YES];
}
@end
