//
//  ListController.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/19.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "ListController.h"
#import "LastViewController.h"
#import "WMPageController.h"
@interface ListController ()

@end

@implementation ListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self createView];
}
- (void)createView
{
    LastViewController *hot = [[LastViewController alloc]init];
    LastViewController *last = [[LastViewController alloc]init];
    hot.sort = @"hot";
    last.sort = @"addtime";
    hot.type = self.type;
    last.type = self.type;
    NSArray *titles = @[@"最新",@"最热"];
    WMPageController *page = [[WMPageController alloc]initWithViewControllers:@[last,hot] andTheirTitles:titles];
    [self.navigationController pushViewController:page animated:YES];
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
