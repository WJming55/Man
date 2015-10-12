//
//  MyTabBarController.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/23.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "MyTabBarController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}
-(void)createView
{
    NSArray *vcNames = @[@"ReadViewController",@"RedioListViewController",@"PersonalViewController",@"TimeController"];
    NSMutableArray *vcArr = [[NSMutableArray alloc]init];
    NSArray *imageArr = @[@"read",@"redio",@"my",@"time"];
    NSArray *titles = @[@"阅读",@"电台",@"个人中心",@"碎片"];
    for (int i = 0; i<vcNames.count; i++) {
        Class cls = NSClassFromString(vcNames[i]);
        UIViewController *vc = [[cls alloc]init];
        vc.title = titles[i];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [nav.tabBarItem setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageArr[i]]]];
        [nav.tabBarItem setSelectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_select.png",imageArr[i]]]];
        nav.title = titles[i];
        [vcArr addObject:nav];
    }
    self.viewControllers = vcArr;
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
