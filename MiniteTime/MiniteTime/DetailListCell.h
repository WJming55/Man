//
//  DetailListCell.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/23.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailListModel.h"
@interface DetailListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
-(void)showDataWithModel:(DetailListModel *)model;
@end
