//
//  ThemeImageView.m
//  WeiBobo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

-(void)setImageName:(NSString *)imageName {
    if (![_imageName isEqualToString:imageName]) {
        _imageName = [imageName copy];
        [self _loadImage];
    }
}

-(void)themeDidChange:(NSNotification *)notification {
    [self _loadImage];
}

-(void)_loadImage {
    ThemeManager *manager = [ThemeManager sharInstance];
    UIImage *image = [manager getThemeImage:self.imageName];
    image = [image stretchableImageWithLeftCapWidth:_leftCap topCapHeight:_topCap];
    self.image = image;
}
@end
