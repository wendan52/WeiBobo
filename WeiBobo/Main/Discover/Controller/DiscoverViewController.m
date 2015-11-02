//
//  DiscoverViewController.m
//  WeiBobo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearByViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)nearWeibo:(UIButton *)sender {
    NearByViewController *nearBy = [[NearByViewController alloc] init];
    nearBy.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nearBy animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
