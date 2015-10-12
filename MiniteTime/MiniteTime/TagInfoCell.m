//
//  TagInfoCell.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/28.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "TagInfoCell.h"
#import <UIImageView+WebCache.h>
@implementation TagInfoCell

- (void)awakeFromNib {
    self.headImageView.layer.cornerRadius = 25;
    self.headImageView.clipsToBounds = YES;
}
- (void)showDataWithModel:(CommentListModel *)model{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.userinfo.icon] placeholderImage:[UIImage imageNamed:@"last.jpeg"]];
    self.unameLabel.text = model.userinfo.uname;
    NSLog(@"%@",model.userinfo.uname);
    self.timeLabel.text = model.addtime_f;
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    if (model.reuserinfo.uname) {
        self.contentLabel.text = [NSString stringWithFormat:@"回复 %@: %@",model.reuserinfo.uname ,model.content];
    }else{
        self.contentLabel.text = model.content;
    }
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
