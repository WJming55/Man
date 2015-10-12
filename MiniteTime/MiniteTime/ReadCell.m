//
//  ReadCell.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/19.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "ReadCell.h"
#import <UIImageView+WebCache.h>
@implementation ReadCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)showDataWithModel:(ReadHomeModel *)model
{
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@·%@",model.name,model.enname];
}
@end
