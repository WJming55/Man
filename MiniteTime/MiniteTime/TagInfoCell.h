//
//  TagInfoCell.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/28.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentListModel.h"
@interface TagInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *unameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
-(void)showDataWithModel:(CommentListModel *)model;
@end
