//
//  CollectionListViewController.m
//  NewPipe
//
//  Created by Somiya on 2018/12/11.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "CollectionListViewController.h"
#import "SVProgressHUD+Util.h"
#import "SVProgressHUD.h"
#import "ColorUtil.h"
#import "PlayViewController.h"
#import "CollectionTableViewCell.h"
#import <MagicalRecord/MagicalRecord.h>
#import "PlayItem.h"
#import "CollectionItem+CoreDataClass.h"
#import "Constant.h"

static NSString *CollectionTableViewCellIdentifier = @"CollectionTableViewCellIdentifier";
@interface CollectionListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CollectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD themeConfigContainerView:self.view];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = UICOLOR_HEX(0xE54D42);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//----- init table view
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.bounds)  - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        UINib *nib = [UINib nibWithNibName:@"CollectionTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:CollectionTableViewCellIdentifier];
        _tableView.tableFooterView = [UIView new];
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = UICOLOR_HEX(0x404040);
    }
    return _tableView;
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CollectionTableViewCellIdentifier];
    [cell configCellData:self.dataSource[indexPath.row]];
    return cell;
}
#pragma mark -
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlayViewController *playVC = [PlayViewController new];
    CollectionItem *cItem = self.dataSource[indexPath.row];
    PlayItem *pItem = [[PlayItem alloc] init];
    pItem.vid = cItem.vid;
    pItem.title = cItem.title;
    pItem.channelName = cItem.author;
    pItem.imgurl = cItem.imgurl;
    pItem.goodnum = cItem.goodnum;
    pItem.playnum = cItem.playnum;
    pItem.badnum = cItem.badnum;
    playVC.item = pItem;
    [self presentViewController:playVC animated:YES completion:nil];
}

@end
