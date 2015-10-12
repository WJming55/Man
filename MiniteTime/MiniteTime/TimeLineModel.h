//
//  TimeLineModel.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/28.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "XFModel.h"

@class TimeCounter,Tag_Info,TimeUser;
@interface TimeLineModel : XFModel

@property (nonatomic, copy) NSString *songid;

@property (nonatomic, assign) NSInteger addtime;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) TimeUser *userinfo;

@property (nonatomic, copy) NSString *coverimg_wh;

@property (nonatomic, strong) TimeCounter *counterList;

@property (nonatomic, copy) NSString *addtime_f;

@property (nonatomic, assign) BOOL islike;

@property (nonatomic, copy) NSString *contentid;

@property (nonatomic, strong) Tag_Info *tag_info;

@property (nonatomic, copy) NSString *coverimg;

@end
@interface TimeCounter : NSObject

@property (nonatomic, assign) NSInteger comment;

@property (nonatomic, assign) NSInteger like;

@end

@interface Tag_Info : NSObject

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) BOOL offical;

@end

@interface TimeUser : NSObject

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *uname;

@property (nonatomic, copy) NSString *icon;

@end

