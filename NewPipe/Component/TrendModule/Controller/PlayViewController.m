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

static NSString *TableViewCellIdentifier = @"TableViewCellIdentifier";
@interface PlayViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) ZFPlayerController *player;
@property(nonatomic, strong) UIImageView *containerView;
@property(nonatomic, strong) ZFPlayerControlView *controlView;
@property(nonatomic, strong) UIButton *playBtn;
@property(nonatomic, strong) UIButton *backButn;
@property(nonatomic, copy, null_resettable) NSArray *preferredVideoQualities;
@property(nonatomic, weak) id <XCDYouTubeOperation> videoOperation;
@property(nonatomic, strong) NSMutableArray<NSURL *> *videoQualitiesURLs;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HeadView *headView;
@property (nonatomic, strong) UIView *nextTrackAlertView;
@property (nonatomic, assign) NSInteger currentPlayIndex;
@property (nonatomic, strong) VideoInfo *currentVInfo;
@end

@implementation PlayViewController

#pragma mark- system methouds

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [SVProgressHUD themeConfigContainerView:self.view];

    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.playBtn];
    [self.view addSubview:self.backButn];
    [self.view addSubview:self.tableView];

    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    //    KSMediaPlayerManager *playerManager = [[KSMediaPlayerManager alloc] init];
    //    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
    // 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    // 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = YES;
    self.player.statusBarHidden = YES;
    self.controlView.portraitControlView.topToolView.hidden = YES;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController *_Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    self.player.gestureControl.singleTapped = ^(ZFPlayerGestureControl * _Nonnull control) {
        [self changeBackButnStatus];
    };
    // 点击收藏按钮的回调
    self.headView.addBtnCallBack = ^(void) {
        @strongify(self)
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Title", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:nil];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [SVProgressHUD show];
            __block int show_type = 2;
            if (alertController.textFields.firstObject.text.length <= 0) {
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
                item.listName = alertController.textFields.firstObject.text;
            }];
            if (show_type == 0) {
                [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"HasCollected", nil)];
            } else if (show_type == 1) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Collected", nil)];
            } else {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"NotNull", nil)];
            }
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    };
    self.headView.praiseBtnCallBack = ^(void) {
#pragma TODO 好评跳转
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1078688750"]];
    };
    [self.containerView setImageWithURLString:self.item.imgurl placeholder:nil];
    
    if (self.dataSource == nil || self.dataSource.count <= 0) {
        [PlayItem getVideoList:^(NSArray *videoList) {
            @strongify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                //刷新界面
                self.dataSource = videoList;
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

    [self.videoOperation cancel];
    self.player.viewControllerDisappear = YES;
    [SVProgressHUD dismiss];
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
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    //    self.player.currentPlayerManager.muted = !self.player.currentPlayerManager.muted;
}
#pragma mark- methouds

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
    [self.videoOperation cancel];
    self.videoOperation = [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:self.item.vid completionHandler:^(XCDYouTubeVideo *video, NSError *error) {
        [SVProgressHUD dismiss];
        if (video) {
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
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }
        } else {
            // 出错
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"VideoUnavailable", nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }];
}

- (void)backToList {
    [self.player stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeBackButnStatus {
    if ([self.backButn isHidden]) {
        [self.backButn setHidden:NO];
        [UIView animateWithDuration:0.4 animations:^{
            self.backButn.alpha = 1;
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
        } completion:^(BOOL finished) {
            [self.backButn setHidden:YES];
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

#pragma mark- init subviews
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
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
