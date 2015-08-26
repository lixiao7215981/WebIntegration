//
//  HomeWebTableViewCell.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/26.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "HomeWebTableViewCell.h"

@interface HomeWebTableViewCell ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HomeWebTableViewCell

+ (instancetype) createTableViewCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HomeWebTableViewCell" owner:self options:nil] lastObject];
}

- (void)awakeFromNib
{
    _webView.delegate =  self;
}

- (void)layoutSubviews
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wx.skyware.com.cn/demofurnace/bar.html"]]];
}


@end
