//
//  MoreTableViewCell.h
//  WeiBobo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeImageView.h"
#import "ThemeLabel.h"
@interface MoreTableViewCell : UITableViewCell

@property(nonatomic,strong)ThemeImageView *themImageView;
@property(nonatomic,strong)ThemeLabel *label;
@property(nonatomic,strong)ThemeLabel *showTheme;
@end
