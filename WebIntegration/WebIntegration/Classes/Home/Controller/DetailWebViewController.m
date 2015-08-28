//
//  DetailWebViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/26.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DetailWebViewController.h"
#import <MQTTClient/MQTTClient.h>

@interface DetailWebViewController ()<UIWebViewDelegate,MQTTSessionDelegate>
{
    SkywareJSApiTool *_jsApiTool;
    MQTTSession *_secction;
}
@end

@implementation DetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate =self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navView.hidden = YES;
    self.webView.scrollView.scrollEnabled = NO;
    
    [self.webView loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://wx.skyware.com.cn/demofurnace/index.html"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10]];
    _jsApiTool = [[SkywareJSApiTool alloc] init];
    
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
    // 创建 MQTT
    _secction = [[MQTTSession alloc] initWithClientId: [NSString stringWithFormat:@"%ld",instance.app_id]];
    [_secction setDelegate:self];
    [_secction connectAndWaitToHost:kMQTTServerHost port:1883 usingSSL:NO];
    [_secction subscribeToTopic:kTopic(deviceInfo.device_mac) atLevel:MQTTQosLevelAtLeastOnce];
}

#pragma mark - MQTT ----Delegate
- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid
{
    [_jsApiTool onRecvDevStatusData:data ToWebView:self.webView];
}

- (void)dealloc
{
    NSLog(@"Detaildealloc");
}



@end
