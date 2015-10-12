//
//  imageHtmlCell.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/28.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagInfoModel.h"
@interface imageHtmlCell : UITableViewCell <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (void)showDataWithModel:(TagInfoModel *)model;
@end
