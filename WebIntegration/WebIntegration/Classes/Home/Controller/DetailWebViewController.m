//
//  DetailWebViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/26.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DetailWebViewController.h"

@interface DetailWebViewController ()<UIWebViewDelegate>
{
    SkywareJSApiTool *_jsApiTool;
}
@end

@implementation DetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navView.hidden = YES;
    self.webView.delegate =self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView.scrollView.scrollEnabled = NO;
    _jsApiTool = [[SkywareJSApiTool alloc] init];
    [self.webView loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_URLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10]];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return [_jsApiTool JSApiSubStringRequestWith:request WebView:webView DeviceInfo:_deviceInfo];
}

- (void)setDeviceInfo:(SkywareDeviceInfoModel *)deviceInfo
{
    _deviceInfo = deviceInfo;
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    instance.device_id = deviceInfo.device_id;
    [kNotificationCenter addObserver:self selector:@selector(MQTTNewMessageData:) name:kTopic(deviceInfo.device_mac) object:nil];
}

#pragma mark - MQTT Notification

- (void)MQTTNewMessageData:(NSNotification *) notic
{
    NSData *data = notic.userInfo[@"data"];
    NSLog(@"--detail_MQTT:%@",[data JSONString]);
    [_jsApiTool onRecvDevStatusData:data ToWebView:self.webView];
}

- (void)dealloc
{
    NSLog(@"Detaildealloc");
}

@end
