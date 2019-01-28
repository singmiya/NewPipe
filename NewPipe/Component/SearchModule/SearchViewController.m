//
//  SearchViewController.m
//  NewPipe
//
//  Created by Somiya on 2018/11/7.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "SearchViewController.h"
#import "PlayItem.h"
#import "SVProgressHUD+Util.h"
#import "SVProgressHUD.h"
#import "ColorUtil.h"
#import "PlayViewController.h"
#import "TrendingTableViewCell.h"
#import "Constant.h"
#import "MJRefresh.h"

static NSString *TrendingTableViewCellIdentifier = @"TrendingTableViewCellIdentifier";
@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, copy) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [SVProgressHUD themeConfigContainerView:self.view];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.definesPresentationContext = YES;
    _currentPage = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.searchController.searchBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.searchController.searchBar.hidden = YES;
}

- (void)loadData {
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading", nil)];
    [PlayItem getSearchResult:^(NSArray *retList) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.dataSource addObjectsFromArray:retList];
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新界面
            [strongSelf.tableView reloadData];
            [SVProgressHUD dismiss];
            [strongSelf.tableView.mj_footer endRefreshing];
            
        });
    } searchString:self.searchController.searchBar.text page:_currentPage];
}
//----- init search vc
- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.delegate = self;
        _searchController.delegate = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, 0, self.searchController.searchBar.frame.size.width, 64.0);
        _searchController.searchBar.barStyle = UISearchBarStyleMinimal;
        _searchController.obscuresBackgroundDuringPresentation = NO;
        _searchController.searchBar.barTintColor = [UIColor blackColor];
        _searchController.searchBar.tintColor = UICOLOR_HEX(0xE54D42);
        _searchController.searchBar.placeholder = NSLocalizedString(@"KeyWords", nil);
        [_searchController.searchBar positionAdjustmentForSearchBarIcon:UISearchBarIconSearch];
        [self setSearchBarTheme:_searchController.searchBar];
    }
    return _searchController;
}
- (void)setSearchBarTheme:(UISearchBar *)searchBar {
    UIView *searchTextField = [[[searchBar.subviews firstObject] subviews] lastObject];
    for (UIView *view in searchTextField.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UISearchBarSearchFieldBackgroundView")]) {
            view.layer.borderColor = UICOLOR_HEX(0xE54D42).CGColor;
            view.layer.borderWidth = 1;
            view.layer.cornerRadius = 5.0;
        }
//        } else if ([view isKindOfClass:NSClassFromString(@"UISearchBarTextFieldLabel")]) {
////            (UILabel *)view
//        } else {
//
//        }
    }
    
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.textColor = UICOLOR_HEX(0xE54D42);
}

//----- init table view
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor blackColor];
        _tableView.backgroundView = view;
        _tableView.backgroundColor = [UIColor blackColor];
        UINib *nib = [UINib nibWithNibName:@"TrendingTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:TrendingTableViewCellIdentifier];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = UICOLOR_HEX(0x404040);
        _tableView.tableHeaderView = self.searchController.searchBar;
        
        // 上拉刷新
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            NSString *searchStr = self.searchController.searchBar.text;
            if (searchStr != nil && ![searchStr isEqualToString:@""]) {
                self.currentPage ++;
                [self loadData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        }];
    }
    return _tableView;
}
//----- init data
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrendingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TrendingTableViewCellIdentifier];
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
    PlayViewController *playVC = [[PlayViewController alloc] init];
    playVC.item = self.dataSource[indexPath.row];
    [playVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:playVC animated:YES];
}

#pragma mark -
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {

}

#pragma mark -
- (void)didPresentSearchController:(UISearchController *)searchController {

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.dataSource removeAllObjects];
    _currentPage = 1;
    [self loadData];
}

@end
