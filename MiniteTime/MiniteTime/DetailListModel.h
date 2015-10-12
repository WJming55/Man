//
//  DetailListModel.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/23.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "XFModel.h"

@class PlayModel,RedioAuther,RedioShareinfo,RedioDetailUser;
@interface DetailListModel : XFModel

@property (nonatomic, copy) NSString *tingid;

@property (nonatomic, copy) NSString *musicVisit;

@property (nonatomic, copy) NSString *musicUrl;

@property (nonatomic, assign) BOOL isnew;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *coverimg;

@property (nonatomic, strong) PlayModel *playInfo;

@end
@interface PlayModel : XFModel

@property (nonatomic, copy) NSString *tingid;

@property (nonatomic, copy) NSString *ting_contentid;

@property (nonatomic, strong) RedioDetailUser *userinfo;

@property (nonatomic, copy) NSString *sharepic;

@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, copy) NSString *musicUrl;

@property (nonatomic, strong) RedioAuther *authorinfo;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *sharetext;

@property (nonatomic, copy) NSString *shareurl;

@property (nonatomic, strong) RedioShareinfo *shareinfo;

@property (nonatomic, copy) NSString *webview_url;

@end

@interface RedioAuther : XFModel

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *uname;

@property (nonatomic, copy) NSString *icon;

@end

@interface RedioShareinfo : XFModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *text;

@end

@interface RedioDetailUser :XFModel

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *uname;

@property (nonatomic, copy) NSString *icon;

@end

