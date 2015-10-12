//
//  DetailTagController.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/28.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "DetailTagController.h"
#import "Define.h"
#import "TimeLineListCell.h"
#import "TimeLineModel.h"
#import "JHRefresh.h"
#import "LZXHelper.h"
#import "TagController.h"
#import "TagInfoController.h"
@interface DetailTagController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic)NSInteger currentPage;
@property (nonatomic)BOOL isRefreshing;
@property (nonatomic)BOOL isLoadMore;

@end

@implementation DetailTagController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createView];
    [self createRefreshView];
    [self createRightButtons];
    [self loadResourceWithPage:0];
}
-(void)createRightButtons{
  
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 7, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"write"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(writeComment:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[ item2];
    
}

-(void)writeComment:(UIButton *)button{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData
{
    self.dataArr = [[NSMutableArray alloc]init];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
}
-(void)createView
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 40;
    [self.tableView registerNib:[UINib nibWithNibName:@"TimeLineListCell" bundle:nil] forCellReuseIdentifier:@"TimeLineListCell"];
    
    [self.view addSubview:self.tableView];
}
#pragma mark -
#pragma mark - 增加刷新
-(void)createRefreshView
{
    __weak typeof(self)weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing =YES;
        weakSelf.currentPage = 0;
        [weakSelf loadResourceWithPage:weakSelf.currentPage];
    }];
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadMore) {
            return ;
        }
        weakSelf.isLoadMore = YES;
        weakSelf.currentPage += 10;
        [weakSelf loadResourceWithPage:weakSelf.currentPage];
    }];
    
}
-(void)endRefresh
{
    //[self.tableVie]
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
        
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.tableView footerEndRefreshing];
    }
}
#pragma mark - 下载内容
-(void)loadResourceWithPage:(NSInteger)page
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    [MMProgressHUD showWithTitle:@"正在为您加载" status:@"isLoading...."];
    //设置请求参数
    //start=0&client=2&limit=10
    NSDictionary *dict = @{@"tag":self.tag.tag,@"start":@(page),@"client":@(2),@"limit":@(10)};
    __weak typeof(self)weakSelf = self;
    [self.manager POST:kHomeTimeUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (weakSelf.currentPage == 0) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [self parserDataWithDictionary:dict];
        }
        [self endRefresh];
        [self.tableView reloadData];
        
        [MMProgressHUD dismissWithSuccess:@"加载完成"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MMProgressHUD dismissWithError:@"加载失败"];
    }];
}

//解析数据
-(void)parserDataWithDictionary:(NSDictionary *)dict
{
    NSDictionary *appDic = dict[@"data"];
    NSArray *arr = appDic[@"list"];
    for (NSDictionary *arDict in arr) {
        TimeLineModel *model = [[TimeLineModel alloc]init];
        model.contentid = arDict[@"contentid"];
        NSDictionary *userDic = arDict[@"userinfo"];
        TimeUser *user = [[TimeUser alloc]init];
        [user setValuesForKeysWithDictionary:userDic];
        model.userinfo = user;
        model.addtime = [arDict[@"addtime"] integerValue];
        model.addtime_f = arDict[@"addtime_f"];
        model.songid = arDict[@"songid"];
        model.content = arDict[@"content"];
        NSDictionary *counterDic = arDict[@"counterList"];
        TimeCounter *counter = [[TimeCounter alloc]init];
        [counter setValuesForKeysWithDictionary:counterDic];
        
        model.counterList = counter;
        
        model.coverimg = arDict[@"coverimg"];
        model.coverimg_wh = arDict[@"coverimg_wh"];
        model.islike = [arDict[@"islike"] boolValue];
        NSDictionary *tagDic = arDict[@"tag_info"];
        Tag_Info *tag = [[Tag_Info alloc]init];
        [tag setValuesForKeysWithDictionary:tagDic];
        model.tag_info = tag;
        
        [self.dataArr addObject:model];
    }
}
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimeLineListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeLineListCell" forIndexPath:indexPath];
    TimeLineModel *model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimeLineModel * model = self.dataArr[indexPath.row];
    CGFloat Height =100;
    if (model.coverimg_wh.length>0) {
        NSArray * wh = [model.coverimg_wh componentsSeparatedByString:@"*"];
        CGFloat with = [wh[0] doubleValue];
        CGFloat height = [wh[1] doubleValue];
        CGFloat imageH =(self.view.frame.size.width-20)*height/with;
        Height +=imageH;
    }
    Height += [LZXHelper textHeightFromTextString:model.content width:self.view.frame.size.width-20 fontSize:17];
    return Height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TimeLineModel *model =self.dataArr[indexPath.row];
    TagInfoController *tvc = [[TagInfoController alloc]init];
    tvc.model = model;
    [self.navigationController hidesBottomBarWhenPushed];
    [self.navigationController pushViewController:tvc animated:YES];
}
@end
