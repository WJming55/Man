//
//  DetailArticleViewController.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/19.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//@"http://api2.pianke.me/article/info?contentid=55f63c9b5d7743677f8b465c&client=2"
//参数 contentid=55f63c9b5d7743677f8b465c&client=2

#import "DetailArticleViewController.h"
#import "Define.h"
#import "DetailArticleModel.h"
#import "UMSocial.h"
@interface DetailArticleViewController ()<UIWebViewDelegate>
@property (nonatomic , strong)DetailArticleModel *detailModel;
@end

@implementation DetailArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self loadResource];
}

-(void)createBarButtonItems
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setBackgroundImage:[UIImage imageNamed:@"comment.jpg"] forState:UIControlStateNormal];
  
    button.layer.cornerRadius = 20;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:10];
    [button setTitle:[NSString stringWithFormat:@"%ld",self.detailModel.counterList.comment] forState:UIControlStateNormal];
   
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    button.contentEdgeInsets = UIEdgeInsetsMake(25, 0, 0, 0);
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(60, 0, 40, 40);
    [button1 setBackgroundImage:[UIImage imageNamed:@"share.jpg"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(favoriteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    button1.titleLabel.font = [UIFont systemFontOfSize:10];
    [button1 setTitle:[NSString stringWithFormat:@"%ld",self.detailModel.counterList.like] forState:UIControlStateNormal];
    
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    button1.contentEdgeInsets = UIEdgeInsetsMake(25, 0, 0, 0);
    button1.layer.cornerRadius = 20;
    button1.clipsToBounds = YES;
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(110, 0, 40, 40);
    button2.layer.cornerRadius = 20;
    button2.clipsToBounds = YES;
    [button2 setBackgroundImage:[UIImage imageNamed:@"favorite.jpg"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithCustomView:button2];
    self.navigationItem.rightBarButtonItems = @[item3, item2,item1];
    
}
-(void)commentBtnClick:(UIButton *)button
{

}
-(void)favoriteBtnClick:(UIButton *)button
{

}
-(void)shareBtnClick:(UIButton *)button{
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55ff7968e0f55a8e7b001e12"shareText:@"你要分享的文字"
        shareImage:[UIImage imageNamed:@"icon.png"]shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToRenren,UMShareToDouban,UMShareToEmail,nil] delegate:self];
}
#pragma mark - AF
- (void)loadResource
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //拼接参数
    NSDictionary *dict = @{@"contentid":self.contentid,@"client":@(2)};
    [manager POST:kDetailArticleUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *listDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
           
            [self parserDataWithDictionary:listDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)parserDataWithDictionary:(NSDictionary *)dict
{
    NSDictionary *allDic = dict[@"data"];
    NSLog(@"%@",allDic);
    _detailModel = [[DetailArticleModel alloc]init];
    _detailModel.contentid  = allDic[@"contentid"];
    
     NSDictionary *userDic = allDic[@"userinfo"];
    UserinfoModel *userModel = [[UserinfoModel alloc]init];
    [userModel setValuesForKeysWithDictionary:userDic];
    _detailModel.userinfo = userModel;
    
    _detailModel.songid = allDic[@"songid"];
    NSDictionary *countDic = allDic[@"counterList"];
    CounterlistModel *counModel = [[CounterlistModel alloc]init];
    [counModel setValuesForKeysWithDictionary:countDic];
    _detailModel.counterList = counModel;
    
    _detailModel.islike = allDic[@"islike"];
    _detailModel.isfav = allDic[@"isfav"];
    _detailModel.html = allDic[@"html"];
    _detailModel.imglist = allDic[@"imglisht"];
    
     NSDictionary *shareDic = allDic[@"shareinfo"];
    ShareinfoModel *shareModel = [[ShareinfoModel alloc]init];
    [shareModel setValuesForKeysWithDictionary:shareDic];
    _detailModel.shareinfo = shareModel;
    
    NSDictionary *topicDic = allDic[@"topicInfo"];
    [_detailModel.topicInfo setValuesForKeysWithDictionary:topicDic];
    
     NSDictionary *tingDic = allDic[@"tingInfo"];
    [_detailModel.tingInfo setValuesForKeysWithDictionary:tingDic];
    
    _detailModel.typeid = [allDic[@"typeid"] integerValue];
    _detailModel.typename = allDic[@"typename"];
   
    self.webView.scalesPageToFit = YES;
    self.webView.delegate= self;
    [self createBarButtonItems];
    [self.webView loadHTMLString:_detailModel.html baseURL:nil];
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    webView.scalesPageToFit = YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    //$(window).width() ; $(window).height() ;
        NSString * srt = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust = '100%'";
        [_webView stringByEvaluatingJavaScriptFromString:srt];
        [webView stringByEvaluatingJavaScriptFromString:
         @"var script = document.createElement('script');"
         "script.type = 'text/javascript';"
         "script.text = \"function ResizeImages() { "
         "var myimg,oldwidth,height;"
         "var maxwidth=320;" //缩放系数
         "for(i=0;i <document.images.length;i++){"
         "myimg = document.images[i];"
         "if(myimg.width > maxwidth){"
         "oldwidth = myimg.width;"
         "height = myimg.height/myimg.width;"
         "myimg.width = maxwidth;"
         "myimg.height =height * maxwidth;"
         "}"
         "}"
         "}\";"
         "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
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
