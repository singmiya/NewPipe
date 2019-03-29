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
#import "DataSourceManager.h"
#import "NetWorkConstants.h"
#import "VideoInfo.h"

static NSString *CollectionTableViewCellIdentifier = @"CollectionTableViewCellIdentifier";
@interface CollectionListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchRetVC;
@property (nonatomic, strong) NSMutableDictionary *firstDic;
@property (nonatomic, strong) NSMutableArray *firstSectionArr;

@end

@implementation CollectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD themeConfigContainerView:self.view];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", BASE_URL, PREFIX_URL, @"Category.json"];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading", nil)];
    @weakify(self)
    [[DataSourceManager sharedInstance] get:url params:nil success:^(id response) {
        @strongify(self)
        NSArray *arr = response[@"Bookmark|"];
        if (arr != nil && arr.count > 0) {
            self.firstDic = [NSMutableDictionary dictionary];
            [self.firstDic addEntriesFromDictionary:arr[0]];
            
            NSString *vid = [[self.firstDic[@"thumbnailUrl"] stringByReplacingOccurrencesOfString:@"https://i.ytimg.com/vi/" withString:@""]  stringByReplacingOccurrencesOfString:@"/default.jpg" withString:@""];
            [VideoInfo getVideoInfo:^(VideoInfo *videoInfo) {
                self.firstDic[@"avatarImgUrl"] = videoInfo.avatarImgUrl;
                self.firstDic[@"playnum"] = videoInfo.viewCount;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //刷新界面
                    [self.tableView reloadData];
                    [SVProgressHUD dismiss];
                });
            } withVid:vid];;
            [PlayItem getVideoList:^(NSArray *videoList) {
                self.firstSectionArr = (NSMutableArray *)videoList;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //刷新界面
                    [self.tableView reloadData];
                });
            } withUrl:self.firstDic[@"url"]];
        }
    } failure:^(id response) {
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fetchRetVC = [CollectionItem MR_fetchAllGroupedBy:@"listName" withPredicate:nil sortedBy:@"updateTime" ascending:NO];
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [CollectionItem mr]
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
    if ((self.fetchRetVC && self.fetchRetVC.sections) && self.firstDic) {
        return self.fetchRetVC.sections.count + 1;
    }
    if (self.fetchRetVC && self.fetchRetVC.sections) {
        return self.fetchRetVC.sections.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CollectionTableViewCellIdentifier];
    if (self.firstDic) {
        if (indexPath.row == 0) {
            [cell configCellData:self.firstDic num:self.firstSectionArr.count];
        } else {
            [cell configCellData:self.fetchRetVC.sections[indexPath.row - 1].objects.firstObject num:self.fetchRetVC.sections[indexPath.row - 1].objects.count];
        }
    } else {
        [cell configCellData:self.fetchRetVC.sections[indexPath.row].objects.firstObject num:self.fetchRetVC.sections[indexPath.row].objects.count];
    }
    return cell;
}
#pragma mark -
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlayViewController *plVc = [[PlayViewController alloc] init];
    
    if (self.firstDic && indexPath.row == 0) {
        plVc.dataSource = self.firstSectionArr;
        plVc.item = self.firstSectionArr[0];
        [plVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:plVc animated:YES];
        return;
    }
    __block NSMutableArray *dataSource = [NSMutableArray array];
    NSInteger index = 0;
    if (self.firstDic) {
        index = indexPath.row - 1;
    } else {
        index = indexPath.row;
    }
    for (CollectionItem *ci in self.fetchRetVC.sections[index].objects) {
        PlayItem *pi = [PlayItem new];
        pi.vid = ci.vid;
        pi.title = ci.title;
        pi.channelName = ci.author;
        pi.avatarImgUrl = ci.avatarImgUrl;
        pi.imgurl = ci.imgurl;
        pi.goodnum = ci.goodnum;
        pi.playnum = ci.playnum;
        pi.badnum = ci.badnum;
        pi.duration = ci.duration;
        pi.lasttime = ci.lasttime;
        [dataSource addObject:pi];
    }
    if (dataSource.count <= 0) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"NilVideos", nil)];
        return;
    }
    plVc.dataSource = dataSource;
    plVc.item = dataSource[0];
    [plVc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:plVc animated:YES];
}

@end
