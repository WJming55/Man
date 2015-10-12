//
//  ReadCell.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/19.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadHomeModel.h"
@interface ReadCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
-(void)showDataWithModel:(ReadHomeModel *)model;
@end
