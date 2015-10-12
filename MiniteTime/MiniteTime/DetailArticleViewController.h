//
//  DetailArticleViewController.h
//  MiniteTime
//
//  Created by XFShareField on 15/9/19.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailArticleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic , strong)NSString *contentid;
@end
