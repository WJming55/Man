//
//  TimeLineListCell.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/28.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "TimeLineListCell.h"
#import <UIImageView+WebCache.h>
@implementation TimeLineListCell

- (void)awakeFromNib {
    self.headImage.layer.cornerRadius = 15;
    self.headImage.clipsToBounds = YES;
    [self.like setBackgroundImage:[[UIImage imageNamed:@"favorite_w"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.like.selected = NO;
    [self.like setBackgroundImage:[[UIImage imageNamed:@"favorite_bl.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
}
-(void)showDataWithModel:(TimeLineModel *)model{
    if (self.infoImageView.frame.size.height>0) {
        self.infoImageView.frame = CGRectZero;
    }
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.userinfo.icon]];
    self.unameLabel.text = model.userinfo.uname;
    self.addTimeLabel.text = model.addtime_f;
    
    if (model.coverimg_wh.length != 0) {
        NSArray * wh = [model.coverimg_wh componentsSeparatedByString:@"*"];
        CGFloat with = [wh[0] doubleValue];
        CGFloat height = [wh[1] doubleValue];
        CGFloat imageH =(self.frame.size.width-20)*height/with;
        self.infoImageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 20+30, self.frame.size.width-20, imageH)];
        [self.infoImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed:@"last.jpeg"]];
        self.infoImageView.layer.masksToBounds = YES;
        self.infoImageView.layer.cornerRadius = 5;
        [self addSubview:self.infoImageView];
        
    }
    self.contentLabel.text = model.content;
    //NSLog(@"%@",self.contentLabel.text);
    if (model.tag_info.tag.length != 0) {
        self.tagImage.hidden = NO;
        self.tagLabel.hidden = NO;
        self.tagLabel.text =[NSString stringWithFormat:@"%@·%ld", model.tag_info.tag,model.tag_info.count];
    }else{
        self.tagImage.hidden = YES;
        self.tagLabel.hidden = YES;
    }
    if (model.counterList.comment!=0) {
        self.commentLabel.hidden = NO;
        self.commentLabel.text =[NSString stringWithFormat:@"%ld" ,model.counterList.comment];
       
    }else
    {
        self.commentLabel.hidden = YES;
    }
    if (model.counterList.like != 0) {
        self.likeLabel.hidden = NO;
        self.likeLabel.text =[NSString stringWithFormat:@"%ld" ,model.counterList.like];
    }else
    {
        self.likeLabel.hidden = YES;
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeClick:(id)sender {
    self.like.selected = !self.like.selected;
    
   
    
}
@end
