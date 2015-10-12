//
//  MoreTingCell.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/24.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "MoreTingCell.h"
#import <UIImageView+WebCache.h>
@implementation MoreTingCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)showDataWithModel:(DetailListModel *)model{
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]placeholderImage:[UIImage imageNamed:@"last.jpeg"]];
    self.titleLabel.text = model.title;
}
@end
