//
//  DetailArticleModel.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/19.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "XFModel.h"

@class UserinfoModel,TopicinfoModel,TinginfoModel,ShareinfoModel,CounterlistModel;
@interface DetailArticleModel : XFModel

@property (nonatomic, copy) NSString *html;

@property (nonatomic, assign) NSInteger typeid;

@property (nonatomic, strong) UserinfoModel *userinfo;

@property (nonatomic, copy) NSString *typename;

@property (nonatomic, strong) CounterlistModel *counterList;

@property (nonatomic, assign) BOOL isfav;

@property (nonatomic, strong) NSArray *imglist;

@property (nonatomic, strong) TopicinfoModel *topicInfo;

@property (nonatomic, strong) TinginfoModel *tingInfo;

@property (nonatomic, copy) NSString *contentid;

@property (nonatomic, strong) ShareinfoModel *shareinfo;

@property (nonatomic, assign) BOOL islike;

@property (nonatomic, copy) NSString *songid;

@end
@interface UserinfoModel : NSObject

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *uname;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) BOOL isfollow;

@end

@interface TopicinfoModel : NSObject

@end

@interface TinginfoModel : NSObject

@end

@interface ShareinfoModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *text;

@end

@interface CounterlistModel : NSObject

@property (nonatomic, assign) NSInteger comment;

@property (nonatomic, assign) NSInteger like;

@end

