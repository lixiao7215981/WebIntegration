//
//  WebInterest.h
//  WebIntegration
//
//  Created by 李晓 on 15/10/16.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebInterest : NSObject
LXSingletonH(WebInterest)

/**
 *  是否为示例设备
 */
@property (nonatomic,assign) BOOL isExample;

@end
