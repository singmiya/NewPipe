//
//  CollectionViewController.m
//  NewPipe
//
//  Created by Somiya on 2018/10/15.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "CollectionViewController.h"
#import "SVProgressHUD+Util.h"
#import "SVProgressHUD.h"
#import "ColorUtil.h"
#import "PlayViewController.h"
#import "SectionCollectionViewCell.h"
#import <MagicalRecord/MagicalRecord.h>
#import "PlayItem.h"
#import "CollectionItem+CoreDataClass.h"
#import "Constant.h"
#import "PlayListViewController.h"

static NSString *const cellId = @"cellId";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

@interface CollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSFetchedResultsController *fetchRetVC;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD themeConfigContainerView:self.view];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading", nil)];
     self.fetchRetVC = [CollectionItem MR_fetchAllGroupedBy:@"listName" withPredicate:nil sortedBy:@"updateTime" ascending:NO];

    [self.collectionView reloadData];
    [SVProgressHUD dismiss];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//----- init collection view
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.bounds) - kStatusBarHeight - 49) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        UINib *nib = [UINib nibWithNibName:@"SectionCollectionViewCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:cellId];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

#pragma mark -
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (!self.fetchRetVC || !self.fetchRetVC.sections) {
        return 0;
    }
    return self.fetchRetVC.sections.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    [cell configCellData:self.fetchRetVC.sections[indexPath.section].objects.firstObject title:self.fetchRetVC.sections[indexPath.section].name];
    return cell;
}

//// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor grayColor];
        return headerView;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        UICollectionReusableView *footerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
        footerView.backgroundColor = UICOLOR_HEX(0x404040);
        return footerView;
    }

    return nil;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
#pragma mark -
#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){CGRectGetWidth(self.view.frame) - 10, (CGRectGetWidth(self.view.frame) - 10) / 2 + 68};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){0,0};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){0,1};
}




#pragma mark ---- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 点击高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UINavigationController *nav = [UINavigationController]
    PlayListViewController *plVc = [[PlayListViewController alloc] init];
    plVc.dataSource = self.fetchRetVC.sections[indexPath.row].objects;
    [self.navigationController pushViewController:plVc animated:YES];
}


// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
