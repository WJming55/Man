//
//  imageHtmlCell.m
//  MiniteTime
//
//  Created by XFShareField on 15/9/28.
//  Copyright (c) 2015年 XieFei. All rights reserved.
//

#import "imageHtmlCell.h"

@implementation imageHtmlCell 

- (void)awakeFromNib {
    // Initialization code
}
-(void)showDataWithModel:(TagInfoModel *)model{

    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = NO;
    //self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.delegate = self;
    [self.webView loadHTMLString:model.html baseURL:nil];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    webView.scalesPageToFit = YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    //$(window).width() ; $(window).height() ;
    NSString * srt = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust = '100%'";
    [webView stringByEvaluatingJavaScriptFromString:srt];
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth,height;"
     "var maxwidth=375;" //缩放系数
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "height = myimg.height/myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.height =height * maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}

@end
