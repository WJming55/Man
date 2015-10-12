//
//  TagInfoController.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/28.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "TagInfoController.h"
#import "Define.h"
#import "TagInfoModel.h"
#import "CommentListModel.h"
#import "imageHtmlCell.h"
#import "TagInfoCell.h"
#import "LZXHelper.h"
#import "UMSocial.h"
@interface TagInfoController ()<UITableViewDataSource , UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic)CGSize size;
@property (nonatomic , strong)TagInfoModel *imageModel;
@property (nonatomic , strong)UIView *chatView;
@property (nonatomic , strong)UITextView *comment;
@property (nonatomic , copy)NSString *comID;
@property (nonatomic , strong)CommentListModel *comModel;
@end

@implementation TagInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createView];
    [self addRightButtons];
    [self loadResourceWithPage];
    [self addChatView];
    self.tabBarController.tabBar.hidden = YES;
   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)addChatView{
    self.chatView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
    self.chatView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.chatView];
    
    self.comment = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-55, 30)];
    self.comment.layer.cornerRadius = 5;
    [self.chatView addSubview:self.comment];
    
    UIButton *sent = [UIButton buttonWithType:UIButtonTypeSystem];
    sent.frame = CGRectMake(self.view.frame.size.width-40, 7, 26, 26);
    [sent setBackgroundImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
    [sent addTarget:self action:@selector(sentComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.chatView addSubview:sent];
    
    //添加键盘监听事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //添加键盘消失监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillHide:(NSNotification *)note{
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40);
    _chatView.frame = CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40);
}
-(void)keyboardWillShow:(NSNotification *)note{
    //键盘出现，获取键盘视图的大小
    CGSize size = [note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    //tableView视图的frame 跟着改变
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-size.height);
    _chatView.frame = CGRectMake(0, self.view.frame.size.height-40-size.height, self.view.frame.size.width, 40);
}
-(void)sentComment:(UIButton *)button{
    if (self.comment.text.length>=1) {
        if (!self.comModel.contentid) {
            
            NSDictionary *commDic = @{@"contentid":self.model.contentid,@"content":self.comment.text,@"client":@(2),@"auth":@"DsI6ESXi9q9DC8Z8HcDpm1TJxQMOjPLWL8zhsDWRlcWP22NZNTx5Y4Pw"};
            [self postCommentWithCommentId:commDic];
        }else
        {
            NSLog(@"%@",self.comModel.contentid);
            NSDictionary *commDic = @{@"recid":self.comModel.contentid,@"contentid":self.self.model.contentid,@"content":self.comment.text,@"reuid":@(self.comModel.userinfo.uid),@"client":@(2),@"auth":@"DsI6ESXi9q9DC8Z8HcDpm1TJxQMOjPLWL8zhsDWRlcWP22NZNTx5Y4Pw"};
            [self postCommentWithCommentId:commDic];
        }
    }
}
-(void)postCommentWithCommentId:(NSDictionary *)dict{
  
        __weak typeof(self)weakSelf = self;
        [self.manager POST:@"http://api2.pianke.me/comment/add" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
            
            [weakSelf.comment resignFirstResponder];
            
            [weakSelf loadResourceWithPage];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    self.comModel = nil;
    self.comment.text = @"";
}
-(void)addRightButtons{
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(0, 5, 30, 30);
    [button1 setBackgroundImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(0, 5, 30, 30);
    [button2 setBackgroundImage:[UIImage imageNamed:@"favorite_w"] forState:UIControlStateNormal];
    button2.selected = NO;
    button2.tintColor = [UIColor clearColor];
    [button2 setBackgroundImage:[UIImage imageNamed:@"favorite_bl"] forState:UIControlStateSelected];
    [button2 addTarget:self action:@selector(favorite:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    button3.frame = CGRectMake(0, 5, 30, 30);
    [button3 setBackgroundImage:[UIImage imageNamed:@"share"]forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(shared:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithCustomView:button3];
    self.navigationItem.rightBarButtonItems = @[item3, item2,item1];

}
-(void)comment:(UIButton *)button{
    [self.comment becomeFirstResponder];

}
- (void)favorite:(UIButton *)button{
    button.selected = !button.selected;
}
- (void)shared:(UIButton *)button{
    [self.comment resignFirstResponder];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55ff7968e0f55a8e7b001e12"shareText:@"你要分享的文字"
                                     shareImage:[UIImage imageNamed:@"icon.png"]shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToEmail,nil] delegate:self];
}
-(void)initData
{
    self.dataArr = [[NSMutableArray alloc]init];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.imageModel = [[TagInfoModel alloc]init];
    self.comID = self.model.contentid;
    self.comModel = nil;
    self.comment.text = @"";
}
-(void)createView
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 40;
    [self.tableView registerNib:[UINib nibWithNibName:@"imageHtmlCell" bundle:nil] forCellReuseIdentifier:@"imageHtmlCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TagInfoCell" bundle:nil] forCellReuseIdentifier:@"TagInfoCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    UIImageView *tagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5,10, 40, 40)];
    tagImageView.layer.cornerRadius = 20;
    tagImageView.clipsToBounds = YES;
    [tagImageView sd_setImageWithURL:[NSURL URLWithString:self.model.userinfo.icon]];
    [head addSubview:tagImageView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(55, 15, 200, 30)];
    label.font = [UIFont systemFontOfSize:17];
    label.text = self.model.userinfo.uname;
    [head addSubview:label];
    
    self.tableView.tableHeaderView = head;
    
    [self.view addSubview:self.tableView];
}
#pragma mark - 下载内容
-(void)loadResourceWithPage
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    [MMProgressHUD showWithTitle:@"正在为您加载" status:@"isLoading...."];
    //设置请求参数
    //start=0&client=2&limit=10
    NSDictionary *dict = @{@"contentid":self.model.contentid,@"client":@(2),@"auth":@""};
    __weak typeof(self)weakSelf = self;
    [self.manager POST:kTimelineInfo parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [self parserDataWithDictionary:dict];
     
        [weakSelf.tableView reloadData];
        
        [MMProgressHUD dismissWithSuccess:@"加载完成"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MMProgressHUD dismissWithError:@"加载失败"];
    }];
}

