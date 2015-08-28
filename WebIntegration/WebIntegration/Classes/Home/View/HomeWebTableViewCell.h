//
//  HomeWebTableViewCell.h
//  WebIntegration
//
//  Created by 李晓 on 15/8/26.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeWebTableViewCell : UITableViewCell

/**
 *  UIWebView
 */
@property (weak, nonatomic) IBOutlet UIWebView *webView;
/**
 *  访问地址
 */
@property (nonatomic,copy) NSString *URLString;
/**
 *  设备信息
 */
@property (nonatomic,strong) SkywareDeviceInfoModel *deviceInfo;
/**
 *  创建TableViewCell
 */
+ (instancetype) createTableViewCell;



@end
