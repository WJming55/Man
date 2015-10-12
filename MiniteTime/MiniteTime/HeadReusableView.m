//
//  HeadReusableView.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/19.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "HeadReusableView.h"

#import "Define.h"
#import "ImageModel.h"
#import "DetailArticleViewController.h"

@interface HeadReusableView()<WMLoopViewDelegate>
//@property (nonatomic , strong)NSMutableArray *imageArr;

@end
@implementation HeadReusableView

- (void)awakeFromNib {
    self.backgroundColor = [UIColor blueColor];
    [self loadData];
    
}
-(void)loadData
{
    self.imageArr = [[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:kReadUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *app = dict[@"data"];
        NSArray *arr = app[@"carousel"];
        for (NSDictionary *imagDic in arr) {
            ImageModel *model = [[ImageModel alloc]init];
            [model setValuesForKeysWithDictionary:imagDic];
            [self.imageArr addObject:model];
        }
        [self setUpView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)setUpView
{
    NSMutableArray *image = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.imageArr.count; i++) {
        ImageModel *model = self.imageArr[i];
        [image addObject:model.img];
    }
   self.loopView = [[WMLoopView alloc]initWithFrame:self.frame images:image autoPlay:YES delay:4];
    [self addSubview:self.loopView];
    //self.loopView.delegate = self;
}
-(void)loopViewDidSelectedImage:(WMLoopView *)loopView index:(int)index
{
    ImageModel *model = self.imageArr[index];
    NSArray *arr = [model.url componentsSeparatedByString:@"/"];
    NSString *contentid = [arr lastObject];
    NSLog(@"%@",contentid);
    DetailArticleViewController *vc = [[DetailArticleViewController alloc]init];
    vc.contentid = contentid;
    
    
}
@end
