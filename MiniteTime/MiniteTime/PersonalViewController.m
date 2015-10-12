//
//  PersonalViewController.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/19.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "PersonalViewController.h"
#import "RegistController.h"
#import "FindPswController.h"
#import "Define.h"
#import "ReadViewController.h"
#import "UMSocial.h"
@interface PersonalViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UITextField *passWordField;
- (IBAction)forgetPassword:(id)sender;
- (IBAction)logIn:(UIButton *)sender;
- (IBAction)weiboClick:(UIButton *)sender;
- (IBAction)qqLog:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *weiboButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;



@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRegistItem];
    [self setUp];
}
//添加注册按钮
-(void)addRegistItem{
    UIButton *regist = [UIButton buttonWithType:UIButtonTypeSystem];
    regist.frame = CGRectMake(0, 0, 40, 40);
    [regist setTitle:@"注册" forState:UIControlStateNormal];
    [regist addTarget:self action:@selector(goRegist:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *regItem = [[UIBarButtonItem alloc]initWithCustomView:regist];
    self.navigationItem.rightBarButtonItem = regItem;
}
-(void)goRegist:(UIButton *)button{
    RegistController *rvc =[[RegistController alloc]init];
    self.navigationController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rvc animated:YES];
}
-(void)setUp{
    self.weiboButton.layer.cornerRadius = 20;
    self.weiboButton.clipsToBounds = YES;
    [self.weiboButton setBackgroundImage:[UIImage imageNamed:@"icon_sina_pressed"] forState:UIControlStateNormal];
    
    self.qqButton.layer.cornerRadius = 20;
    self.qqButton.clipsToBounds = YES;
    [self.qqButton setBackgroundImage:[UIImage imageNamed:@"icon_qq_pressed"] forState:UIControlStateNormal];
    

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.nameField resignFirstResponder];
    [self.passWordField resignFirstResponder];
}


- (IBAction)forgetPassword:(id)sender {
    FindPswController *find = [[FindPswController alloc]init];
    find.urlStr = @"http://pianke.me/user/findpwd.php";
    [self.navigationController pushViewController:find animated:YES];
}
- (IBAction)logIn:(UIButton *)sender {
    if (self.nameField.text&&self.passWordField.text) {
        
        //设置参数
        NSDictionary *dict = @{@"client":@(2),@"email":self.nameField.text,@"passwd":self.passWordField.text};
        AFHTTPRequestOperationManager *manamger = [AFHTTPRequestOperationManager manager];
        manamger.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manamger POST:kLoginUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *successDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",successDic[@"data"][@"msg"]);
            NSLog(@"%@",successDic);
            if ([successDic[@"result"] isEqual: @(0)]) {
                NSString * str = successDic[@"data"][@"msg"];
                NSLog(@"%@",str);
                UIAlertView *failAlert = [[UIAlertView alloc]initWithTitle:@"注册失败" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [failAlert show];

            }else{
                ReadViewController *rvc = [[ReadViewController alloc]init];
                [self.navigationController pushViewController:rvc animated:YES];
                
            }
            

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
}

- (IBAction)weiboClick:(UIButton *)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //获取微博用户名 uid token 等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToSina];
        }
    });
    
    //授权完成后抵用获取用户信息的方法
    [[UMSocialDataService defaultDataService]requestSnsInformation:UMShareToSina completion:^(UMSocialResponseEntity *response) {
        
    }];
    
}

- (IBAction)qqLog:(UIButton *)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }});
}


@end
