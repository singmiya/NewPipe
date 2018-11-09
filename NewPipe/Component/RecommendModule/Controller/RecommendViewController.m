//
//  RecommendViewController.m
//  NewPipe
//
//  Created by Somiya on 2018/10/15.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "RecommendViewController.h"
#import "PlayItem.h"
#import "RecommendTableViewCell.h"
#import "PlayViewController.h"
#import "SVProgressHUD.h"
#import "SVProgressHUD+Util.h"
#import "ColorUtil.h"
#import "Constant.h"
#import "MJRefresh.h"

static NSString *RecommendTableViewCellIdentifier = @"RecommendTableViewCellIdentifier";
@interface RecommendViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD themeConfigContainerView:self.view];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self loadData];
}

- (void)loadData {
    __weak __typeof(self) weakSelf = self;
    [PlayItem getRecommendPlayItemList:^(NSArray * _Nonnull playList) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.dataSource = playList;
        [strongSelf.tableView reloadData];
        [strongSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----- init table view
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.bounds) - kStatusBarHeight - 49) style:UITableViewStylePlain];
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
    playVC.item = self.dataSource[indexPath.row];
    [self presentViewController:playVC animated:YES completion:nil];
}
@end
