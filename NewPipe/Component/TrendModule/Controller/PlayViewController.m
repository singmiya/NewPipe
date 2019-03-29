//
//  PlayViewController.m
//  NewPipe
//
//  Created by Somiya on 2018/10/14.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "PlayViewController.h"
#import "Masonry.h"
#import "PlayItem.h"
#import "SVProgressHUD.h"
#import "SVIndefiniteAnimatedView.h"
#import "XCDYouTubeClient.h"
#import <ZFPlayer/ZFPlayer.h>
#import "ZFIJKPlayerManager.h"
#import "KSMediaPlayerManager.h"
#import "ZFAVPlayerManager.h"
#import "UIImageView+ZFCache.h"
#import "ZFUtilities.h"
#import "ZFPlayerControlView.h"
#import "ColorUtil.h"
#import <ZFPlayer/ZFPlayerMediaControl.h>
#import "RecommendTableViewCell.h"
#import "HeadView.h"
#import "VideoInfo.h"
#import "SVProgressHUD+Util.h"
#import "CollectionItem+CoreDataClass.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Constant.h"
#import "PickTagView.h"
#import "UIButton+Util.h"

static NSString *TableViewCellIdentifier = @"TableViewCellIdentifier";
@interface PlayViewController ()<UITableViewDelegate, UITableViewDataSource, PickTagDelegate>
@property(nonatomic, strong) ZFPlayerController *player;
@property(nonatomic, strong) UIImageView *containerView;
@property(nonatomic, strong) ZFPlayerControlView *controlView;
@property(nonatomic, strong) UIButton *playBtn;
@property(nonatomic, strong) UIButton *backButn;
@property(nonatomic, copy, null_resettable) NSArray *preferredVideoQualities;
@property(nonatomic, strong) XCDYouTubeClient *client;
@property(nonatomic, strong) NSMutableArray<NSURL *> *videoQualitiesURLs;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HeadView *headView;
@property (nonatomic, strong) UIView *nextTrackAlertView;
@property (nonatomic, assign) NSInteger currentPlayIndex;
@property (nonatomic, strong) VideoInfo *currentVInfo;

@property (nonatomic, strong) PickTagView *pickTagView;

@property (nonatomic, strong) UIButton *nextTrackL; // 下一首
@property (nonatomic, strong) UIButton *previousTrackL; // 上一首
@property (nonatomic, strong) UIButton *nextTrackP; // 下一首
@property (nonatomic, strong) UIButton *previousTrackP; // 上一首
@end

@implementation PlayViewController

#pragma mark- system methouds

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [SVProgressHUD themeConfigContainerView:self.view];

    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.playBtn];
    [self.view addSubview:self.backButn];
    [self.view addSubview:self.tableView];
    [self initPlayer];
    NSFetchedResultsController *fetchRetVC = [CollectionItem MR_fetchAllGroupedBy:@"listName" withPredicate:nil sortedBy:@"updateTime" ascending:NO];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:fetchRetVC.sections.count];
    for (id<NSFetchedResultsSectionInfo> info in fetchRetVC.sections) {
        [arr addObject:info.name];
    }
    [self initPickTagView:arr];
}

#pragma mark- methouds
- (void)nextTrackDidClick:(id)sender {
    [self.player stop];
    self.currentPlayIndex ++;
    // 播放下一首
    if (self.currentPlayIndex >= self.dataSource.count) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"ListOver", nil)];
        return;
    }
    PlayItem *newItem = self.dataSource[self.currentPlayIndex];
    if ([newItem.vid isEqualToString:self.item.vid]) {
        return;
    }
    self.item = newItem;
    [self.containerView setImageWithURLString:self.item.imgurl placeholder:nil];
    [self playVideo];
}
- (void)previousTrackDidClick:(id)sender {
    [self.player stop];
    self.currentPlayIndex --;
    // 播放上一首
    if (self.currentPlayIndex < 0) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"FirstVideo", nil)];
        return;
    }
    PlayItem *newItem = self.dataSource[self.currentPlayIndex];
    if ([newItem.vid isEqualToString:self.item.vid]) {
        return;
    }
    self.item = newItem;
    [self.containerView setImageWithURLString:self.item.imgurl placeholder:nil];
    [self playVideo];
}

