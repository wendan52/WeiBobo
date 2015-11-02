//
//  BaseViewController.m
//  WeiBobo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeManager.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "ThemeButton.h"
#import "MBProgressHUD.h"
#import "UIViewExt.h"
#import "UIProgressView+AFNetworking.h"
#import "AFHTTPRequestOperation.h"

@interface BaseViewController ()

@end

@implementation BaseViewController{
    MBProgressHUD *_hud;
    UIView *_activeView;
    UIWindow *_tipWindow;
}

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

-(void)viewWillAppear:(BOOL)animated {
    [self _loadImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - 进度显示
-(void)showHud:(NSString *)title {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud show:YES];
//    _hud.labelFont = [UIFont systemFontOfSize:10];
    _hud.labelText = title;
    _hud.dimBackground = YES;//阴影
}

-(void)hidHud{
    [_hud hide:YES];
}

-(void)completeHud:(NSString *)title {
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    [_hud hide:YES afterDelay:1];
}

#pragma mark - 自己写进度提示
-(void)showActiveView:(BOOL)show {
    
    if (_activeView == nil) {
        //创建一个UIView
        _activeView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2-30, kScreenWidth, 20)];
        _activeView.backgroundColor = [UIColor clearColor];
        //创建“菊花”
        UIActivityIndicatorView *indicatorV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorV.tag = 200;
        [_activeView addSubview:indicatorV];
        //创建 label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"正在加载...";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
        [label sizeToFit];
        [_activeView addSubview:label];
        
        label.left = (kScreenWidth-label.width)/2;
        indicatorV.right = label.left-5;
        
    }
    if (show) {
        
        UIActivityIndicatorView *indicatorV = (UIActivityIndicatorView *)[_activeView viewWithTag:200];
        [indicatorV startAnimating];
        [self.view addSubview:_activeView];
    }else{
        UIActivityIndicatorView *indicatorV = (UIActivityIndicatorView *)[_activeView viewWithTag:200];
        [indicatorV stopAnimating];
        [_activeView removeFromSuperview];
    }
    
}


-(void)_loadImage {
    ThemeManager *manager = [ThemeManager sharInstance];
    //视图背景
    UIImage *bgImage = [manager getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
}
//设置导航栏左边按钮
-(void)setNavItem {
    //设置nav左按钮
    ThemeButton *leftButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 95, 35)];
    leftButton.normalImageName = @"group_btn_all_on_title.png";
    leftButton.bgNormalImageName = @"button_title.png";
    [leftButton setTitle:@"设置" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftButton addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    
    //设置nav右按钮
    ThemeButton *rightButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightButton.normalImageName = @"button_icon_plus.png";
    rightButton.bgNormalImageName = @"button_m.png";
    [rightButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

-(void)setAction {
    MMDrawerController *mmDraw = self.mm_drawerController;
    [mmDraw openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)editAction {
    MMDrawerController *mmDraw = self.mm_drawerController;
    [mmDraw openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

//显示进度条
-(void)showStatusTip:(NSString *)title show:(BOOL)show operation:(AFHTTPRequestOperation *)operation{
    if (_tipWindow == nil) {
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tipWindow.backgroundColor = [UIColor blackColor];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:_tipWindow.bounds];
        label.text = title;
        label.tag = 100;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [_tipWindow addSubview:label];
        
        //进度条
        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressView.frame = CGRectMake(0, 20-3, kScreenWidth, 3);
        progressView.tag = 101;
        progressView.progress = 0.0;
        [_tipWindow addSubview:progressView];
        
    }
    UILabel *label = (UILabel *)[_tipWindow viewWithTag:100];
    label.text = title;
    UIProgressView *progressView = (UIProgressView *)[_tipWindow viewWithTag:101];
    
    if (show) {
        [_tipWindow setHidden:NO];
        if (operation != nil) {
            progressView.hidden = NO;
            [progressView
             setProgressWithUploadProgressOfOperation:operation animated:YES];
        }else{
            progressView.hidden = YES;
        }
        
    }else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tipWindow setHidden:YES];
            _tipWindow = nil;
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
