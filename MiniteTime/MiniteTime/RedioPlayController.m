//
//  RedioPlayController.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/23.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//http://api2.pianke.me/ting/info(tingid=5600e447723125d7668b45ae&client=2)

#import "RedioPlayController.h"
#import "RedioInfoCell.h"
#import "RedioInfoModel.h"
#import "MoreTingCell.h"
#import <AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import <UIImageView+WebCache.h>
#import "PlayView.h"
#import "MoreHeadView.h"
#import "ReadViewController.h"
#define kRedioPlayUrl @"http://api2.pianke.me/ting/info"
@interface RedioPlayController ()<UITableViewDataSource , UITableViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)UIScrollView *scrollView;
@property (nonatomic , strong)UIWebView *webView;
@property (nonatomic , strong)UICollectionView *collectionView;
@property (nonatomic , strong)NSMutableArray *cdataArr;
@property (nonatomic , strong)AVPlayer *player;
@property (nonatomic , strong)PlayView *playView;
@property (nonatomic , strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic , strong)UIPageControl *pageControl;
@property (nonatomic , strong)RedioInfoModel *rmodel;
@property (nonatomic , strong)UIToolbar *tool;
@property (nonatomic , strong)DetailListModel *currentModel;
@end

@implementation RedioPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.title = self.currentModel.title;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createScrollView];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
    [self loadResource];
    [self createPageControl];
    [self createAudioWithUrl];
    [self createToolBar];
    
}
-(void)createToolBar{
    _tool = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(0, 0, 40, 40);
    button1.layer.cornerRadius = 20;
    button1.clipsToBounds = YES;
    [button1 setBackgroundImage:[UIImage imageNamed:@"before"] forState:UIControlStateNormal];
    
    [button1 addTarget:self action:@selector(beforeClick:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:button1];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.layer.cornerRadius = 20;
    button.clipsToBounds = YES;
    [button setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    button.selected = YES;
    [button addTarget:self action:@selector(playClick:)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(0, 0, 40, 40);
    button2.layer.cornerRadius = 20;
    button2.clipsToBounds = YES;
    [button2 setBackgroundImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(nextClick:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithCustomView:button2];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    button3.frame = CGRectMake(0, 0, 40, 40);
    button3.layer.cornerRadius = 20;
    button3.clipsToBounds = YES;
    [button3 setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(backClick:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc]initWithCustomView:button3];
    [_tool setItems:@[item4,space,item1,space,item2, space, item3, space]];
    [self.view addSubview:_tool];
}

-(void)backClick:(UIButton *)button{
    self.tabBarController.tabBar.hidden = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)beforeClick:(UIButton *)item{
    NSInteger index = [self.dataArr indexOfObject:self.currentModel];
    if (index == 0) {
        index = self.dataArr.count-1;
    }else
    {
        --index;
    }
    self.currentModel = self.dataArr[index];
    [self refreshView];
    
}
-(void)playClick:(UIButton *)item{
    item.selected = !item.selected;
    if (item.selected) {
        [self.player play];
    }else
    {
        [self.player pause];
    }
    
}
-(void)nextClick:(UIButton *)item{
    NSInteger index = [self.dataArr indexOfObject:self.currentModel];
    if (index == self.dataArr.count-1) {
        index = 0;
    }else
    {
        ++index;
    }
    self.currentModel = self.dataArr[index];
    [self refreshView];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    //self.navigationController.toolbar.hidden = YES;
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    
}


#pragma mark - 创建播放器
-(void)createAudioWithUrl{
    
    if (self.player) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        self.player = nil;
    }
    self.playView.slider.value = 0;
    
    //播放网络资源使用方式
    //AVURLAsset代表一个可播放的资源
    AVURLAsset *urlAsset = [[AVURLAsset alloc]initWithURL:[NSURL URLWithString:self.currentModel.playInfo.musicUrl] options:nil];
    //AVPlayerItem是对播放资源的整体描述，包括是否可播放，以及资源的长度等
    //使用AVPlayerItemWithAVURLAsset,指定一个播放资源会对播放资源进行预加载，一看他是否可以播放，这是会对playerItem的属性Status进行修改
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //播放完通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
   
    
    
}
-(void)playEnd:(NSNotification *)notify{
    [self.player seekToTime:kCMTimeZero];
    NSInteger index = [self.dataArr indexOfObject:self.currentModel];
    if (index == self.dataArr.count-1) {
        index = 0;
    }else
    {
        ++index;
    }
    self.currentModel = self.dataArr[index];
    [self refreshView];

}
-(void)refreshView
{
    [self createAudioWithUrl];

    [self.playView.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.currentModel.coverimg]];
    self.playView.titleLabel.text = nil;
    self.playView.titleLabel.text = self.currentModel.title;
   

    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.currentModel.playInfo.webview_url]];
    [self.webView loadRequest:request];

    
}
-(void)initData{
    self.currentModel = self.model;
    self.cdataArr = [[NSMutableArray alloc]init];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}
