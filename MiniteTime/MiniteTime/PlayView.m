//
//  PlayView.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/24.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "PlayView.h"

@implementation PlayView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
        self.backgroundColor = [UIColor cyanColor];
    }
    return self;
}
-(void)setUp{
    
    self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50, self.frame.size.width-100, self.frame.size.width-100)];
    [self addSubview:self.coverImageView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.coverImageView.frame.origin.x, CGRectGetMaxY(self.coverImageView.frame)+5, self.coverImageView.frame.size.width, 40)];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(60, CGRectGetMaxY(self.titleLabel.frame)+40, self.frame.size.width-120, 20)];
    [self addSubview:self.slider];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
