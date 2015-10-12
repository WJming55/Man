//
//  ArticleCell.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/19.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "ArticleCell.h"
#import <UIImageView+WebCache.h>
@implementation ArticleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showDataWithModel:(ArticleListModel *)model
{
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    [self.articleImage sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed:@"last.jpeg"]];
}
@end
