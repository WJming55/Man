//
//  RegistController.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/25.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "RegistController.h"
#import "ImageTool.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Define.h"
@interface RegistController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
- (IBAction)choseBtnClick:(UIButton *)sender;
- (IBAction)boyBtnClick:(UIButton *)sender;
- (IBAction)girlBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *boyBtn;
@property (weak, nonatomic) IBOutlet UIButton *girlBtn;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)finishBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (nonatomic , strong)NSNumber *sexNum;
@property (nonatomic , strong)UIImage *headImage;
@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;
@end

@implementation RegistController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
}
- (void)setUp{
    self.headImageView.layer.cornerRadius = 50;
    self.headImageView.clipsToBounds = YES;
    self.sexNum = @(1);
    self.headBtn.layer.cornerRadius = 50;
    self.headBtn.clipsToBounds = YES;
    
    self.boyBtn.layer.cornerRadius = 15;
    self.boyBtn.clipsToBounds = YES;
    [self.boyBtn setBackgroundImage:[UIImage imageNamed:@"boy"] forState:UIControlStateSelected];
    
    self.girlBtn.layer.cornerRadius = 15;
    self.girlBtn.clipsToBounds = YES;
    [self.girlBtn setBackgroundImage:[UIImage imageNamed:@"girl"] forState:UIControlStateSelected];
    
    self.finishBtn.layer.cornerRadius = 15;
    self.finishBtn.clipsToBounds = YES;
    
    self.password.secureTextEntry = YES;
    self.nickName.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nickName.delegate = self;
    self.email.delegate = self;
    self.password.delegate = self;
    self.email.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
    
}


- (IBAction)choseBtnClick:(UIButton *)sender {
    NSLog(@"选择图片");
    UIAlertView *alert = [[UIAlertView alloc]init];
    [alert addButtonWithTitle:@"相册"];
    [alert addButtonWithTitle:@"拍照"];
    alert.delegate = self;
    [alert show];
}
//选择上传图片，无论是相册还是拍照都是调用系统自带的试图控制器
-(void)loadImagePickerControllerWithType:(UIImagePickerControllerSourceType)type{
    //实例化一个UIImagePickerController（内部有相册和拍照功能模块）
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    
    //设置UIImagePickerController类型是相册还是拍照
    imagePicker.sourceType = type;
    
    //如果要处理choose和cancel按钮，那么要设置代理实现方法
    imagePicker.delegate = self;
    //是否允许编辑
    imagePicker.allowsEditing = YES;
    
    //imagePicker内部自带导航 所以要用模态跳转
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (IBAction)boyBtnClick:(UIButton *)sender {
   
    if (self.girlBtn.selected) {
        self.girlBtn.selected = NO;
    }
        self.sexNum = @(1);
        sender.selected = !sender.selected;
    
  
}

- (IBAction)girlBtnClick:(UIButton *)sender {
    
    if (self.boyBtn.selected) {
        self.boyBtn.selected = NO;
    }
        self.sexNum = @(2);
        sender.selected = !sender.selected;
   
   
}
- (IBAction)finishBtnClick:(UIButton *)sender {

    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer =[AFHTTPResponseSerializer serializer];

    if (self.nickName.text&&self.email.text&&self.password.text) {
        NSString *emailRegex = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
        BOOL B = [emailTest evaluateWithObject:self.email.text];
        [self showAlert:B];
     
      
     
        //设置参数
        NSDictionary *dict = @{@"uname":self.nickName.text,@"gender":self.sexNum,@"client":@(2),@"email":self.email.text,@"passwd":self.password.text};
        NSLog(@"%@",self.nickName.text);
    [self.manager POST:kRegistUrl parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
       
        NSString *filePath =[NSHomeDirectory() stringByAppendingPathComponent:@"headImage.jpg"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
       
        [formData appendPartWithFormData:data name:@"iconfile"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        if (responseObject) {
            NSDictionary *successDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",responseObject);
            
            NSLog(@"%@",successDic);
            if ([successDic[@"result"] isEqual: @(1)]) {
                NSDictionary *userDict = successDic[@"data"];
                NSString *token = userDict[@"auth"];
                NSString *uname = userDict[@"uname"];
                NSString *uid = userDict[@"uid"];
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:token forKey:@"auth"];
                [userDefault setObject:uname forKey:@"uname"];
                [userDefault setObject:uid forKey:@"uid"];
                [userDefault synchronize];
            }else{
            
                NSString * str = successDic[@"data"][@"msg"];
                NSLog(@"%@",str);
                UIAlertView *failAlert = [[UIAlertView alloc]initWithTitle:@"注册失败" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [failAlert show];
            }
          
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedFailureReason);
        NSLog(@"%@",error.localizedDescription);
    }];
    
    }else
    {
        UIAlertView *infoAlert = [[UIAlertView alloc]initWithTitle:@"注册格式不正确" message:@"请填写正确的信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [infoAlert show];
    }
}
-(void)showAlert:(BOOL)B{
    if (!B) {
        UIAlertView *emilalert = [[UIAlertView alloc]initWithTitle:@"邮箱格式不正确" message:@"请填写正确的邮箱" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [emilalert show];
    }
}
#pragma mark - 
#pragma mark - UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if (buttonIndex == 0) {
        [self loadImagePickerControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }
    if (buttonIndex == 1) {
        [self loadImagePickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
    }
}
#pragma mark -
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //获取资源类型
    NSString *sourceType = info[UIImagePickerControllerMediaType];
    if ([sourceType isEqualToString:(NSString *)kUTTypeImage]) {
        //判断资源是否是图片
        //是 获取图片资源UIImagePickerControllerEditedImage 可编辑的
        UIImage *image = info[UIImagePickerControllerEditedImage];
        
        //对图片重新设置大小
        UIImage *newImage = [[ImageTool shareTool]resizeImageToSize:self.headImageView.bounds.size sizeOfImage:image];
        //self.headImage = newImage;
        [self saveImage:newImage withName:@"headImage.jpg"];
        self.headImageView.image = newImage;
    }
    //返回
    [picker dismissViewControllerAnimated:YES completion:nil];

}
#pragma - mark -保存图片到沙盒
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName{
    NSData *imageData = UIImagePNGRepresentation(currentImage);
    //获取沙盒路径
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:imageName];
    NSLog(@"%@",fullPath);
    [imageData writeToFile:fullPath atomically:YES];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//取消选择涂片时调用
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //[super touchesBegan:touches withEvent:event];
    [self.nickName resignFirstResponder];
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
}
@end
