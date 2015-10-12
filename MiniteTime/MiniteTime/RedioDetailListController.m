//
//  RedioDetailListController.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/23.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "RedioDetailListController.h"
#import "TopView.h"
#import "Define.h"
#import "DetailListCell.h"
#import "DetailListModel.h"
#import "JHRefresh.h"
#import "RedioPlayController.h"
@interface RedioDetailListController ()<UITableViewDataSource , UITableViewDelegate>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic )BOOL isRefreshing;
@property (nonatomic)BOOL isLoadMore;
@property (nonatomic)NSInteger currentPage;
@property (nonatomic)NSInteger totalNum;
@end

@implementation RedioDetailListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = self.model.title;
    [self initData];
    [self createTableView];
    [self createRefreshView];
    [self loadResourceWithPage:0];
}

-(void)initData{
    self.dataArr = [[NSMutableArray alloc]init];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer= [AFHTTPResponseSerializer serializer];
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-49) style:UITableViewStylePlain];
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    TopView *view = [[TopView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,260)];
    
    [view showDataWithModel:self.model];
    self.tableView.tableHeaderView = view;
    self.tableView.estimatedRowHeight = 40;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailListCell" bundle:nil] forCellReuseIdentifier:@"DetailListCell"];
}
#pragma mark - AF
- (void)loadResourceWithPage:(NSInteger)page
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    [MMProgressHUD showWithTitle:@"正在为您加载" status:@"isLoading...."];
    NSDictionary *dict = @{@"radioid":self.model.radioid,@"start":@(self.currentPage),@"client":@(2),@"limit":@(10)};
    __weak typeof(self)weakSelf = self;
    [self.manager POST:kRedioDetail parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (weakSelf.currentPage == 0) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
           
            NSDictionary *appDic = dict[@"data"];
            [weakSelf parserListDataWithDict:appDic];
            if (!weakSelf.totalNum) {
                weakSelf.totalNum = [appDic[@"total"] integerValue];
            }
            

        }
        [weakSelf endRefresh];
        [weakSelf.tableView reloadData];
        [MMProgressHUD dismissWithSuccess:@"加载完成"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MMProgressHUD dismissWithError:@"加载失败"];
        NSLog(@"=============");
    }];

}
#pragma mark - 解析数据
-(void)parserListDataWithDict:(NSDictionary *)dict{
    NSArray *arr = dict[@"list"];
    for (NSDictionary *allDic in arr) {
        DetailListModel *allm = [[DetailListModel alloc]init];
        allm.tingid = allDic[@"tingid"];
        allm.title = allDic[@"title"];
        allm.coverimg = allDic[@"coverimg"];
        allm.musicVisit = allDic[@"musicVisit"] ;
        allm.musicUrl = allDic[@"musicUrl"];
        allm.isnew = [allDic[@"isnew"] boolValue];
        
        PlayModel *playModel = [[PlayModel alloc]init];
        NSDictionary *playDic = allDic[@"playInfo"];
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
        RedioDetailUser *userModel = [[RedioDetailUser alloc]init];
        [userModel setValuesForKeysWithDictionary:userDic];
        
        playModel.userinfo = userModel;
        
        NSDictionary *authorDic = playDic[@"authorinfo"];
        RedioAuther *authorModel = [[RedioAuther alloc]init];
        [authorModel setValuesForKeysWithDictionary:authorDic];
        playModel.authorinfo = authorModel;
        
        NSDictionary *shareDic = playDic[@"shareinfo"];
        RedioShareinfo *shareModel = [[RedioShareinfo alloc]init];
        [shareModel setValuesForKeysWithDictionary:shareDic];
        playModel.shareinfo = shareModel;
        allm.playInfo = playModel;
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
        if (weakSelf.dataArr.count == weakSelf.totalNum) {
            weakSelf.isLoadMore = YES;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"没有更多" message:@"已经到最后，没有更多数据" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [weakSelf endRefresh];
            }]];
            [weakSelf presentViewController:alert animated:YES completion:nil];
           
        }else{
           
            if (weakSelf.isLoadMore) {
                return ;
            }
            weakSelf.isLoadMore = YES;
            weakSelf.currentPage += 10;
            [weakSelf loadResourceWithPage:weakSelf.currentPage];
           
            
        }
        
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

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailListCell" forIndexPath:indexPath];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height/2-20, 40, 40)];
    image.layer.cornerRadius = 20;
    image.clipsToBounds = YES;
    image.image = [UIImage imageNamed:@"play.jpg"];
    cell.accessoryView = image;
    DetailListModel *model = self.dataArr [indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RedioPlayController *rvc = [[RedioPlayController alloc]init];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    rvc.dataArr = self.dataArr;
    rvc.model = self.dataArr[indexPath.row];
   
    [self presentViewController:rvc animated:YES completion:^{
        
    }];
  
}

@end
