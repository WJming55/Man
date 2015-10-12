//
//  TagController.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/28.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "TagController.h"
#import "Define.h"
#import "TagModel.h"
#import "TagCell.h"
#import "DetailTagController.h"
@interface TagController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic , strong)UICollectionView *collectionView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)AFHTTPRequestOperationManager *manager;
@end

@implementation TagController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createCollectionView];
    [self loadResource];
}
- (void)initData{
    self.dataArr = [[NSMutableArray alloc]init];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}
-(void)createCollectionView{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 4;
    layout.minimumLineSpacing = 4;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.collectionView registerNib:[UINib nibWithNibName:@"TagCell" bundle:nil] forCellWithReuseIdentifier:@"TagCell"];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}
#pragma mark - 
#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
    TagModel *model = [self.dataArr objectAtIndex:indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake((self.view.frame.size.width-28)/3, 120);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TagModel *model = self.dataArr[indexPath.row];
    DetailTagController *dvc = [[DetailTagController alloc]init];
    dvc.tag = model;
    [self.navigationController pushViewController:dvc animated:YES];
}
#pragma mark --AF
-(void)loadResource{

    NSDictionary *paramerDic = @{@"client":@(2)};
    [self.manager POST:kTagUrl parameters:paramerDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [self paserDataWithDic:dict];
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    }];
}
#pragma mark - 解析数据
-(void)paserDataWithDic:(NSDictionary *)dict{
    NSDictionary *allDic = dict[@"data"];
    NSArray *listArr = allDic[@"list"];
    
    for (NSDictionary *tagDic  in listArr) {
        TagModel *model = [[TagModel alloc]init];
        [model setValuesForKeysWithDictionary:tagDic];
        [self.dataArr addObject:model];
    }
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
