//
//  HomeTableHeadView.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/18.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "HomeTableHeadView.h"

@interface HomeTableHeadView()
{
    CoreLocationTool *locationTool;
}
/***  城市 */
@property (weak, nonatomic) IBOutlet UILabel *city;
/***  温度 */
@property (weak, nonatomic) IBOutlet UILabel *temperature;
/***  污染度 */
@property (weak, nonatomic) IBOutlet UILabel *pm25;
/***  风速，风向 */
@property (weak, nonatomic) IBOutlet UILabel *wind;

@end

@implementation HomeTableHeadView

+ (UIView *)craeteHeadView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HomeTableHeadView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    // 获取用户所在地的天气情况
    locationTool = [[CoreLocationTool alloc] init];
    [locationTool getLocation:^(CLLocation *location) {
        [locationTool reverseGeocodeLocation:location userAddress:^(UserAddressModel *userAddress) {
            SkywareWeatherModel *model = [[SkywareWeatherModel alloc] init];
            model.province = userAddress.State;
            model.city = userAddress.City;
            model.district = userAddress.SubLocality;
            [SkywareOthersManagement UserAddressWeatherParamesers:model Success:^(SkywareResult *result) {
                SkywareAddressWeatherModel *weath = [SkywareAddressWeatherModel objectWithKeyValues:result.result];
                self.city.text = weath.area_name;
                self.temperature.text = weath.temperature;
                self.pm25.text = [NSString stringWithFormat:@"%@·%@",weath.aqi,weath.aqiQuality];
                self.pm25.backgroundColor = weath.aqiBgColor;
                self.wind.text = [NSString stringWithFormat:@"%@%@ | 湿度%@",weath.wind_direct,weath.wind_power,weath.humidity];
            } failure:^(SkywareResult *result) {
                NSLog(@"%@",result);
            }];
        }];
    }];
}

@end
