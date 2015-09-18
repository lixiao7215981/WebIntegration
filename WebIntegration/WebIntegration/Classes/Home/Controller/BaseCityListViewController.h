//
//  BaseCityListViewController.h
//  WebIntegration
//
//  Created by 李晓 on 15/9/16.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "BaseTableViewController.h"

typedef void (^cityBlock)(NSString *);

@interface BaseCityListViewController : BaseTableViewController
/**
 *  选中城市后返回城市名称block
 */
@property (nonatomic, copy) cityBlock selectCityBlock;


@end