- (void)playVideo {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading", nil)];
    [VideoInfo getVideoInfo:^(VideoInfo *videoInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新界面
            self.currentVInfo = videoInfo;
            [self.headView configData:videoInfo];
            [self.tableView reloadData];
            NSLog(@"xxxxxxxxxxx%@", NSStringFromCGRect(self.headView.frame));
        });
    } withVid:self.item.vid];
    
    self.videoQualitiesURLs = [NSMutableArray array];
    
    [self.client getVideoWithIdentifier:self.item.vid completionHandler:^(XCDYouTubeVideo *video, NSError *error) {
        [SVProgressHUD dismiss];
        
        if (video && [video.identifier isEqualToString:self.item.vid]) {
            for (NSNumber *videoQuality in self.preferredVideoQualities) {
                NSURL *streamURL = video.streamURLs[videoQuality];
                if (!streamURL) {
                    continue;
                }
                [self.videoQualitiesURLs addObject:streamURL];
            }
            if (self.videoQualitiesURLs.count > 0) {
                self.player.assetURL = self.videoQualitiesURLs[0];
                [self.controlView showTitle:self.item.title coverURLString:self.item.imgurl fullScreenMode:ZFFullScreenModeLandscape];
            } else {
//                NSError *noStreamError = [NSError errorWithDomain:XCDYouTubeVideoErrorDomain code:XCDYouTubeErrorNoStreamAvailable userInfo:nil];
                // 出错
                [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"VideoUnavailable", nil)];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                });
            }
        } else {
            // 出错
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"VideoUnavailable", nil)];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self dismissViewControllerAnimated:YES completion:nil];
//            });
        }
    }];
}

- (void)backToList {
    [self.player stop];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeButnStatus {
    if ([self.backButn isHidden]) {
        [self.backButn setHidden:NO];
        [self.previousTrackP setHidden:NO];;
        [self.nextTrackP setHidden:NO];
        [self.previousTrackL setHidden:NO];
        [self.nextTrackL setHidden:NO];
        [UIView animateWithDuration:0.4 animations:^{
            self.backButn.alpha = 1;
            self.previousTrackP.alpha = 1;
            self.nextTrackP.alpha = 1;
            self.previousTrackL.alpha = 1;
            self.nextTrackL.alpha = 1;
        } completion:^(BOOL finished) {
        }];
        if (self.player.isFullScreen) {
            [self.controlView.landScapeControlView showControlView];
        } else {
            [self.controlView.portraitControlView showControlView];
        }
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            self.backButn.alpha = 0;
            self.previousTrackP.alpha = 0;
            self.nextTrackP.alpha = 0;
            self.previousTrackL.alpha = 0;
            self.nextTrackL.alpha = 0;
        } completion:^(BOOL finished) {
            [self.backButn setHidden:YES];
            [self.previousTrackP setHidden:YES];
            [self.nextTrackP setHidden:YES];
            [self.previousTrackL setHidden:YES];
            [self.nextTrackL setHidden:YES];
        }];
        if (self.player.isFullScreen) {
            [self.controlView.landScapeControlView hideControlView];
        } else {
            [self.controlView.portraitControlView hideControlView];
        }
    }
}