-(void)createPageControl{
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44-20, self.view.frame.size.width, 20)];
    _pageControl.numberOfPages = 4;
    self.pageControl.currentPage = 1;
    _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    _pageControl.pageIndicatorTintColor = [UIColor orangeColor];
    [self.view addSubview:_pageControl];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
#pragma mark - 添加scrollView
- (void)createScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-44)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(4*self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    [self createTableView];
    [self createWebView];
    [self createPlayView];
    [self createCollectionView];
}
#pragma mark - 创建TableView
- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"RedioInfoCell" bundle:nil] forCellReuseIdentifier:@"RedioInfoCell"];
    [self.scrollView addSubview:self.tableView];
}
#pragma mark - 添加播放界面
- (void)createPlayView{
    self.playView = [[PlayView alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    [self.playView.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.currentModel.coverimg]placeholderImage:[UIImage imageNamed:@"last.jpeg"]];
    self.playView.slider.minimumValue = 0;
    self.playView.slider.maximumValue = 1;
    [self.playView.slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    self.playView.titleLabel.text = nil;
    self.playView.titleLabel.text = self.currentModel.title;
    [self.scrollView addSubview:self.playView];
}
-(void)valueChanged:(UISlider *)slider{
    //当前拖动百分比
    CGFloat progress = self.playView.slider.value;
    CMTime totalTime = self.player.currentItem.duration;
    //seekTime进行定位
    //CMTimeMultiplyByFloat64 可以让CMTime乘以一个浮点数，播放速率一致
    [self.player seekToTime:CMTimeMultiplyByFloat64(totalTime, progress)];
}
#pragma mark- 视频播放KVO函数
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        
        //当监听到AVPlayerItem的状态为AVPlayerItemStatusReadyToPlay
        if(playerItem.status == AVPlayerItemStatusReadyToPlay){
            //资源是可以播放的
            [self.player play];
            
            //AVPlayer提供了一个周期调用的block
            //CMTime 代表时间， value/timescale=second
            //影片播放速率用CMTime进行标示
            __weak typeof(self)weakSelf = self;
            [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                //time 代表当前播放时间
                //得到资源总时长
                CMTime totaltime = weakSelf.player.currentItem.duration;
                CGFloat totalSeconds = CMTimeGetSeconds(totaltime);
                CGFloat currentSeconds = CMTimeGetSeconds(time);
                weakSelf.playView.slider.value = 1.0*currentSeconds/totalSeconds;
            }];
        }else
        {
            
        }
    }
}
#pragma mark - 添加webView
-(void)createWebView{
    self.webView= [[UIWebView alloc]initWithFrame:CGRectMake(2*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.currentModel.playInfo.webview_url]];
    [self.webView loadRequest:request];
    [self.scrollView addSubview:self.webView];
}
#pragma mark - 添加collectionView
-(void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 5;
    
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(3*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) collectionViewLayout:layout];
    self.collectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MoreTingCell" bundle:nil] forCellWithReuseIdentifier:@"MoreTingCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MoreHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MoreHeadView"];
    [self.scrollView addSubview:self.collectionView];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RedioInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedioInfoCell" forIndexPath:indexPath];
    DetailListModel *model = self.dataArr[indexPath.row];
    UIButton *download = [UIButton buttonWithType:UIButtonTypeSystem];
    download.frame = CGRectMake(0, 0, 30, 30);
    download.layer.cornerRadius = 15;
    download.clipsToBounds = YES;
    [download setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    [download setBackgroundImage:[UIImage imageNamed:@"download_select"] forState:UIControlStateSelected];
    [download addTarget:self action:@selector(loadFile:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = download;
    [cell showDataWithModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentModel = self.dataArr[indexPath.row];
    UIBarButtonItem *item = [self.tool.items objectAtIndex:4];
    UIButton *button = (UIButton *)item.customView;
    button.selected = YES;
    [self refreshView];
    
}
#pragma mark - 下载
-(void)loadFile:(UIButton *)button{
    button.selected = !button.selected;
    NSLog(@"开始下载");
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cdataArr.count;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MoreTingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoreTingCell" forIndexPath:indexPath];
    DetailListModel *model = self.cdataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.view.frame.size.width-20)/3, 120);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.frame.size.width, 160);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MoreHeadView" forIndexPath:indexPath];
        MoreHeadView *head = (MoreHeadView *)view;
        [head.djImageView sd_setImageWithURL:[NSURL URLWithString:self.rmodel.redioPlayInfo.userinfo.icon]];
        
        [head.djButton setTitle:self.rmodel.redioPlayInfo.userinfo.uname forState:UIControlStateNormal];
        
        [head.authorImageView sd_setImageWithURL:[NSURL URLWithString:self.rmodel.redioPlayInfo.authorinfo.icon]];
        
        [head.authorButton setTitle:self.rmodel.redioPlayInfo.authorinfo.uname forState:UIControlStateNormal];
        [head.radioButton setTitle:self.rmodel.radioname forState:UIControlStateNormal];
    }
    return view;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.dataArr = nil;
    self.dataArr = [[NSMutableArray alloc]initWithArray:self.cdataArr];
    [self.tableView reloadData];
    self.currentModel = self.cdataArr[indexPath.row];
    [self.cdataArr removeObject:self.currentModel];
    [self.cdataArr addObject:self.model];
    //[self.cdataArr replaceObjectAtIndex:indexPath.row withObject:self.model];
        [collectionView reloadData];
    
    self.model = self.currentModel;
    [self refreshView];
}
#pragma mark - AF
-(void)loadResource
{
    NSDictionary *paramerDic = @{@"tingid":self.model.tingid,@"client":@(2)};
    [self.manager POST:kRedioPlayUrl parameters:paramerDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *appDic = dict[@"data"];
            [self paserDataWithDic:appDic];
            [self.collectionView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - 数据解析
-(void)paserDataWithDic:(NSDictionary *)dict{
    _rmodel = [[RedioInfoModel alloc]init];
    _rmodel.contentid = dict[@"contentid"];
    _rmodel.ting_contentid = dict[@"ting_contentid"];
    _rmodel.tingid = dict[@"tingid"];
    _rmodel.like = [dict[@"like"]integerValue ];
    _rmodel.comment = [dict[@"comment"] integerValue];
    _rmodel.islike = [dict[@"islike"] boolValue];
    _rmodel.isfav = [dict[@"isfav"] boolValue];
    _rmodel.radioid = dict[@"radioid"];
    _rmodel.radioname = dict[@"radioname"];
    
    NSDictionary *playinfDic = dict[@"playInfo"];
    PlayModel *playModel = [[PlayModel alloc]init];
    playModel.title = playinfDic[@"title"];
    playModel.imgUrl = playinfDic[@"imgUrl"];
    playModel.musicUrl = playinfDic[@"musicUrl"];
    playModel.tingid = playinfDic[@"tingid"];
    playModel.webview_url = playinfDic[@"webview_url"];
    playModel.ting_contentid = playinfDic[@"ting_contentid"];
    playModel.sharepic = playinfDic[@"sharepic"];
    playModel.sharetext = playinfDic[@"sharetext"];
    playModel.shareurl = playinfDic[@"shareurl"];
   
    NSDictionary *userDic = playinfDic[@"userinfo"];
   
    RedioDetailUser *user = [[RedioDetailUser alloc]init];
   
    [user setValuesForKeysWithDictionary:userDic];
    playModel.userinfo = user;
    
    NSDictionary *authorDic = playinfDic[@"authorinfo"];
    RedioAuther *author = [[RedioAuther alloc]init];
    [author setValuesForKeysWithDictionary:authorDic];
    playModel.authorinfo = author;
    
    NSDictionary *shareDic = playinfDic[@"shareinfo"];
    RedioShareinfo *share = [[RedioShareinfo alloc]init];
    [share setValuesForKeysWithDictionary:shareDic];
    
    playModel.shareinfo = share;
    _rmodel.redioPlayInfo = playModel;
    
    NSArray *more = dict[@"moreting"];
    for (NSDictionary *info in more) {
        DetailListModel *allm = [[DetailListModel alloc]init];
        allm.tingid = info[@"tingid"];
        allm.title = info[@"title"];
        allm.coverimg = info[@"coverimg"];
       
        
        PlayModel *playModel = [[PlayModel alloc]init];
        NSDictionary *playDic = info[@"playInfo"];
        playModel.title = playDic[@"title"];
        playModel.imgUrl = playDic[@"imgUrl"];
        playModel.musicUrl = playDic[@"musicUrl"];
        playModel.tingid = playDic[@"tingid"];
        playModel.webview_url = playDic[@"webview_url"];
        playModel.ting_contentid = playDic[@"ting_contentid"];
        playModel.sharepic = playDic[@"sharepic"];
        playModel.sharetext = playDic[@"sharetext"];
        playModel.shareurl = playDic[@"shareurl"];
        
        NSDictionary *userDic = playDic[@"userinfo"];
        RedioDetailUser *usermodel = [[RedioDetailUser alloc]init];
        [usermodel setValuesForKeysWithDictionary:userDic];
        
        playModel.userinfo = usermodel;
        
        NSDictionary *authorDic = playDic[@"authorinfo"];
        RedioAuther *authorModel = [[RedioAuther alloc]init];
        [authorModel setValuesForKeysWithDictionary:authorDic];
        playModel.authorinfo = authorModel;
        
        NSDictionary *shareDic = playDic[@"shareinfo"];
        RedioShareinfo *shareModel = [[RedioShareinfo alloc]init];
        [shareModel setValuesForKeysWithDictionary:shareDic];
        playModel.shareinfo = shareModel;
        allm.playInfo = playModel;
        [self.cdataArr addObject:allm];
    }
    _rmodel.moreTingArr = self.cdataArr;
    
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[self.scrollView class]] ) {
        NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
        self.pageControl.currentPage = index;
    }

}
@end
