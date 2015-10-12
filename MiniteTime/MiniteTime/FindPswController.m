//
//  FindPswController.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/26.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "FindPswController.h"

@interface FindPswController ()
@property (nonatomic , strong)UIWebView *webView;
@end

@implementation FindPswController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addWebView];
}
-(void)addWebView{

    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    NSURLRequest *find = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:find];
    
    [self.view addSubview:self.webView];
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
