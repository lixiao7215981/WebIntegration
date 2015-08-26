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

@interface HomeTableViewController ()<UITableViewDelegate>

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
    [self addHeadViewCoverView];
    [self addLeftRightBtn];
    
//    [self addDataList];
    [self getUserBindDevices];
}

- (void)getUserBindDevices
{
    [SkywareDeviceManagement DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
        NSArray *deviceArray = [SkywareDeviceInfoModel objectArrayWithKeyValuesArray:result.result];
        NSLog(@"%ld",deviceArray.count);
    } failure:^(SkywareResult *result) {
        
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

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeWebTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeTableViewCell];
    if (cell == nil) {
        cell = [HomeWebTableViewCell createTableViewCell];
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
    NSLog(@"%ld",indexPath.section);
}


/**
 *  添加HeadView 和 头部纯色View
 */
- (void) addHeadViewCoverView
{
    UIView *coverHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, -350, kWindowWidth, 500)];
    coverHeadView.backgroundColor = kRGBColor(81, 167, 232, 1);
    [self.tableView insertSubview:coverHeadView atIndex:0];
    
    UIView *Headview = [HomeTableHeadView craeteHeadView];
    self.tableView.tableHeaderView = Headview;
    [Headview autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [Headview autoSetDimensionsToSize:CGSizeMake(kWindowWidth, 150)];
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


@end
