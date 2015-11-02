//
//  MoreTableViewCell.m
//  WeiBobo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "MoreTableViewCell.h"
#import "ThemeManager.h"

@implementation MoreTableViewCell

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _createView];
        [self themeChanged];
        //通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

-(void)_createView {
    _themImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
    _label = [[ThemeLabel alloc] initWithFrame:CGRectMake(42, 10, 200, 20)];
    _showTheme = [[ThemeLabel alloc] initWithFrame:CGRectMake(kScreenWidth-130, 10, 100, 20)];
    _showTheme.colorName = @"More_Item_Text_color";
    _label.colorName = @"More_Item_Text_color";
    
    _showTheme.font = [UIFont systemFontOfSize:14];
    _label.font = [UIFont boldSystemFontOfSize:16];
    _showTheme.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_themImageView];
    [self.contentView addSubview:_label];
    [self.contentView addSubview:_showTheme];
}

-(void)themeChanged {
    ThemeManager *manager = [ThemeManager sharInstance];
    self.backgroundColor = [manager getThemeColor:@"More_Item_color"];
}
@end
