//
//  RedioListCell.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/23.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "RedioListCell.h"
#import <UIImageView+WebCache.h>
@implementation RedioListCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)showDataWithModel:(RedioListModel *)model
{
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    self.title.text = model.title;
    self.autherLabel.text = [NSString stringWithFormat:@"by:%@",model.userinfo.uname];
    self.descLabel.text = model.desc;
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld",model.count];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
