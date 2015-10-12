//
//  topView.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/23.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "topView.h"
#import <UIImageView+WebCache.h>
@implementation TopView
{
    UIImageView *_coverImageView;
    UIImageView *_iconImageView;
    UILabel *_autherLabel;
    UILabel *_titleLabel;
    UIImageView *_soundImageView;
    UILabel *_numLabel;
}
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
-(void)setUp{
    _coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-80)];
    
    [self addSubview:_coverImageView];
    
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.frame.size.height-75, 45, 45)];
    _iconImageView.layer.cornerRadius = 22.5;
    _iconImageView.clipsToBounds = YES;
    
    [self addSubview:_iconImageView];
    
    _autherLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+5, self.frame.size.height-70, 150, 35)];
    _autherLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_autherLabel];
    
    _soundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-120, self.frame.size.height-65, 10, 10)];
    _soundImageView.image = [UIImage imageNamed:@"umeng_fb_audio_play_default"];
    [self addSubview:_soundImageView];
    
    _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_soundImageView.frame)+5, self.frame.size.height-75, 80, 30)];
    _numLabel.font= [UIFont systemFontOfSize:10];
   
    [self addSubview:_numLabel];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.frame.size.height -30, self.frame.size.width-40, 30)];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.numberOfLines = 0;
       [self addSubview:_titleLabel];
}
-(void)showDataWithModel:(RedioListModel *)model{
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]placeholderImage:[UIImage imageNamed:@"last.jpeg"]];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.userinfo.icon]placeholderImage:[UIImage imageNamed:@"dropdown_anim__00020"]];
    _autherLabel.text = model.userinfo.uname;
     _numLabel.text =[NSString stringWithFormat:@"%ld",model.count];
    _titleLabel.text = model.desc;

}
@end
