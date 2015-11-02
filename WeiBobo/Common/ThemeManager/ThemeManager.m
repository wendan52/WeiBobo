//
//  ThemeManager.m
//  WeiBobo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager
{
    NSDictionary *_themeConfig;// /Skins/cat
    NSDictionary *_colorConfig;
}
//实现单例，整个程序运行期间 只创建一个管家对象
+ (ThemeManager *)sharInstance {
    static ThemeManager *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[[self class]alloc]init];
    });
    return instance;
}

//1.png
//路径 ＋1.png
-(instancetype)init {
    if (self = [super init]) {
        
        //读取本地持久化存储的主题名字
        _themeName = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeName];
        if (_themeName.length == 0) {
            _themeName = @"Cat";
        }
        
        //02读取theme.plist
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        _themeConfig = [NSDictionary dictionaryWithContentsOfFile:configPath];
        
        //03 读取config.plist
        NSString *themePath = [self themePath];
        NSString *filePath = [themePath stringByAppendingPathComponent:@"config.plist"];
        _colorConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    return self;
}

-(void)setThemeName:(NSString *)themeName {
    if (![_themeName isEqualToString:themeName]) {
        _themeName = [themeName copy];
        
        //01 把主题名字存到plist中
        [[NSUserDefaults standardUserDefaults] setObject:_themeName forKey:kThemeName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //02 读取config.plist
        NSString *themePath = [self themePath];
        NSString *filePath = [themePath stringByAppendingPathComponent:@"config.plist"];
        _colorConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        //03 当主题名字改变的时候 发通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:nil];
    }
}

-(UIImage *)getThemeImage:(NSString *)imageName {
    //获取 主题包路径
    NSString *themePath = [self themePath];
    //拼接 主题路径 ＋ imageName
    NSString *filePath = [themePath stringByAppendingPathComponent:imageName];
    //得到 UIImage
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}

-(UIColor *)getThemeColor:(NSString *)colorName {
    //01 读取config.plist中对应colorName名字的字典
    NSDictionary *rgbDic = [_colorConfig objectForKey:colorName];
    CGFloat r = [rgbDic[@"R"] floatValue];
    CGFloat g = [rgbDic[@"G"] floatValue];
    CGFloat b = [rgbDic[@"B"] floatValue];
    CGFloat alpha = 1;
    if (rgbDic[@"alpha"] != nil) {
        alpha = [rgbDic[@"alpha"] floatValue];
    }
    
    //02 创建UIColor
    UIColor *themeColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
    return themeColor;
}

//获取主题包路径
-(NSString *)themePath {
    
    NSString *resPath = [[NSBundle mainBundle] resourcePath]; // + /Skins/cat
    NSString *pathSufix = [_themeConfig objectForKey:self.themeName];// Skins/cat
    NSString *path = [resPath stringByAppendingPathComponent:pathSufix];
    return path;
}
@end
