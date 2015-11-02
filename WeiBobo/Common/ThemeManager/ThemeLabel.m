//
//  ThemeLabel.m
//  WeiBobo
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"

@implementation ThemeLabel

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        //监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorChange:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

-(void)awakeFromNib {
    //监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorChange:) name:kThemeDidChangeNotification object:nil];
}

-(void)setColorName:(NSString *)colorName {
    if (![_colorName isEqualToString:colorName]) {
        _colorName = [colorName copy];
        [self _loadColor];
    }
}

-(void)colorChange:(NSNotification *)notification {
    [self _loadColor];
}

-(void)_loadColor {
    ThemeManager *manager = [ThemeManager sharInstance];
    if (_colorName != nil) {
        self.textColor = [manager getThemeColor:_colorName];
    }
}
@end
