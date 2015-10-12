//
//  ArticleCell.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/19.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListModel.h"
@interface ArticleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
-(void)showDataWithModel:(ArticleListModel *)model;
@end
