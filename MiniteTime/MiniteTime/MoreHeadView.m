//
//  MoreHeadView.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/24.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "MoreHeadView.h"

@implementation MoreHeadView

- (void)awakeFromNib {
    self.djImageView.layer.cornerRadius = 20;
    self.djImageView.clipsToBounds = YES;
    self.authorImageView.layer.cornerRadius = 20;
    self.authorImageView.clipsToBounds= YES;
}

@end
