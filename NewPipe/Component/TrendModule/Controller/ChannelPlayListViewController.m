//
//  ChannelPlayListViewController.m
//  NewPipe
//
//  Created by Somiya on 2019/3/20.
//  Copyright © 2019 Somiya. All rights reserved.
//

#import "ChannelPlayListViewController.h"
#import "SVProgressHUD.h"
#import "SVProgressHUD+Util.h"
#import "Constant.h"
#import "ColorUtil.h"
#import "PlayListTableViewCell.h"
#import "PlayViewController.h"
#import "PlayListItem.h"
#import "PlayItem.h"

static NSString *PlayListTableViewCellIdentifier = @"PlayListTableViewCellIdentifier";
@interface ChannelPlayListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation ChannelPlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [SVProgressHUD themeConfigContainerView:self.view];
    [self loadData];
}
- (void)loadData {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading", nil)];
    @weakify(self)
    [PlayListItem getPlayListItem:^(NSArray *items) {
        @strongify(self)
        self.dataSource = items;
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新界面
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        });
    } withUrl:self.url];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = UICOLOR_HEX(0xE54D42);
}
//----- init table view
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.bounds) - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        UINib *nib = [UINib nibWithNibName:@"PlayListTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:PlayListTableViewCellIdentifier];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = UICOLOR_HEX(0x404040);
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
    PlayListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlayListTableViewCellIdentifier];
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
    PlayListItem *item = self.dataSource[indexPath.row];
    
    PlayViewController *playVC = [[PlayViewController alloc] init];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading", nil)];
    [PlayItem getChannelPlayList:^(NSArray *pList) {
        if (pList.count <= 0) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"NilVideos", nil)];
            return;
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            playVC.item = pList[0];
            playVC.dataSource = (NSMutableArray *)pList;
            [self.navigationController pushViewController:playVC animated:YES];
            [SVProgressHUD dismiss];
        });
    } withWatchUrl:item.wsrc];
//    [playVC setHidesBottomBarWhenPushed:YES];
    
}

@end