//解析数据
-(void)parserDataWithDictionary:(NSDictionary *)dict
{
    NSDictionary *infoDic = dict[@"data"];
    
    self.imageModel.html = infoDic[@"html"];
    self.imageModel.imageList = infoDic[@"imglist"];
    
    NSArray *arr = infoDic[@"commentlist"];
   
    for (NSDictionary *comDic in arr) {
        CommentListModel *model = [[CommentListModel alloc]init];
        NSDictionary *usrDic = comDic[@"userinfo"];
        CommentUser *user = [[CommentUser alloc]init];
        [user setValuesForKeysWithDictionary:usrDic];
        model.userinfo = user;
        
        NSLog(@"%@",model.userinfo);
        model.contentid = comDic[@"contentid"];
        
        NSDictionary *reuserDic = comDic[@"reuserinfo"];
        Reuserinfo *reuser = [[Reuserinfo alloc]init];
        [reuser setValuesForKeysWithDictionary:reuserDic];
        model.reuserinfo = reuser;
        model.addtime_f = comDic[@"addtime_f"];
        model.content = comDic[@"content"];
        model.isdel = [comDic[@"isdel"] boolValue];
        model.likenum = [comDic[@"likenum"] integerValue];
        model.islike = [comDic[@"islike"] boolValue];
        [self.dataArr addObject:model];
    }
  
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0?1:self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0 )&&(indexPath.row == 0)) {
        imageHtmlCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageHtmlCell" forIndexPath:indexPath];
        [cell showDataWithModel:self.imageModel];
        return cell;
    }
    TagInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TagInfoCell" forIndexPath:indexPath];
    CommentListModel *model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat Height =70;
    if (indexPath.section == 0) {
      
        
    Height += [LZXHelper textHeightFromTextString:self.imageModel.html width:tableView.frame.size.width fontSize:15];
    
       
    }else{
        CommentListModel *model = [self.dataArr objectAtIndex:indexPath.row];
        Height += [LZXHelper textHeightFromTextString:model.content width:tableView.frame.size.width-40 fontSize:17];
    }
   
    
    return Height+10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ((section == 0)&&(self.model.tag_info.tag.length>1)) {
        UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        UIImageView *tagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5,20, 20, 20)];
        [tagImageView setImage:[UIImage imageNamed:@"tag_b"]];
        [foot addSubview:tagImageView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, 120, 20)];
        label.font = [UIFont systemFontOfSize:15];
    
            label.text =[NSString stringWithFormat:@"%@·%ld", self.model.tag_info.tag,self.model.tag_info.count];
            [foot addSubview:label];
        
        return foot;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ((self.model.tag_info.tag.length>0)&&(section == 0)) {
        return 60;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section!=0) {
        UIAlertView *alert = [[UIAlertView alloc]init];
        [alert addButtonWithTitle:@"回复"];
        
        alert.delegate = self;
        self.comModel = self.dataArr[indexPath.row];
        [alert show];
    }
}


#pragma mark - AlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.comment becomeFirstResponder];
        self.comID = self.comModel.contentid;
    }
    
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
