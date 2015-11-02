//
//  RightViewController.m
//  WeiBobo
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "RightViewController.h"
#import "ThemeButton.h"
#import "SendViewController.h"
#import "BaseNavigationController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "LocViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createFiveButton];
}

-(void)_createFiveButton {
    NSArray *imageNames = @[@"newbar_icon_1.png",
                            @"newbar_icon_2.png",
                            @"newbar_icon_3.png",
                            @"newbar_icon_4.png",
                            @"newbar_icon_5.png"];
    for (int i = 0; i < imageNames.count; i++) {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(10, 70+i*50, 40, 40)];
        button.normalImageName = imageNames[i];
        button.tag = i + 100;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

-(void)buttonAction:(ThemeButton *)button {
    NSInteger index = button.tag - 100;
    if (index == 0) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            //弹出发送微博控制器
            SendViewController *sendView = [[SendViewController alloc] init];
            //创建导航控制器
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:sendView];
            [self.mm_drawerController presentViewController:nav animated:YES completion:nil];
        }];
    }else if (index == 4){//附近商圈
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            
            LocViewController *vc = [[LocViewController alloc] init];
            vc.title = @"附近商圈";
            
            BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            [self.mm_drawerController presentViewController:baseNav animated:YES completion:nil];
        }];

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
