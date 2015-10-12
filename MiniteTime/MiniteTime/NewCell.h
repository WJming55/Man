//
//  NewCell.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/20.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewestModel.h"
@interface NewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortContent;


-(void)showDataWithModel:(NewestModel *)model;
@end
