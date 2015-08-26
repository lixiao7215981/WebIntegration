//
//  HomePurifierTableViewCell.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "HomePurifierTableViewCell.h"

@implementation HomePurifierTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (instancetype) createTableViewCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HomePurifierTableViewCell" owner:self options:nil] lastObject];
}

@end
