//
//  DetailWebViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/26.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DetailWebViewController.h"
#import "DeviceEditInfoViewController.h"
#import "SystemFeedBackViewController.h"

@interface DetailWebViewController ()<UIWebViewDelegate,SkywareJSApiToolDelegate,UIActionSheetDelegate>
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
    _jsApiTool.delegate = self;
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

#pragma mark - SkywareJSApiToolDelegate

- (void)SkywareJSApiWillShowMenu:(SkywareJSApiTool *)jsApiTool
{
    UIActionSheet *seet =  [[UIActionSheet alloc] initWithTitle:@"更多" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改设备名称",@"检查固件升级",@"解除绑定",@"反馈", nil] ;
    
    [seet showInView:[UIWindow getCurrentWindow]];
}

#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    NSLog(@"%ld",buttonIndex);
    WebInterest *interest = [WebInterest sharedWebInterest];
    if (interest.isExample) {
        [SVProgressHUD showInfoWithStatus:@"示例设备不支持该操作"];
        return;
    }
    switch (buttonIndex) {
        case 0: // 修改设备名称
        {
            DeviceEditInfoViewController *edit = [[DeviceEditInfoViewController alloc] initWithNibName:@"DeviceEditInfoViewController" bundle:nil];
            edit.DeviceInfo = _deviceInfo;
            [self.navigationController pushViewController:edit animated:YES];
        }
            break;
        case 1: // 检查固件升级
        {
            [SVProgressHUD showInfoWithStatus:@"敬请期待"];
        }
            break;
        case 2: // 解除绑定
        {
            [SkywareDeviceManagement DeviceReleaseUser:@[_deviceInfo.device_id] Success:^(SkywareResult *result) {
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(SkywareResult *result) {
                [SVProgressHUD showErrorWithStatus:@"解绑失败,请稍后重试"];
            }];
        }
            break;
        case 3: //反馈
        {
            SystemFeedBackViewController *feedBack = [[SystemFeedBackViewController alloc] initWithNibName:@"SystemFeedBackViewController" bundle:nil];
            [self.navigationController pushViewController:feedBack animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
