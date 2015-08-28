//
//  DetailWebViewController.h
//  WebIntegration
//
//  Created by 李晓 on 15/8/26.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "BaseWebViewController.h"

@interface DetailWebViewController : BaseWebViewController

/**
 *  设备信息
 */
@property (nonatomic,strong) SkywareDeviceInfoModel *deviceInfo;
/**
 *  访问地址
 */
@property (nonatomic,copy) NSString *URLString;

@end
