//
//  LastViewController.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/19.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

//http://api2.pianke.me/read/columns_detail(sort=addtime&start=0&typeid=27&client=2&limit=10)

#import "LastViewController.h"
#import "ArticleListModel.h"
#import "ArticleCell.h"
#import "JHRefresh.h"
#import "Define.h"
#import "DetailArticleViewController.h"
@interface LastViewController ()<UITableViewDataSource , UITableViewDelegate>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic )NSInteger currentPage;
@property (nonatomic , strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic)BOOL isRefreshing;
@property (nonatomic)BOOL isLoadMore;
@end

@implementation LastViewController

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
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    
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
    NSDictionary *dict = @{@"sort":self.sort,@"start":@(page),@"typeid":@(self.type),@"client":@(2),@"limit":@(10)};
    __weak typeof(self)weakSelf = self;
    [self.manager POST:kReadList parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        ArticleListModel *model = [[ArticleListModel alloc]init];
        [model setValuesForKeysWithDictionary:arDict];
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
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    ArticleListModel *model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleListModel *model = self.dataArr[indexPath.row];
    DetailArticleViewController *vc = [[DetailArticleViewController alloc]init];
    vc.contentid = model.id;
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
