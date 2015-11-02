//
//  BaseNavigationController.m
//  WeiBobo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//storyBoard创建的navigationviewcontroller初始调用这个方法
-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

-(void)themeDidChange:(NSNotification *)notification {
    [self _loadImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _loadImage];
}


-(void)_loadImage {
    ThemeManager *manager = [ThemeManager sharInstance];
    //导航栏背景
    UIImage *image = [manager getThemeImage:@"mask_titlebar64.png"];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //标题
    UIColor *color = [manager getThemeColor:@"Mask_Title_color"];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:color};
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
