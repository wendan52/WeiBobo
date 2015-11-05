//
//  MoreViewController.m
//  WeiBobo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 wendan. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreTableViewCell.h"
#import "ThemeTableViewController.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "ThemeManager.h"
#import "ThemeLabel.h"

@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,SinaWeiboDelegate>
{
    UITableView *_tableView;
    SinaWeibo *_sinaWeibo;
}
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建tableView
    [self _createTableView];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _sinaWeibo = delegate.sinaWeibo;
    _sinaWeibo.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)_createTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[MoreTableViewCell class] forCellReuseIdentifier:@"moreCell"];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else{
    return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MoreTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"moreCell"];
    if (cell == nil) {
        cell = [[MoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreCell"];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.label.text = @"主题选择";
            cell.showTheme.text = [ThemeManager sharInstance].themeName;
            cell.themImageView.imageName = @"more_icon_theme.png";
        }
        if (indexPath.row == 1) {
            cell.label.text = @"账户管理";
            cell.themImageView.imageName = @"more_icon_account.png";
        }
    }
    else if (indexPath.section == 1) {
        cell.label.text = @"意见反馈";
        cell.themImageView.imageName = @"more_icon_feedback.png";
    }
    else if (indexPath.section == 2) {
        if ([_sinaWeibo isLoggedIn]) {
            cell.label.text = @"登出当前账号";
        }else {
            cell.label.text = @"登录";
        }
        cell.label.textAlignment = NSTextAlignmentCenter;
    }
    
    //设置箭头
    if (indexPath.section != 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //主题选择
    if (indexPath.section == 0 && indexPath.row == 0) {
        ThemeTableViewController *themeTable = [[ThemeTableViewController alloc] init];
        [self.navigationController pushViewController:themeTable animated:YES];
    }
    //登出
    if (indexPath.section == 2 && indexPath.row == 0) {
        if ([_sinaWeibo isLoggedIn]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认登出么?"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确认", nil];
            [alert show];
        }else{
            [_sinaWeibo logIn];
        }
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [_sinaWeibo logOut];
        [self removeAuthData];
        [_tableView reloadData];
    }
}

//存储新浪微博登陆数据
- (void)storeAuthData
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              _sinaWeibo.accessToken, @"AccessTokenKey",
                              _sinaWeibo.expirationDate, @"ExpirationDateKey",
                              _sinaWeibo.userID, @"UserIDKey",
                              _sinaWeibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"MySinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//移除新浪微博登陆数据
- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MySinaWeiboAuthData"];
}


#pragma mark - SinaWeibo delegate
-(void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo {
    [[[UIAlertView alloc] initWithTitle:@"登陆成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    [self storeAuthData];
    [_tableView reloadData];
}
@end
