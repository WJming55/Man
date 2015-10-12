//
//  ReadViewController.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/19.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

//http://api2.pianke.me/read/columns（client=2）

#import "DetailArticleViewController.h"
#import "WMPageController.h"
#import "ReadViewController.h"
#import "Define.h"
#import "ReadHomeModel.h"
#import "ReadCell.h"
#import "ImageModel.h"
#import "HeadReusableView.h"
#import "FootReusableView.h"
#import "ListController.h"
#import "LastViewController.h"
#import "NewlastViewController.h"
@interface ReadViewController ()<UICollectionViewDataSource ,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout,WMLoopViewDelegate>
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)AFHTTPRequestOperationManager *mananger;
@property (nonatomic , strong)NSMutableArray *imagesArr;
@property (nonatomic ,strong)HeadReusableView *head;
@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阅读";
    [self initData];
    [self createView];
    [self requestData];
}
-(void)initData
{
    self.dataArr = [[NSMutableArray alloc]init];
    self.imagesArr = [[NSMutableArray alloc]init];
    self.mananger = [AFHTTPRequestOperationManager manager];
    self.mananger.responseSerializer = [AFHTTPResponseSerializer serializer];
}
- (void)createView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 1;
    
    layout.minimumLineSpacing = 2;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    //self.collectionView.contentSize = CGSizeMake(self.view.frame.size.width, 900);
    self.collectionView.bounces = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(2, 1, 2, 1);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ReadCell" bundle:nil] forCellWithReuseIdentifier:@"ReadCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HeadReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reuse"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FootReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];

    [self.view addSubview:self.collectionView];
}
#pragma mark - AF
-(void)requestData
{
   [self.mananger POST:kReadUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       if (responseObject) {
           NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
           [self paserDataWithDictionary:dict];
       }
       
       [self.collectionView reloadData];
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
   }];
}
-(void)paserDataWithDictionary:(NSDictionary *)dict
{
    NSDictionary *appDic = dict[@"data"];
    NSArray *arr = appDic[@"list"];
    for (NSDictionary * app in arr) {
        ReadHomeModel *model = [[ReadHomeModel alloc]init];
        [model setValuesForKeysWithDictionary:app];
        [self.dataArr addObject:model];
    }
    NSArray *imageArr = appDic[@"carousel"];
    for (NSDictionary *imageDic in imageArr) {
        ImageModel *imageModel = [[ImageModel alloc]init];
        [imageModel setValuesForKeysWithDictionary:imageDic];
        [self.imagesArr addObject:imageModel];
    }
   
    
}


#pragma  mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ReadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReadCell" forIndexPath:indexPath];
    ReadHomeModel *model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width-4)/3, 120);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = nil;
       if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
           view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reuse" forIndexPath:indexPath];
           self.head = (HeadReusableView *)view;
           self.head.loopView.delegate = self;
           
           
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
       view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        FootReusableView *fot = (FootReusableView *)view;
        
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapped:)];
            [fot addGestureRecognizer:tap];

    
            }
    return view;
}
-(void)imageTapped:(UITapGestureRecognizer *)tap
{
   NewlastViewController *hot = [[NewlastViewController alloc]init];
    NewlastViewController *last = [[NewlastViewController alloc]init];
    hot.sort = @"hot";
    last.sort = @"addtime";
    
    NSArray *titles = @[@"最新",@"最热"];
    WMPageController *page = [[WMPageController alloc]initWithViewControllers:@[last,hot] andTheirTitles:titles];
    page.title = @"24小时写作";
    [self.navigationController pushViewController:page animated:YES];

}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 200);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width,200);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ReadHomeModel *model = self.dataArr[indexPath.row];
    LastViewController *hot = [[LastViewController alloc]init];
    LastViewController *last = [[LastViewController alloc]init];
    hot.sort = @"hot";
    last.sort = @"addtime";
    hot.type = model.type;
    last.type = model.type;
    NSArray *titles = @[@"最新",@"最热"];
    WMPageController *page = [[WMPageController alloc]initWithViewControllers:@[last,hot] andTheirTitles:titles];
    page.title = model.name;
    [self.navigationController pushViewController:page animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loopViewDidSelectedImage:(WMLoopView *)loopView index:(int)index
{
    NSLog(@"%d",index);
    ImageModel *model = self.head.imageArr[index];
    NSLog(@"%@",model);
    NSArray *arr = [model.url componentsSeparatedByString:@"/"];
    NSString *contentid = [arr lastObject];
    NSLog(@"%@",contentid);
    DetailArticleViewController *vc = [[DetailArticleViewController alloc]init];
    vc.contentid = contentid;
    NSLog(@"%@",contentid);
    [self.navigationController pushViewController:vc animated:YES];

    
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
