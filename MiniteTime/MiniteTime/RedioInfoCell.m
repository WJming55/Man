//
//  RedioInfoCell.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/24.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "RedioInfoCell.h"

@implementation RedioInfoCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)showDataWithModel:(DetailListModel *)model{
    self.titleLabel.text = model.title;
    self.authorLabel.text = [NSString stringWithFormat:@"by:%@",model.playInfo.authorinfo.uname];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
