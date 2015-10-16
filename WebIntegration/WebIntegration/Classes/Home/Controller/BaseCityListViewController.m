//
//  BaseCityListViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/9/16.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "BaseCityListViewController.h"

#define sectionIndexTitles @"热"
#define sectionTitles @"热门城市"

@interface BaseCityListViewController ()<UITableViewDataSource,UITableViewDelegate>

/*** 城市数据 */
@property (nonatomic, strong) NSDictionary *cityData;
/*** 热门城市数据 */
@property (nonatomic, strong) NSDictionary *hotCitys;
/*** 城市首字母 */
@property (nonatomic, strong) NSMutableArray *keys;

@end

@implementation BaseCityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCityData];
    [self setNavTitle:@"城市列表"];
}

-(void)getCityData
{
    [self.keys addObjectsFromArray:[[self.cityData allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    //添加热门城市
    if (self.hotCitys.count) {
        [self.keys insertObject:sectionIndexTitles atIndex:0];
        [self.cityData setValue:[self.hotCitys objectForKey:sectionTitles] forKey:sectionIndexTitles];
    }
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.cityData valueForKey:self.keys[section]] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keys;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    headView.backgroundColor = kRGBColor(217, 217, 217, 1);
    UILabel *label = [UILabel newAutoLayoutView];
    [headView addSubview:label];
    [label autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    if ([self.keys[section] isEqualToString:sectionIndexTitles]) {
        label.text = sectionTitles;
    }else{
        label.text = self.keys[section];
    }
    return headView;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"BaseCityListCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    NSString *key = self.keys[indexPath.section];
    NSString *cityName = self.cityData[key][indexPath.row];
    cell.textLabel.text = cityName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectCityBlock) {
        NSString *key = self.keys[indexPath.section];
        NSString *cityName = self.cityData[key][indexPath.row];
        self.selectCityBlock(cityName);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (NSDictionary *)cityData
{
    if (!_cityData) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict" ofType:@"plist"];
        _cityData = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    }
    return _cityData;
}

- (NSDictionary *)hotCitys
{
    if (!_hotCitys) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"hotCityDict" ofType:@"plist"];
        _hotCitys = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    }
    return _hotCitys;
}


- (NSMutableArray *)keys
{
    if (!_keys) {
        _keys = [[NSMutableArray alloc] init];
    }
    return _keys;
}

@end
