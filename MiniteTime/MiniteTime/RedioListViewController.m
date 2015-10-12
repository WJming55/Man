//
//  RedioListViewController.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/23.
//  Copyright (c) 2015年 XieFei. All rights reserved.
////http://api2.pianke.me/ting/radio（client=2）start=9&client=2&limit=9

#import "RedioListViewController.h"
#import "RedioListModel.h"
#import "RedioListCell.h"
#import "WMLoopView.h"
#import "Define.h"
#import "ImageModel.h"
#import "JHRefresh.h"
#import "RedioDetailListController.h"
#import "RedioPlayController.h"
@interface RedioListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)WMLoopView *headerView;
@property (nonatomic , strong)NSMutableArray *headArr;
@property (nonatomic , strong)NSMutableArray *hotArr;
@property (nonatomic , strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic)BOOL isRefreshing;
@property (nonatomic)BOOL isLoadMore;
@property (nonatomic)NSInteger currentPage;
@end

@implementation RedioListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initData];
    [self createTableView];
    [self createRefreshView];
    [self loadResource];
    //[self addTableviewHeaderView];
}
-(void)initData
{
    self.dataArr = [[NSMutableArray alloc]init];
    self.headArr = [[NSMutableArray alloc]init];
    self.hotArr = [[NSMutableArray alloc]init];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}
#pragma mark -创建tableView
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-49-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 40;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RedioListCell" bundle:nil] forCellReuseIdentifier:@"RedioListCell"];
}
#pragma mark - AF
-(void)loadResource
{
    [self.manager POST:kRedioUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *appDic = dict[@"data"];
            [self paserDataWithDictionary:appDic];
        }
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
- (void)loadResourceWithPage:(NSInteger)page
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    [MMProgressHUD showWithTitle:@"正在为您加载" status:@"isLoading...."];
    NSDictionary *dict = @{@"start":@(self.currentPage),@"client":@(2),@"limit":@(9)};
    [self.manager POST:kRedioList parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (self.currentPage == 0) {
                [self.dataArr removeAllObjects];
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *appDic = dict[@"data"];
            [self parserListDataWithDict:appDic];
        }
        [self endRefresh];
        [self.tableView reloadData];
        [MMProgressHUD dismissWithSuccess:@"加载完成"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MMProgressHUD dismissWithError:@"加载失败"];
    }];
}
-(void)parserListDataWithDict:(NSDictionary *)dict{
    NSArray *arr = dict[@"list"];
    for (NSDictionary *allDic in arr) {
        RedioListModel *allm = [[RedioListModel alloc]init];
        NSDictionary *userDic = allDic[@"userinfo"];
        RedioUser *user = [[RedioUser alloc]init];
        [user setValuesForKeysWithDictionary:userDic];
        allm.userinfo = user;
        allm.radioid = allDic[@"radioid"];
        allm.title = allDic[@"title"];
        allm.coverimg = allDic[@"coverimg"];
        allm.count = [allDic[@"count"] integerValue];
        allm.desc = allDic[@"desc"];
        allm.isnew = [allDic[@"isnew"] boolValue];
        [self.dataArr addObject:allm];
    }
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
        weakSelf.currentPage += 9;
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

#pragma mark - 解析数据
-(void)paserDataWithDictionary:(NSDictionary *)dict{
    //取出循环视图字典
   NSArray *arr = dict[@"carousel"];
    for (NSDictionary *hDic in arr) {
        ImageModel *model = [[ImageModel alloc]init];
        [model setValuesForKeysWithDictionary:hDic];
        [self.headArr addObject:model];
    }
    NSArray *hot = dict[@"hotlist"];
    for (NSDictionary *hotDic in hot) {
        RedioListModel *hotmodel = [[RedioListModel alloc]init];
        NSDictionary *userDic = hotDic[@"userinfo"];
        RedioUser *user = [[RedioUser alloc]init];
        [user setValuesForKeysWithDictionary:userDic];
        hotmodel.userinfo = user;
        hotmodel.radioid = hotDic[@"radioid"];
        hotmodel.title = hotDic[@"title"];
        hotmodel.coverimg = hotDic[@"coverimg"];
        hotmodel.count = [hotDic[@"count"] integerValue];
        hotmodel.desc = hotDic[@"desc"];
        hotmodel.isnew = [hotDic[@"isnew"] boolValue];

        
        [self.hotArr addObject:hotmodel];
    }
    NSArray *allArr = dict[@"alllist"];
    for (NSDictionary *allDic in allArr) {
        RedioListModel *allm = [[RedioListModel alloc]init];
        NSDictionary *userDic = allDic[@"userinfo"];
        RedioUser *user = [[RedioUser alloc]init];
        [user setValuesForKeysWithDictionary:userDic];
        allm.userinfo = user;
        allm.radioid = allDic[@"radioid"];
        allm.title = allDic[@"title"];
        allm.coverimg = allDic[@"coverimg"];
        allm.count = [allDic[@"count"] integerValue];
        allm.desc = allDic[@"desc"];
        allm.isnew = [allDic[@"isnew"] boolValue];
        [self.dataArr addObject:allm];
    }
    [self addTableviewHeaderView];
    
}
#pragma mark - 添加tableView的头视图
-(void)addTableviewHeaderView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 270)];
    NSMutableArray *imageArr = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.headArr.count; i++) {
        ImageModel *model = self.headArr[i];
        [imageArr addObject:model.img];
    }
    WMLoopView *headView = [[WMLoopView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180) images:imageArr autoPlay:YES delay:3];
   
    [view addSubview:headView];
    
    CGFloat width = (self.view.frame.size.width - 20)/3;
    CGFloat padding = 5;
    for (int i = 0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame: CGRectMake(padding + (width+padding)*i, 185, width, 85)];
        RedioListModel *model = self.hotArr[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapped:)];
        imageView.tag = 10+i;
        [imageView addGestureRecognizer:tap];
        [view addSubview:imageView];
    }
    self.tableView.tableHeaderView = view;
    
}
-(void)imageViewTapped:(UITapGestureRecognizer *)tap
{
    UIImageView *view = (UIImageView *)tap.view;
    

    RedioDetailListController *vc = [[RedioDetailListController alloc]init];
    
    vc.model = self.hotArr[view.tag - 10];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
#pragma mark - 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RedioListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedioListCell" forIndexPath:indexPath];
    RedioListModel *model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"全部电台";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RedioDetailListController *vc = [[RedioDetailListController alloc]init];
    RedioListModel *model = self.dataArr[indexPath.row];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
