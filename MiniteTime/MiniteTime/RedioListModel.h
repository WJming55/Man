//
//  RedioListModel.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/23.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "XFModel.h"

@class RedioUser;
@interface RedioListModel : XFModel

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) BOOL isnew;

@property (nonatomic, strong) RedioUser *userinfo;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) NSString *radioid;

@property (nonatomic, copy) NSString *coverimg;

@end
@interface RedioUser : XFModel

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *uname;

@property (nonatomic, copy) NSString *icon;

@end

