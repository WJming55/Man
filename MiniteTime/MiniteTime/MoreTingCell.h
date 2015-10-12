//
//  MoreTingCell.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/24.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailListModel.h"
@interface MoreTingCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
-(void)showDataWithModel:(DetailListModel *)model;
@end
