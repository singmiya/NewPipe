//
//  RecommendViewController.m
//  NewPipe
//
//  Created by Somiya on 2018/10/15.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "RecommendViewController.h"
#import "SVProgressHUD+Util.h"
#import "SVProgressHUD.h"
#import "ColorUtil.h"
#import "RecommendCollectionViewCell.h"
#import "RecommendItem.h"
#import "Constant.h"
#import "RecommendListViewController.h"
#import "MJRefresh.h"
#import "NetWorkConstants.h"
#import "MainTabController.h"
#import "ZJDrawerController.h"
#import "NSString+Util.h"

static NSString *const cellId = @"cellId";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

@interface RecommendViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, copy) NSDictionary *pageInfo;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD themeConfigContainerView:self.view];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    [self loadData];
}

- (void)loadData {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading", nil)];
    if (self.url == nil) {
        self.url = [NSString stringWithFormat:@"%@%@", BASE_URL, RECOMMEND_LIST];
    }
    @weakify(self)
    [RecommendItem getRecommendItemList:^(NSArray *playList, NSDictionary *pageInfo) {
        @strongify(self)
        self.dataSource = playList;
        self.pageInfo = pageInfo;
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
    } url:self.url];
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
        
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
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
//----- init collection view
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
        // 设置最小行间距
        layout.minimumLineSpacing = 1;
        // 设置最小垂直间距
        layout.minimumInteritemSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.bounds) - 49) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        UINib *nib = [UINib nibWithNibName:@"RecommendCollectionViewCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:cellId];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadData];
        }];
    }
    return _collectionView;
}

#pragma mark -
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.dataSource) {
        return self.dataSource.count;
    }
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    [cell configCellData:self.dataSource[indexPath.section]];
    return cell;
}

//// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor grayColor];
        return headerView;
    } else if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
        footerView.backgroundColor = UICOLOR_HEX(0x404040);
        return footerView;
    }

    return nil;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
#pragma mark -
#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.pageInfo) {
//        NSInteger columns = [self.pageInfo[@"columns"] integerValue];
//        CGFloat width = (CGRectGetWidth(self.view.frame) - 10) / columns;
//        CGFloat height = (width * 3 / 4) / columns;
//        return (CGSize){width, height + 130};
//    }
    RecommendItem *item = self.dataSource[indexPath.section];
    float h = [item.title stringHeightWithFont:[UIFont systemFontOfSize:15] andWidth:CGRectGetWidth(self.view.frame)];
    return (CGSize){CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame) * 3 / 4 + h};
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return (CGSize){0,1};
}

#pragma mark ---- UICollectionViewDelegate
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RecommendListViewController *rlVc = [[RecommendListViewController alloc] init];
    RecommendItem *item = self.dataSource[indexPath.section];
    rlVc.childPath = item.childPath;
    [self.navigationController pushViewController:rlVc animated:YES];
}
@end
