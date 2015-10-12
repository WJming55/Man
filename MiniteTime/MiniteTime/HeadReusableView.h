//
//  HeadReusableView.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/19.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMLoopView.h"
#import "ImageModel.h"
@interface HeadReusableView : UICollectionReusableView
@property (nonatomic , strong)WMLoopView *loopView;
@property (nonatomic , strong)NSMutableArray *imageArr;

@end
