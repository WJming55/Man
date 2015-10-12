//
//  TagModel.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/28.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "XFModel.h"

@interface TagModel : XFModel

@property (nonatomic, assign) BOOL offical;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) BOOL top;

@property (nonatomic, copy) NSString *tag;

@end
