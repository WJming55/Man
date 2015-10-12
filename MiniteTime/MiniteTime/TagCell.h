//
//  TagCell.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/28.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagModel.h"
@interface TagCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (weak, nonatomic) IBOutlet UIImageView *foreImageView;

@property (weak, nonatomic) IBOutlet UIImageView *imagView;
-(void)showDataWithModel:(TagModel *)model;
@end
