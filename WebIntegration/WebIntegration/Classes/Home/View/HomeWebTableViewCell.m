//
//  HomeWebTableViewCell.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/26.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "HomeWebTableViewCell.h"

@interface HomeWebTableViewCell ()<UIWebViewDelegate>
{
    SkywareJSApiTool *_jsApiTool;
}

@end

@implementation HomeWebTableViewCell

+ (instancetype) createTableViewCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HomeWebTableViewCell" owner:self options:nil] lastObject];
}

- (void)awakeFromNib
{
    _webView.delegate =  self;
    _jsApiTool = [[SkywareJSApiTool alloc] init];
}

- (void)setURLString:(NSString *)URLString
{
    _URLString = URLString;
    [self.webView loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return [_jsApiTool JSApiSubStringRequestWith:request WebView:webView DeviceInfo:_deviceInfo];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    NSLog(@"%@",_deviceInfo);
}


@end
