//
//  BaseTableViewController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/6/15.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSLayoutConstraint *_scrollHeight;
}
@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置tableview -> 从Xib中加载
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITableView class]] && view.tag == 0) {
            self.tableView = (UITableView *)view;
            break;
        }
    }
    // xib 中未找到TableView 手动创建
    if (!self.tableView) {
        self.tableView = [UITableView newAutoLayoutView];
        [self.view addSubview:self.tableView];
        [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
    
    // 设置TableView
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view bringSubviewToFront:self.navView];
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.dataList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"BaseTableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 如果有下拉图片就放大该图片
    if (self.scaleImage) {
        CGFloat down = -(_scaleHeight) - scrollView.contentOffset.y;
        if (down > 0){
            _scrollHeight.constant = _scaleHeight + down * 5;
        }
    }
    
    if (!_displayNav) return;
    UIColor *NavBackColor = self.navView.backViewBackColor;
    UIColor *blockColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.scaleImage) { // 有下拉图片
        if ((offsetY + _scaleHeight) > 0) {
            CGFloat alpha = 1 - ((100 - (offsetY + _scaleHeight)) / 100);
            [self.navView setScrollNavigationBarBackColor:[NavBackColor colorWithAlphaComponent:alpha]];
            [self.navView setScrollNavigationBarLineBackColor:[blockColor colorWithAlphaComponent:alpha]];
        } else {
            [self.navView setScrollNavigationBarBackColor:[NavBackColor colorWithAlphaComponent:0]];
            [self.navView setScrollNavigationBarLineBackColor:[blockColor colorWithAlphaComponent:0]];
        }
    }else{// 无下拉图片，滚动显示 NavBar
        if (offsetY > 0) {
            CGFloat alpha = 1 - ((100 - offsetY) / 100);
            [self.navView setScrollNavigationBarBackColor:[NavBackColor colorWithAlphaComponent:alpha]];
            [self.navView setScrollNavigationBarLineBackColor:[blockColor colorWithAlphaComponent:alpha]];
        } else {
            [self.navView setScrollNavigationBarBackColor:[NavBackColor colorWithAlphaComponent:0]];
            [self.navView setScrollNavigationBarLineBackColor:[blockColor colorWithAlphaComponent:0]];
        }
    }
}


#pragma mark - Method

/**
 *  实时滚动展示NavigationBar
 */
- (void)setDisplayNav:(BOOL)displayNav
{
    _displayNav = displayNav;
    if (displayNav) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.navView setScrollNavigationBarBackColor:[UIColor clearColor]];
        [self.navView setScrollNavigationBarLineBackColor:[UIColor clearColor]];
    }
}

/**
 *  设置下拉放大图片
 */
- (void)setScaleImage:(UIImage *)scaleImage
{
    _scaleImage = scaleImage;
    self.tableView.contentInset = UIEdgeInsetsMake(_scaleHeight, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -_scaleHeight);
    UIImageView *scralImageView = [UIImageView newAutoLayoutView];
    scralImageView.image = _scaleImage;
    [self.tableView insertSubview:scralImageView atIndex:0];
    [scralImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [scralImageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [scralImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    _scrollHeight = [scralImageView autoSetDimension:ALDimensionHeight toSize:_scaleHeight];
    scralImageView.contentMode = UIViewContentModeScaleAspectFill;
}

#pragma mark - 懒加载
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

@end
