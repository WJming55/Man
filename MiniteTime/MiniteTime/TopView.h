//
//  topView.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/23.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedioListModel.h"
@interface TopView : UIView

-(id)initWithFrame:(CGRect)frame;
-(void)showDataWithModel:(RedioListModel *)model;
@end
