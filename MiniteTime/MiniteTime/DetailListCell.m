//
//  DetailListCell.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/23.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "DetailListCell.h"
#import <UIImageView+WebCache.h>
@implementation DetailListCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)showDataWithModel:(DetailListModel *)model{
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    self.titleLabel.text = model.title;
    self.numberLabel.text = model.musicVisit;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
