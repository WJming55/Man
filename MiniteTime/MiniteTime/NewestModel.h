//
//  NewestModel.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/20.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "XFModel.h"

@class CounterModel,UserModel;
@interface NewestModel : XFModel

@property (nonatomic, assign) BOOL islike;

@property (nonatomic, assign) NSInteger addtime;

@property (nonatomic, strong) UserModel *userinfo;

@property (nonatomic, copy) NSString *shortcontent;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *addtime_f;

@property (nonatomic, copy) NSString *firstimage;

@property (nonatomic, strong) CounterModel *counterList;

@property (nonatomic, copy) NSString *contentid;

@end
@interface CounterModel : NSObject

@property (nonatomic, assign) NSInteger fav;

@property (nonatomic, assign) NSInteger vote;

@property (nonatomic, assign) NSInteger comment;

@property (nonatomic, assign) NSInteger view;

@property (nonatomic, assign) NSInteger like;

@end

@interface UserModel : NSObject

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *uname;

@property (nonatomic, copy) NSString *icon;

@end

