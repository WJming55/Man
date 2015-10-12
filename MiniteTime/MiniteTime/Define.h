//
//  Define.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/18.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#ifndef MiniteTime_Define_h
#define MiniteTime_Define_h

#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <MMProgressHUD.h>

//首页精选
//http://api2.pianke.me/pub/today？（start=0&client=2&limit=10）

#define kHomeUrl @"http://api2.pianke.me/pub/today"
//
//首页动态
//需注册
//http://api2.pianke.me/user/feed （start=0&client=2&auth=Dswm3Qi2y861DC8ZzH8HukTJxQ5X5Y7DY8Ggm3UDFhcWP22NVPShpc6fk&limit=10）

#define kHomeUserUrl @"http://api2.pianke.me/user/feed"
//
//首页碎片
//
//http://api2.pianke.me/timeline/list （start=0&client=2&limit=10）

#define kHomeTimeUrl @"http://api2.pianke.me/timeline/list"
//

//碎片详情
#define kTimelineInfo @"http://api2.pianke.me/timeline/info"

//电台
//http://api2.pianke.me/ting/radio（client=2）

#define kRedioUrl @"http://api2.pianke.me/ting/radio"
//电台列表
#define kRedioList @"http://api2.pianke.me/ting/radio_list"

//电台详情

#define kRedioDetail @"http://api2.pianke.me/ting/radio_detail_list"
//阅读
//http://api2.pianke.me/read/columns（client=2）


#define kReadUrl @"http://api2.pianke.me/read/columns"
//

//阅读列表

#define kReadList @"http://api2.pianke.me/read/columns_detail"
//24小时
#define kReadLastUrl @"http://api2.pianke.me/read/latest"
//阅读文章详情
#define kDetailArticleUrl @"http://api2.pianke.me/article/info"
//参数 contentid=55f63c9b5d7743677f8b465c&client=2
//评论接口

#define kCommentUrl @"http://api2.pianke.me/comment/get"//参数contentid=55ee03a95d7743887d8b468c&start=0&client=2&limit=10
//社区接口

//社区最新接口
//
//http://api2.pianke.me/group/posts_hotlist（sort=addtime&start=0&client=2&limit=10）
//最新最热接口参数不同 sort = hot 最热 sort= addtime 最新

//话题
//http://api2.pianke.me/group/posts_hotlist （sort=hot&start=0&client=2&limit=10）

#define kHotGroupUrl @"http://api2.pianke.me/group/posts_hotlist"
//小组
//http://api2.pianke.me/group/group_list （sort=hot&start=0&client=2&auth=Dswm3Qi2y861DC8ZzH8HukTJxQ5X5Y7DY8Ggm3UDFhcWP22NVPShpc6fk&limit=10）

#define kGroupUrl @"http://api2.pianke.me/group/group_list"
//
//我的
//http://api2.pianke.me/group/my_join（start=0&client=2&auth=Dswm3Qi2y861DC8ZzH8HukTJxQ5X5Y7DY8Ggm3UDFhcWP22NVPShpc6fk&limit=10）

#define kMineUrl @"http://api2.pianke.me/group/my_join"
//


//
//良品接口
//
//http://api2.pianke.me/pub/shop（start=0&client=2&limit=10）

#define kShopUrl @"http://api2.pianke.me/pub/shop"
//
//标签接口
//http://api2.pianke.me/timeline/tags  （client=2）

#define kTagUrl @"http://api2.pianke.me/timeline/tags"
//
//
//
//注册接口
//
//http://api2.pianke.me/user/reg （uname=%E5%A4%A7%E5%A4%A7&gender=1&client=2&email=930417452%40qq.com&passwd=123456）

#define kRegistUrl @"http://api2.pianke.me/user/reg"





//登陆接口
//
//http://api2.pianke.me/user/login （client=2&email=938417452%40qq.com&passwd=19871001）

#define kLoginUrl @"http://api2.pianke.me/user/login"



#endif
