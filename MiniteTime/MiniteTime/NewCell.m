//
//  NewCell.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/20.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "NewCell.h"
#import <UIImageView+WebCache.h>
@implementation NewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showDataWithModel:(NewestModel *)model
{
   
        
        self.titleLabel.text = model.title;
        self.shortContent.text = model.shortcontent;
    
}
@end
