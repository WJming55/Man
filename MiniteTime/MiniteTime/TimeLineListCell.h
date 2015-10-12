//
//  TimeLineListCell.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/28.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineModel.h"
@interface TimeLineListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *unameLabel;
- (IBAction)likeClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *tagImage;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIButton *like;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (nonatomic , strong)UIImageView *infoImageView;
-(void)showDataWithModel:(TimeLineModel *)model;
@end
