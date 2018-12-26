//
//  RecommendListViewController.m
//  NewPipe
//
//  Created by Somiya on 2018/12/13.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "RecommendListViewController.h"
#import "RecommendItem.h"
#import "RecommendTableViewCell.h"
#import "PlayViewController.h"
#import "SVProgressHUD.h"
#import "SVProgressHUD+Util.h"
#import "ColorUtil.h"
#import "Constant.h"
#import "MJRefresh.h"
#import "PlayItem.h"
#import "NetWorkConstants.h"
#import "MainTabController.h"
#import "ZJDrawerController.h"

static NSString *RecommendTableViewCellIdentifier = @"RecommendTableViewCellIdentifier";
@interface RecommendListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, copy) NSDictionary *pageInfo;
@end

@implementation RecommendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD themeConfigContainerView:self.view];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self loadData];
}

- (void)loadData {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading", nil)];
    if (self.url == nil) {
        self.url = [NSString stringWithFormat:@"%@%@%@YoutubeFeed.json", BASE_URL, PREFIX_URL, self.childPath];
    }
    @weakify(self)
    [RecommendItem getRecommendItemList:^(NSArray *playList, NSDictionary *pageInfo) {
        @strongify(self)
        self.dataSource = playList;
        self.pageInfo = pageInfo;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
    } url:[self.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.type == 1) {
        UIButton *butn = [UIButton buttonWithType:UIButtonTypeCustom];
        butn.frame = CGRectMake(0, 0, 40, 40);
        [butn setBackgroundImage:[UIImage imageNamed:@"close_rr"] forState:UIControlStateNormal];
        [butn addTarget:self action:@selector(backButnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:butn];
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.tintColor = UICOLOR_HEX(0xE54D42);
        
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = UICOLOR_HEX(0xE54D42);
}

- (void)backButnClick:(id)sender {
    MainTabController *mainTab = [[MainTabController alloc] init];
    [self.zj_drawerController setupNewCenterViewController:mainTab closeDrawer:NO finishHandler:^(BOOL finished) {
    }];
    [self.zj_drawerController openLeftDrawerAnimated:YES finishHandler:^(BOOL finished) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----- init table view
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.bounds) - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        UINib *nib = [UINib nibWithNibName:@"RecommendTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:RecommendTableViewCellIdentifier];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = UICOLOR_HEX(0x404040);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadData];
        }];
    }
    return _tableView;
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecommendTableViewCellIdentifier];
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
    PlayViewController *playVC = [PlayViewController new];
    PlayItem *item = [PlayItem new];
    RecommendItem *rItem = (RecommendItem *) self.dataSource[indexPath.row];
    item.vid = rItem.vid;
    item.imgurl = IMAGE_URL(rItem.vid);
    item.title = rItem.title;
    playVC.item = item;
    [self presentViewController:playVC animated:YES completion:nil];
}

@end
