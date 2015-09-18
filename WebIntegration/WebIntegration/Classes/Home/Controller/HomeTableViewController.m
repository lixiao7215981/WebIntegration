//
//  HomeTableViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/18.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "HomeTableViewController.h"
#import "HomePurifierTableViewCell.h"
#import "HomeTableHeadView.h"
#import "MenuViewController.h"
#import "AddDeviceViewController.h"
#import "HomeWebTableViewCell.h"
#import "DetailWebViewController.h"

@interface HomeTableViewController ()<MQTT_ToolDelegate>
{
    CoreLocationTool *locationTool;
    SkywareJSApiTool *_jsApiTool;
    BOOL isExample;
}
@end

@implementation HomeTableViewController

static NSString * const HomeTableViewCell = @"HomeWebTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navView setNavigationBarHiddenShowBtn:YES];
    self.displayNav = YES;
    self.tableView.backgroundColor = kRGBColor(238, 238, 238, 1);
    self.tableView.separatorStyle = UITableViewScrollPositionNone;
    _jsApiTool = [[SkywareJSApiTool alloc] init];
    
    // 创建 MQTT
    MQTT_Tool *mqtt = [MQTT_Tool sharedMQTT_Tool];
    mqtt.delegate = self;
    
    // 设置本地空气质量
    [self addHeadViewCoverView];
    // 设置Nav 左右两边的按钮
    [self addLeftRightBtn];
    
    //    [self addDataList];
    //    [self getUserBindDevices];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserBindDevices];
}

- (void)getUserBindDevices
{
    [SkywareDeviceManagement DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
        isExample = NO;
        [self.dataList removeAllObjects];
        NSArray *deviceArray = [SkywareDeviceInfoModel objectArrayWithKeyValuesArray:result.result];
        [deviceArray enumerateObjectsUsingBlock:^(SkywareDeviceInfoModel *dev, NSUInteger idx, BOOL *stop) {
            BaseCellItemGroup *group = nil;
            if (!idx) {
                group = [BaseCellItemGroup createGroupWithHeadTitle:@"设备清单" AndFooterTitle:nil OrItem:nil];
            }else{
                UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
                headView.backgroundColor = [UIColor clearColor];
                group = [BaseCellItemGroup createGroupWithHeadView:headView AndFootView:nil OrItem:nil];
            }
            
            [group addObjectWith:dev];
            // 订阅设备
            [MQTT_Tool subscribeToTopicWithMAC:dev.device_mac atLevel:0];
            [self.dataList addObject:group];
        }];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        isExample = YES;
        [self.dataList removeAllObjects];
        BaseArrowCellItem *item = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:nil SubTitle:nil ClickOption:nil];
        BaseCellItemGroup *group = [BaseCellItemGroup createGroupWithHeadTitle:@"示例设备" AndFooterTitle:nil OrItem:@[item]];
        [self.dataList addObject:group];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
}

- (void) addDataList
{
    BaseArrowCellItem *cell1 = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"Test" SubTitle:nil ClickOption:nil];
    BaseCellItemGroup *group1 = [BaseCellItemGroup createGroupWithHeadTitle:@"示例设备" AndFooterTitle:nil OrItem:nil];
    BaseCellItemGroup *group2 = [BaseCellItemGroup createGroupWithHeadTitle:@"设备清单" AndFooterTitle:nil OrItem:nil];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    footView.backgroundColor = [UIColor clearColor];
    
    BaseCellItemGroup *group3 = [BaseCellItemGroup createGroupWithHeadView:headView AndFootView:footView OrItem:nil];
    
    [group1 addObjectWith:cell1];
    [group2 addObjectWith:cell1];
    [group3 addObjectWith:cell1];
    
    [self.dataList addObject:group1];
    [self.dataList addObject:group2];
    [self.dataList addObject:group3];
}

#pragma mark - MQTT ----Delegate
- (void)MQTTnewMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos
{
    NSLog(@"--Cell_MQTT:%@",[data JSONString]);
    SkywareMQTTModel *model = [SkywareMQTTTool conversionMQTTResultWithData:data];
    NSArray *cells = [self.tableView visibleCells];
    [cells enumerateObjectsUsingBlock:^(HomeWebTableViewCell *cell, NSUInteger idx, BOOL *stop) {
        if([cell.deviceInfo.device_mac isEqualToString:model.mac]){
            [_jsApiTool onRecvDevStatusData:data ToWebView:cell.webView];
        }
    }];
}

#pragma mark - Table view data source

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeWebTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeTableViewCell];
    if (cell == nil) {
        cell = [HomeWebTableViewCell createTableViewCell];
    }
    if (isExample) {
        cell.URLString = @"http://wx.skyware.com.cn/demofurnace/examplebar.html";
        
    }else{
        cell.URLString = @"http://wx.skyware.com.cn/demofurnace/bar.html";
        BaseCellItemGroup *group = self.dataList[indexPath.section];
        cell.deviceInfo = [group.item firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailWebViewController *detail = [[DetailWebViewController alloc] init];
    if (isExample) {
        detail.URLString = @"http://wx.skyware.com.cn/demofurnace/exampleindex.html";
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        detail.URLString = @"http://wx.skyware.com.cn/demofurnace/index.html";
        BaseCellItemGroup *group = self.dataList[indexPath.section];
        detail.deviceInfo = [group.item firstObject];
        [self.navigationController pushViewController:detail animated:YES];
    }
}


/**
 *  添加HeadView 和 头部纯色View
 */
- (void) addHeadViewCoverView
{
    UIView *coverHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, -350, kWindowWidth, 500)];
    coverHeadView.backgroundColor = kRGBColor(81, 167, 232, 1);
    [self.tableView insertSubview:coverHeadView atIndex:0];
    
    HomeTableHeadView *Headview = (HomeTableHeadView*) [HomeTableHeadView craeteHeadView];
    self.tableView.tableHeaderView = Headview;
}

/**
 *  添加左右两边的按钮
 */
- (void) addLeftRightBtn
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
    [leftBtn setTitle:@"添加设备" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftBtn setImage:[UIImage imageNamed:@"add_default"]forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(navLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView setLeftView:leftBtn];
    
    __block typeof(self) navCon = self;
    [self setRightBtnWithImage:[UIImage imageNamed:@"home_menu"] orTitle:nil ClickOption:^{
        MenuViewController *menu = [[MenuViewController alloc] init];
        [navCon.navigationController pushViewController:menu animated:YES];
    }];
}

- (void) navLeftBtnClick
{
    AddDeviceViewController *deviceVC = [[AddDeviceViewController alloc] init];
    deviceVC.isAddDevice = YES;
    [self.navigationController pushViewController:deviceVC animated:YES];
}

- (void)dealloc
{
    NSLog(@"HomeDetail");
}

@end
