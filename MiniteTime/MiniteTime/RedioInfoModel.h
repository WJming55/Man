//
//  RedioInfoModel.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/24.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "XFModel.h"
#import "DetailListModel.h"
@interface RedioInfoModel : XFModel

@property (nonatomic, copy) NSString *tingid;

@property (nonatomic, assign) BOOL islike;

@property (nonatomic, copy) NSString *ting_contentid;

@property (nonatomic, assign) BOOL isfav;

@property (nonatomic, assign) NSInteger like;

@property (nonatomic, copy) NSString *contentid;

@property (nonatomic, assign) NSInteger comment;

@property (nonatomic, copy) NSString *radioid;

@property (nonatomic, copy) NSString *radioname;
@property (nonatomic , strong)PlayModel *redioPlayInfo;
@property (nonatomic , strong)NSMutableArray *moreTingArr;
@end
