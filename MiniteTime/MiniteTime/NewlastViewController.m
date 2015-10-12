//
//  NewestViewController.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/20.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//@"http://api2.pianke.me/read/latest"(sort=addtime&start=0&client=2&limit=10)

#import "NewlastViewController.h"
#import "Define.h"
#import "NewestModel.h"
#import "NewCell.h"
#import "JHRefresh.h"
#import "DetailArticleViewController.h"
@interface NewlastViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic )NSInteger currentPage;
@property (nonatomic , strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic)BOOL isRefreshing;
@property (nonatomic)BOOL isLoadMore;
@end

@implementation NewlastViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createView];
    [self loadResourceWithPage:0];
    [self createRefreshView];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"NewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
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
    //sort=addtime&start=0&typeid=27&client=2&limit=10
    NSDictionary *dict = @{@"sort":self.sort,@"start":@(page),@"client":@(2),@"limit":@(10)};
    __weak typeof(self)weakSelf = self;
    [self.manager POST:kReadLastUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        NewestModel *model = [[NewestModel alloc]init];
        model.contentid = arDict[@"contentid"];
        NSDictionary *userDic = arDict[@"userinfo"];
        [model.userinfo setValuesForKeysWithDictionary:userDic];
        model.addtime = [arDict[@"addtime"] integerValue];
        model.addtime_f = arDict[@"addtime_f"];
        model.title = arDict[@"title"];
        model.firstimage = arDict[@"firstimage"];
        model.shortcontent = arDict[@"shortcontent"];
        NSDictionary *counDic = arDict[@"counterList"];
        [model.counterList setValuesForKeysWithDictionary:counDic];
        model.islike = arDict[@"islike"];
        
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
    NewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    NewestModel *model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewestModel *model = self.dataArr[indexPath.row];
    DetailArticleViewController *vc = [[DetailArticleViewController alloc]init];
    vc.contentid = model.contentid;
    [self.navigationController pushViewController:vc animated:YES];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 120;
//}
@end