- (void)playClick:(UIButton *)sender {
    [self.player playTheIndex:0];
    [self.controlView showTitle:@"视频标题" coverURLString:nil fullScreenMode:ZFFullScreenModeLandscape];
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    [cell configCellData:self.dataSource[indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
        {
            if (self.currentPlayIndex == indexPath.row) {
                [SVProgressHUD showInfoWithStatus:@"当前视频正在播放，不可删除"];
            } else {
                if (self.currentPlayIndex > indexPath.row) {
                    self.currentPlayIndex --;
                }
                [self.dataSource removeObjectAtIndex:indexPath.row];
                PlayItem *pi = self.dataSource[indexPath.row];
                NSArray *items = [CollectionItem MR_findByAttribute:@"vid" withValue:pi.vid];
                if (items != nil) {
                    for (CollectionItem *item in items) {
                        [item MR_deleteEntity];
                    }
                }
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark -
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlayItem *newItem = self.dataSource[indexPath.row];
    if ([newItem.vid isEqualToString:self.item.vid]) {
        return;
    }
    [self.player stop];
    self.item = newItem;
    [self.containerView setImageWithURLString:self.item.imgurl placeholder:nil];
    [self playVideo];
    self.currentPlayIndex = indexPath.row;
}

#pragma mark - PickTagDelegate
- (void)confirmDidClick:(NSString *)tag {
    NSLog(@"confirm butn clicked!!! %@", tag);
    [SVProgressHUD show];
    __block int show_type = 2;
    if (tag.length <= 0) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"ListNameNOtNil", nil)];
        return;
    }
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        CollectionItem *item = [CollectionItem MR_findFirstByAttribute:@"vid" withValue:self.item.vid inContext:localContext];
        if (item) {
            show_type = 0; // 已收藏
            item.updateTime = [NSDate date];
            return;
        }
        show_type = 1;
        item = [CollectionItem MR_createEntityInContext:localContext];
        item.vid = self.item.vid;
        item.title = self.item.title;
        item.imgurl = self.item.imgurl;
        item.author = self.item.channelName;
        item.playnum = self.item.playnum;
        item.badnum = self.item.badnum;
        item.goodnum = self.item.goodnum;
        item.lasttime = self.item.lasttime;
        item.duration = self.item.duration;
        item.avatarImgUrl = self.currentVInfo.avatarImgUrl;
        item.createTime = [NSDate date];
        item.updateTime = [NSDate date];
        item.listName = tag;
    }];
    if (show_type == 0) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"HasCollected", nil)];
    } else if (show_type == 1) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Collected", nil)];
    } else {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"NotNull", nil)];
    }
    
}
- (void)addTagDidClick:(UIAlertController *)alertVC {
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark- init client
- (XCDYouTubeClient *)client {
    if(_client == nil) {
        _client = [[XCDYouTubeClient alloc] initWithLanguageIdentifier:@"en"];
    }
    return _client;
}

#pragma mark- init subviews
- (void)initPlayer {
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    //    KSMediaPlayerManager *playerManager = [[KSMediaPlayerManager alloc] init];
    //    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
    // 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    // 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    self.player.statusBarHidden = YES;
    self.controlView.portraitControlView.topToolView.hidden = NO;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController *_Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    self.player.gestureControl.singleTapped = ^(ZFPlayerGestureControl * _Nonnull control) {
        [self changeButnStatus];
    };
    // 点击收藏按钮的回调
    self.headView.addBtnCallBack = ^(void) {
        @strongify(self)
        //        [self.player stop];
        [self.pickTagView showPickTagViewInView:self.view];
    };
    self.headView.praiseBtnCallBack = ^(void) {
#pragma TODO 好评跳转
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1078688750"]];
    };
    [self.containerView setImageWithURLString:self.item.imgurl placeholder:nil];
    
    if (self.dataSource == nil || self.dataSource.count <= 0) {
        [PlayItem getVideoList:^(NSArray *videoList) {
            @strongify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                //刷新界面
                self.dataSource = [videoList mutableCopy];
                //刷新界面
                [self.tableView reloadData];
            });
        } withVid:self.item.vid];
        self.currentPlayIndex = -1;
    } else {
        self.currentPlayIndex = 0;
    }
    
    [self playVideo];
    
    // 播放完成
    self.player.playerDidToEnd = ^(id <ZFPlayerMediaPlayback> _Nonnull asset) {
        @strongify(self)
        [self.player stop];
        self.currentPlayIndex ++;
        // 自动播放下一首
        if (self.currentPlayIndex >= self.dataSource.count) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"ListOver", nil)];
            return;
        }
        PlayItem *newItem = self.dataSource[self.currentPlayIndex];
        if ([newItem.vid isEqualToString:self.item.vid]) {
            return;
        }
        self.item = newItem;
        [self.containerView setImageWithURLString:self.item.imgurl placeholder:nil];
        [self playVideo];
    };
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        [self initCustomPlayView];
    }
    return _controlView;
}

- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
        _controlView.contentMode = UIViewContentModeScaleAspectFit;
