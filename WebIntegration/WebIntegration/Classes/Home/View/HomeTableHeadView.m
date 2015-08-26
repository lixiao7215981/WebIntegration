//
//  HomeTableHeadView.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/18.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "HomeTableHeadView.h"

@implementation HomeTableHeadView

+ (UIView *)craeteHeadView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HomeTableHeadView" owner:nil options:nil] firstObject];
}

@end
