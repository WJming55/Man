//
//  PlayView.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/24.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayView : UIView
@property (nonatomic , strong)UIImageView *coverImageView;
@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UISlider *slider;
-(id)initWithFrame:(CGRect)frame;
@end