//        [_containerView setImageWithURLString:nil placeholder:[ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)]];
    }
    return _containerView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)backButn {
    if (!_backButn) {
        _backButn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButn setFrame:CGRectMake(10, kStatusBarHeight + 10, 40, 40)];
        [_backButn setImage:[UIImage imageNamed:@"close_r"] forState:UIControlStateNormal];
        [_backButn addTarget:self action:@selector(backToList) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButn;
}

//----- init table view
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        UINib *nib = [UINib nibWithNibName:@"RecommendTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:TableViewCellIdentifier];
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = self.headView;
//        _tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        _tableView.separatorColor = UICOLOR_HEX(0x404040);
    }
    return _tableView;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[HeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    }
    return _headView;
}

- (UIView *)nextTrackAlertView {
    if (!_nextTrackAlertView) {
        _nextTrackAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        _nextTrackAlertView.backgroundColor = [UIColor redColor];
    }
    return _nextTrackAlertView;
}

- (void)initPickTagView:(NSArray *)dataSource {
    self.pickTagView = [[PickTagView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 150) dataSource:dataSource];
    self.pickTagView.ptDelegate = self;
}

- (void)initCustomPlayView {
    self.nextTrackL = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextTrackL setTintColor:[UIColor whiteColor]];
    [self.nextTrackL addTarget:self action:@selector(nextTrackDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextTrackL setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    //    [self.nextTrackL setHidden:YES];
    [self.controlView.landScapeControlView addSubview:self.nextTrackL];
    
    self.previousTrackL = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.previousTrackL setTintColor:[UIColor whiteColor]];
    [self.previousTrackL addTarget:self action:@selector(previousTrackDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.previousTrackL setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
    //    [self.previousTrackL setHidden:YES];
    [self.controlView.landScapeControlView addSubview:self.previousTrackL];
    
    
    self.nextTrackP = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextTrackP setTintColor:[UIColor whiteColor]];
    [self.nextTrackP addTarget:self action:@selector(nextTrackDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextTrackP setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    //    [self.nextTrackP setHidden:YES];
    [self.controlView.portraitControlView addSubview:self.nextTrackP];
    
    self.previousTrackP = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.previousTrackP setTintColor:[UIColor whiteColor]];
    [self.previousTrackP addTarget:self action:@selector(previousTrackDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.previousTrackP setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
    //    [self.previousTrackP setHidden:YES];
    [self.controlView.portraitControlView addSubview:self.previousTrackP];
}

#pragma mark- system
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (![self isBeingDismissed])
        return;
    
    self.player.viewControllerDisappear = YES;
    [SVProgressHUD dismiss];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.item.vid = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat x = 0;
    CGFloat y = kStatusBarHeight;
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = w * 9 / 16;
    self.containerView.frame = CGRectMake(x, y, w, h);
    
    self.tableView.frame = CGRectMake(0, h + kStatusBarHeight, w, CGRectGetHeight(self.view.frame) - h - kStatusBarHeight);
    
    w = 44;
    h = w;
    x = (CGRectGetWidth(self.containerView.frame) - w) / 2;
    y = (CGRectGetHeight(self.containerView.frame) - h) / 2;
    self.playBtn.frame = CGRectMake(x, y, w, h);
    
    self.previousTrackP.frame = CGRectMake(x - 100, y, 40, 40);
    self.nextTrackP.frame = CGRectMake(x + 100, y, 40, 40);
    
    x = (CGRectGetWidth([[UIScreen mainScreen] bounds]) / 2);
    y = (CGRectGetHeight([[UIScreen mainScreen] bounds]) / 2);
    self.previousTrackL.frame = CGRectMake(y - 150, x - 40, 64, 64);
    self.nextTrackL.frame = CGRectMake(y + 150, x - 40, 64, 64);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    //    self.player.currentPlayerManager.muted = !self.player.currentPlayerManager.muted;
}

#pragma mark- status bar
- (NSArray *)preferredVideoQualities {
    if (!_preferredVideoQualities)
        _preferredVideoQualities = @[@(XCDYouTubeVideoQualityHD720), @(XCDYouTubeVideoQualityMedium360), @(XCDYouTubeVideoQualitySmall240)];
    
    return _preferredVideoQualities;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}
@end
