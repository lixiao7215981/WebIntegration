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
    self.navView.hidden = YES;
    self.webView.delegate =self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView.scrollView.scrollEnabled = NO;
    _jsApiTool = [[SkywareJSApiTool alloc] init];
     [self.webView loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_URLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest-------%ld",_secction.status);
    return [_jsApiTool JSApiSubStringRequestWith:request WebView:webView DeviceInfo:_deviceInfo];
}

- (void)setDeviceInfo:(SkywareDeviceInfoModel *)deviceInfo
{
    _deviceInfo = deviceInfo;
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    instance.device_id = deviceInfo.device_id;
    // 创建 MQTT
    _secction = [[MQTTSession alloc] initWithClientId: [NSString stringWithFormat:@"%@",instance.device_id]];
    [_secction setDelegate:self];
    [_secction connectAndWaitToHost:kMQTTServerHost port:1883 usingSSL:NO];
    [_secction subscribeToTopic:kTopic(deviceInfo.device_mac) atLevel:MQTTQosLevelAtLeastOnce];
}

#pragma mark - MQTT ----Delegate
- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid
{
    NSLog(@"--detail_MQTT:%@",[data JSONString]);
    [_jsApiTool onRecvDevStatusData:data ToWebView:self.webView];
}

- (void)dealloc
{
    NSLog(@"Detaildealloc");
}



@end
