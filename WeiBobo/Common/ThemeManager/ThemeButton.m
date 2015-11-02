//
//  ThemeButton.m
//  WeiBobo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton

-(void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //注册通知监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}
-(void)themeDidChange:(NSNotification *)notification {
    [self _loadImage];
}

-(void)setNormalImageName:(NSString *)normalImageName {
    if (![_normalImageName isEqualToString:normalImageName]) {
        _normalImageName = [normalImageName copy];
        [self _loadImage];
    }
}
-(void)setBgNormalImageName:(NSString *)bgNormalImageName {
    if (![_bgNormalImageName isEqualToString:bgNormalImageName]) {
        _bgNormalImageName = [bgNormalImageName copy];
        [self _loadImage];
    }
}
-(void)_loadImage {
    ThemeManager *manager = [ThemeManager sharInstance];
    if (_normalImageName != nil) {
        UIImage *image = [manager getThemeImage:_normalImageName];
        if (image != nil) {
            [self setImage:image forState:UIControlStateNormal];
        }
    }
    if (_bgNormalImageName != nil) {
        UIImage *image = [manager getThemeImage:_bgNormalImageName];
        if (image != nil) {
            [self setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
}
@end
