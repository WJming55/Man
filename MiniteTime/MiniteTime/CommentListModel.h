//
//  CommentListModel.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/28.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "XFModel.h"

@class Reuserinfo,CommentUser;
@interface CommentListModel : XFModel

@property (nonatomic, strong) Reuserinfo *reuserinfo;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) BOOL islike;

@property (nonatomic, strong) CommentUser *userinfo;

@property (nonatomic, copy) NSString *addtime_f;

@property (nonatomic, copy) NSString *contentid;

@property (nonatomic, assign) BOOL isdel;

@property (nonatomic, assign) NSInteger likenum;

@end
@interface Reuserinfo : XFModel

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *uname;

@property (nonatomic, copy) NSString *icon;

@end

@interface CommentUser : XFModel

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *uname;

@property (nonatomic, copy) NSString *icon;

@end

