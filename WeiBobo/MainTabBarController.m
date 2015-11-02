//
//  MainTabBarController.m
//  WeiBobo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavigationController.h"
#import "ThemeImageView.h"
#import "ThemeButton.h"
#import "AppDelegate.h"
#import "ThemeLabel.h"

@interface MainTabBarController ()<SinaWeiboRequestDelegate>

@end

@implementation MainTabBarController
{
    ThemeImageView *_selectImageView;
    ThemeImageView *_newCountImgView;
    ThemeLabel *_newCountLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建自控制器
    [self _createSubControllers];
    //设置tabbarbutton
    [self _createTabBar];
    
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//定时刷新
-(void)timeAction{
    
    //网络请求数据
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = delegate.sinaWeibo;
    [sinaWeibo requestWithURL:unread_count
                       params:nil
                   httpMethod:@"GET"
                     delegate:self];
    
   }

//创建标签栏
-(void)_createTabBar {
    
    //01 移除tabbarbutton
    for (UIView *view  in self.view.subviews) {
        Class cls = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:cls]) {
            [view removeFromSuperview];
        }
    }
    //02 添加背景
    ThemeImageView *bgImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    bgImageView.imageName = @"mask_navbar.png";
    [self.tabBar addSubview:bgImageView];
    
    //按钮宽度
    CGFloat width = kScreenWidth/4;
    
    //03 选中图片
    _selectImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, width, 49)];
    _selectImageView.imageName = @"home_bottom_tab_arrow.png";
    [self.tabBar addSubview:_selectImageView];
    
    NSArray *imageNames = @[@"home_tab_icon_1.png",
                            @"home_tab_icon_3.png",
                            @"home_tab_icon_4.png",
                            @"home_tab_icon_5.png"];
    for (int i = 0; i < 4; i++) {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(i*width, 0, width, 49)];
        button.normalImageName = imageNames[i];
        button.tag = i;
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:button];
    }

    
}

-(void)selectAction:(UIButton *)button {
    self.selectedIndex = button.tag;
    [UIView animateWithDuration:.3 animations:^{
        _selectImageView.center = button.center;
    }];
}

//创建自控制器
-(void)_createSubControllers {
    
    NSArray *names = @[@"Home",@"Discover",@"Profile",@"More"];
    NSMutableArray *navArray = [NSMutableArray array];
    for (int i = 0; i<names.count; i++) {
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:names[i] bundle:nil];
        BaseNavigationController *nav = [storyBoard instantiateInitialViewController];
        [navArray addObject:nav];
    }
    self.viewControllers = navArray;
}

#pragma mark - SinaWeibo 代理
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    //number_notify_9.png
    //Timeline_Notice_color
    
    //未读数据
    NSNumber *status = [result objectForKey:@"status"];
    NSInteger count = [status integerValue];
    
    if (_newCountImgView == nil) {
        CGFloat buttonwidth = kScreenWidth/4;
        _newCountImgView = [[ThemeImageView alloc] initWithFrame:CGRectMake(buttonwidth-32, 0, 32, 32)];
        _newCountImgView.imageName = @"number_notify_9.png";
        [self.tabBar addSubview:_newCountImgView];
        
        _newCountLabel = [[ThemeLabel alloc] initWithFrame:_newCountImgView.bounds];
        _newCountLabel.textAlignment = NSTextAlignmentCenter;
        _newCountLabel.colorName = @"Timeline_Notice_color";
        _newCountLabel.font = [UIFont systemFontOfSize:13];
        [_newCountImgView addSubview:_newCountLabel];
    }
    
    if (count > 0) {
        _newCountImgView.hidden = NO;
        if (count > 99) {
            count = 99;
        }
        _newCountLabel.text = [NSString stringWithFormat:@"%li",count];
    }else{
        _newCountImgView.hidden = YES;
    }
    
}

@end
