//
//  AppDelegate.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/18.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "AppDelegate.h"
#import <SMS_SDK/SMS_SDK.h>
#import <SkywareUIInstance.h>

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"



#import "UserLoginViewController.h"

#define SMS_SDKAppKey    @"a61caeae67ea"
#define SMS_SDKAppSecret  @"b285bf5ce014fc48101f86be1229f0af"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UserLoginViewController *loginRegister = [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateInitialViewController];
    self.window.rootViewController = loginRegister;
    self.navigationController = (UINavigationController *)loginRegister;
    [self.window makeKeyAndVisible];
    
    // 设置 App_id
    SkywareInstanceModel *skywareInstance = [SkywareInstanceModel sharedSkywareInstanceModel];
    skywareInstance.app_id = 1;
    
    // 设置弹出框后不可操作
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:kRGBColor(230, 230, 230, 1)];
    
    SkywareUIInstance *UIM = [SkywareUIInstance sharedSkywareUIInstance];
    UIM.All_button_bgColor = kSystemAllBtnColor;
    UIM.All_view_bgColor = kSystemAllBackageColor;
    
    LXFrameWorkInstance *LXM = [LXFrameWorkInstance sharedLXFrameWorkInstance];
    LXM.NavigationBar_bgColor = kSystemAllBtnColor;
    LXM.NavigationBar_textColor = [UIColor whiteColor];
    LXM.backState = writeBase;
    
    // 启动ShareSDK 的短信功能
    [SMS_SDK registerApp:SMS_SDKAppKey withSecret:SMS_SDKAppSecret];
    [SMS_SDK enableAppContactFriends:NO];
    
    
    // 第三方分享
    [ShareSDK registerApp:@"a685cc4f5ad5"];//字符串api20为您的ShareSDK的AppKey
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"956046342"
                               appSecret:@"4f98152cf5565cdb62b5f61d503bafba"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"956046342"
                                appSecret:@"4f98152cf5565cdb62b5f61d503bafba"
                              redirectUri:@"https://api.weibo.com/oauth2/default.html"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://dev.t.qq.com "];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1104657979"
                           appSecret:@"Y3BatkoUlsXzDt4u"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址   http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:@"1104657979"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:@"wxb243a421ddef2ab2"
                           appSecret:@"e2f5a5168efcd646c95d292f8231e88e"
                           wechatCls:[WXApi class]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
//    [MQTT_Tool initialize];
    NSLog(@"applicationDidBecomeActiveapplicationDidBecomeActiveapplicationDidBecomeActiveapplicationDidBecomeActive");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"applicationWillTerminate");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
