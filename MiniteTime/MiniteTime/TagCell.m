//
//  TagCell.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/28.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "TagCell.h"
#import <UIImageView+WebCache.h>
@implementation TagCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)showDataWithModel:(TagModel *)model{
    [self.imagView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"last.jpeg"]];
    
    self.tagLabel.text = model.tag;
    self.counterLabel.text = [NSString stringWithFormat:@"%ld条",(long)model.count];
}
@end
